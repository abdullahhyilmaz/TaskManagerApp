import SwiftUI

struct CreateTaskView: View {
    @Environment(\.dismiss) private var dismiss

    let currentUser: AppUser

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    @State private var subtasks: [Subtask] = []
    @State private var newSubtaskTitle: String = ""
    @State private var newSubtaskAssignee: AppUser = MockData.employees[0]

    var onCreate: (TaskItem) -> Void

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Görev Bilgileri") {
                    TextField("Başlık", text: $title)
                        .accessibilityIdentifier("titleField")
                    TextField("Açıklama", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Son Tarih") {
                    Toggle("Son tarih belirle", isOn: $hasDueDate.animation())
                    if hasDueDate {
                        DatePicker("Tarih", selection: $dueDate, displayedComponents: .date)
                    }
                }

                Section("Alt Görevler") {
                    ForEach(subtasks) { subtask in
                        HStack {
                            Text(subtask.title)
                            Spacer()
                            Text(subtask.assignee.name)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete { indexSet in
                        subtasks.remove(atOffsets: indexSet)
                    }

                    HStack {
                        TextField("Yeni alt görev", text: $newSubtaskTitle)
                            .accessibilityIdentifier("newSubtaskTitleField")

                        Menu {
                            ForEach(MockData.employees) { employee in
                                Button(employee.name) { newSubtaskAssignee = employee }
                            }
                        } label: {
                            Label(newSubtaskAssignee.name, systemImage: "person.crop.circle")
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .accessibilityIdentifier("newSubtaskAssigneeMenu")

                        Button {
                            addSubtask()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .accessibilityIdentifier("addSubtaskButton")
                        .disabled(newSubtaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
            .navigationTitle("Yeni Görev")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Oluştur") {
                        createTask()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }

    private func addSubtask() {
        let trimmed = newSubtaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        subtasks.append(Subtask(title: trimmed, assignee: newSubtaskAssignee))
        newSubtaskTitle = ""
    }

    private func createTask() {
        let task = TaskItem(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            owner: currentUser,
            status: .todo,
            dueDate: hasDueDate ? dueDate : nil,
            subtasks: subtasks
        )
        onCreate(task)
        dismiss()
    }
}

#Preview {
    CreateTaskView(currentUser: MockData.manager) { _ in }
}
