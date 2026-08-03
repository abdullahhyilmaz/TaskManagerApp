import Foundation
import Observation

@Observable
final class TaskStore {
    var tasks: [TaskItem]

    init(tasks: [TaskItem]? = nil) {
        if ProcessInfo.processInfo.arguments.contains("-uiTestReset") {
            try? FileManager.default.removeItem(at: Self.fileURL)
        }
        self.tasks = tasks ?? Self.load() ?? MockData.tasks
    }

    func tasks(assignedTo user: AppUser) -> [TaskItem] {
        tasks.filter { $0.assignee.id == user.id }
    }

    func task(withID id: TaskItem.ID) -> TaskItem? {
        tasks.first { $0.id == id }
    }

    func add(_ task: TaskItem) {
        tasks.append(task)
        save()
    }

    func delete(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
        save()
    }

    func setStatus(taskID: TaskItem.ID, status: TaskStatus) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].status = status
        save()
    }

    func toggleSubtask(taskID: TaskItem.ID, subtaskID: Subtask.ID) {
        guard let taskIndex = tasks.firstIndex(where: { $0.id == taskID }),
              let subIndex = tasks[taskIndex].subtasks.firstIndex(where: { $0.id == subtaskID }) else { return }
        tasks[taskIndex].subtasks[subIndex].isDone.toggle()
        tasks[taskIndex].status = tasks[taskIndex].statusFromSubtasks ?? tasks[taskIndex].status
        save()
    }

    private static var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("tasks.json")
    }

    private static func load() -> [TaskItem]? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode([TaskItem].self, from: data)
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(tasks) else { return }
        try? data.write(to: Self.fileURL, options: .atomic)
    }
}
