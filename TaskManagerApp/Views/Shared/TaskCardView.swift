import SwiftUI

struct TaskCardView: View {
    let task: TaskItem
    /// Belirtilirse ilerleme sadece bu kişiye atanan alt görevlere göre hesaplanır (çalışan görünümü); nil ise tüm alt görevler baz alınır (yönetici görünümü).
    var assigneeFilter: AppUser? = nil

    private var relevantSubtasks: [Subtask] {
        guard let assigneeFilter else { return task.subtasks }
        return task.subtasks.filter { $0.assignee.id == assigneeFilter.id }
    }

    private var completedCount: Int {
        relevantSubtasks.filter(\.isDone).count
    }

    private var progress: Double {
        guard !relevantSubtasks.isEmpty else { return 0 }
        return Double(completedCount) / Double(relevantSubtasks.count)
    }

    private var dueDateColor: Color {
        guard let dueDate = task.dueDate else { return .secondary }
        return dueDate < Date() && task.status != .done ? .red : .secondary
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(task.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)

            Label(task.owner.name, systemImage: "person.crop.circle")
                .font(.caption)
                .foregroundStyle(.secondary)

            if !relevantSubtasks.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(completedCount)/\(relevantSubtasks.count) alt görev")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    ProgressView(value: progress)
                        .tint(.blue)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: progress)
                }
            }

            if let dueDate = task.dueDate {
                Label(dueDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    .font(.caption2)
                    .foregroundStyle(dueDateColor)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(.separator, lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.04), radius: 3, y: 1)
    }
}

#Preview("Alt görevli") {
    TaskCardView(task: MockData.tasks[2])
        .padding()
        .background(Color(.systemGroupedBackground))
}

#Preview("Alt görevsiz") {
    TaskCardView(task: MockData.tasks[1])
        .padding()
        .background(Color(.systemGroupedBackground))
}
