import SwiftUI

struct TaskDetailView: View {
    @Environment(TaskStore.self) private var store
    let taskID: TaskItem.ID
    let isManager: Bool
    let currentUser: AppUser
    var onDelete: (() -> Void)?

    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false

    init(taskID: TaskItem.ID, isManager: Bool, currentUser: AppUser, onDelete: (() -> Void)? = nil) {
        self.taskID = taskID
        self.isManager = isManager
        self.currentUser = currentUser
        self.onDelete = onDelete
    }

    private var task: TaskItem? {
        store.task(withID: taskID)
    }

    /// Yönetici tüm alt görevleri görür; çalışan sadece kendisine atanmış olanları görür.
    private func visibleSubtasks(for task: TaskItem) -> [Subtask] {
        isManager ? task.subtasks : task.subtasks.filter { $0.assignee.id == currentUser.id }
    }

    var body: some View {
        if let task {
            content(for: task)
        } else {
            ContentUnavailableView("Görev bulunamadı", systemImage: "exclamationmark.triangle")
        }
    }

    @ViewBuilder
    private func content(for task: TaskItem) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(task.title)
                        .font(.title2.bold())

                    Label(task.owner.name, systemImage: "person.crop.circle")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if let dueDate = task.dueDate {
                        Label(dueDate.formatted(date: .long, time: .omitted), systemImage: "calendar")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Açıklama")
                        .font(.headline)
                    Text(task.description.isEmpty ? "Açıklama girilmemiş." : task.description)
                        .font(.body)
                        .foregroundStyle(task.description.isEmpty ? .secondary : .primary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Durum")
                        .font(.headline)
                    Picker("Durum", selection: Binding(
                        get: { task.status },
                        set: { store.setStatus(taskID: task.id, status: $0) }
                    )) {
                        ForEach(TaskStatus.allCases) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityIdentifier("statusPicker")
                }

                let mySubtasks = visibleSubtasks(for: task)
                if !mySubtasks.isEmpty {
                    let completedCount = mySubtasks.filter(\.isDone).count
                    let progress = Double(completedCount) / Double(mySubtasks.count)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Alt Görevler")
                                .font(.headline)
                            Spacer()
                            Text("\(completedCount)/\(mySubtasks.count)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        ProgressView(value: progress)
                            .tint(.blue)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: progress)

                        VStack(spacing: 0) {
                            ForEach(mySubtasks) { subtask in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        store.toggleSubtask(taskID: task.id, subtaskID: subtask.id)
                                    }
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: subtask.isDone ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(subtask.isDone ? .blue : .secondary)
                                            .font(.title3)
                                            .contentTransition(.symbolEffect(.replace))
                                            .accessibilityHidden(true)
                                        Text(subtask.title)
                                            .foregroundStyle(.primary)
                                            .strikethrough(subtask.isDone)
                                        Spacer()
                                        if isManager {
                                            Text(subtask.assignee.name)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 10)
                                }
                                .buttonStyle(.plain)

                                if subtask.id != mySubtasks.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                        .background(.background, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(.separator, lineWidth: 0.5)
                        )
                    }
                }

                if isManager {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Görevi Sil", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    .padding(.top, 8)
                }
            }
            .padding(20)
        }
        .navigationTitle("Görev Detayı")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Bu görevi silmek istediğinize emin misiniz?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Görevi Sil", role: .destructive) {
                onDelete?()
                dismiss()
            }
            Button("Vazgeç", role: .cancel) {}
        }
    }
}

#Preview("Yönetici - Alt görevli") {
    NavigationStack {
        TaskDetailView(taskID: MockData.tasks[2].id, isManager: true, currentUser: MockData.manager)
    }
    .environment(TaskStore())
}

#Preview("Çalışan - Kendi alt görevleri") {
    NavigationStack {
        TaskDetailView(taskID: MockData.tasks[0].id, isManager: false, currentUser: MockData.employees[0])
    }
    .environment(TaskStore())
}
