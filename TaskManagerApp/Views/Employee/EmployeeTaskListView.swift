import SwiftUI

struct EmployeeTaskListView: View {
    let currentUser: AppUser
    @Environment(TaskStore.self) private var store
    var onLogout: () -> Void

    @State private var statusError: String?

    private var tasks: [TaskItem] {
        store.tasks(assignedTo: currentUser)
    }

    private func tasks(for status: TaskStatus) -> [TaskItem] {
        tasks.filter { $0.status == status }
    }

    private func nextStatus(after status: TaskStatus) -> TaskStatus? {
        guard let index = TaskStatus.allCases.firstIndex(of: status) else { return nil }
        let nextIndex = index + 1
        return TaskStatus.allCases.indices.contains(nextIndex) ? TaskStatus.allCases[nextIndex] : nil
    }

    var body: some View {
        NavigationStack {
            Group {
                if tasks.isEmpty {
                    ContentUnavailableView(
                        "Henüz görev yok",
                        systemImage: "tray",
                        description: Text("Size atanmış bir görev bulunmuyor.")
                    )
                } else {
                    List {
                        ForEach(TaskStatus.allCases) { status in
                            let sectionTasks = tasks(for: status)
                            if !sectionTasks.isEmpty {
                                Section {
                                    ForEach(sectionTasks) { task in
                                        NavigationLink {
                                            TaskDetailView(taskID: task.id, isManager: false, currentUser: currentUser)
                                        } label: {
                                            TaskCardView(task: task, assigneeFilter: currentUser)
                                                .padding(.vertical, 4)
                                        }
                                        .listRowSeparator(.hidden)
                                        .swipeActions(edge: .trailing) {
                                            if let next = nextStatus(after: task.status) {
                                                Button {
                                                    withAnimation {
                                                        do {
                                                            try store.setStatus(taskID: task.id, status: next)
                                                        } catch {
                                                            statusError = error.localizedDescription
                                                        }
                                                    }
                                                } label: {
                                                    Label(next.rawValue, systemImage: next.symbolName)
                                                }
                                                .tint(.blue)
                                            }
                                        }
                                        .swipeActions(edge: .leading) {
                                            if task.status != .done {
                                                Button {
                                                    withAnimation {
                                                        do {
                                                            try store.setStatus(taskID: task.id, status: .done)
                                                        } catch {
                                                            statusError = error.localizedDescription
                                                        }
                                                    }
                                                } label: {
                                                    Label("Tamamlandı", systemImage: "checkmark.circle.fill")
                                                }
                                                .tint(.green)
                                            }
                                        }
                                    }
                                } header: {
                                    Label(status.rawValue, systemImage: status.symbolName)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Görevlerim")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(currentUser.name)
                            .font(.footnote.weight(.semibold))
                        Text("Çalışan")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Çıkış", action: onLogout)
                        .font(.subheadline)
                }
            }
            .alert(
                "İşlem Tamamlanamadı",
                isPresented: Binding(
                    get: { statusError != nil },
                    set: { if !$0 { statusError = nil } }
                )
            ) {
                Button("Tamam", role: .cancel) {}
            } message: {
                Text(statusError ?? "")
            }
        }
    }
}

#Preview("Dolu") {
    EmployeeTaskListView(currentUser: MockData.currentEmployee, onLogout: {})
        .environment(TaskStore())
}

#Preview("Boş") {
    EmployeeTaskListView(currentUser: MockData.employees[2], onLogout: {})
        .environment(TaskStore(tasks: []))
}
