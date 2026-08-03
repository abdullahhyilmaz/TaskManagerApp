import Foundation

enum UserRole: String, CaseIterable, Identifiable, Codable {
    case manager = "Yönetici"
    case employee = "Çalışan"

    var id: String { rawValue }
}

struct AppUser: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var email: String
    var role: UserRole

    init(id: UUID = UUID(), name: String, email: String, role: UserRole) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
    }
}

enum TaskStatus: String, CaseIterable, Identifiable, Codable {
    case todo = "Yapılacak"
    case inProgress = "Devam Ediyor"
    case done = "Tamamlandı"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .todo: return "circle"
        case .inProgress: return "clock"
        case .done: return "checkmark.circle.fill"
        }
    }
}

struct Subtask: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var assignee: AppUser
    var isDone: Bool

    init(id: UUID = UUID(), title: String, assignee: AppUser, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.assignee = assignee
        self.isDone = isDone
    }
}

struct TaskItem: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var description: String
    /// Görevi oluşturan/takip eden yönetici. Alt görevler kendi assignee'lerine sahiptir, bu alan çalışan görünürlüğünde kullanılmaz.
    var owner: AppUser
    var status: TaskStatus
    var dueDate: Date?
    var subtasks: [Subtask]

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        owner: AppUser,
        status: TaskStatus,
        dueDate: Date? = nil,
        subtasks: [Subtask] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.owner = owner
        self.status = status
        self.dueDate = dueDate
        self.subtasks = subtasks
    }

    var completedSubtaskCount: Int {
        subtasks.filter(\.isDone).count
    }

    var subtaskProgress: Double {
        guard !subtasks.isEmpty else { return 0 }
        return Double(completedSubtaskCount) / Double(subtasks.count)
    }

    /// Alt görevlerin tamamlanma durumuna göre otomatik hesaplanan durum. Alt görev yoksa nil döner (manuel durum korunur).
    var statusFromSubtasks: TaskStatus? {
        guard !subtasks.isEmpty else { return nil }
        if completedSubtaskCount == 0 { return .todo }
        if completedSubtaskCount == subtasks.count { return .done }
        return .inProgress
    }
}
