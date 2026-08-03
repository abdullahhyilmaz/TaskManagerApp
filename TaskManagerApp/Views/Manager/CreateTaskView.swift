import SwiftUI

struct CreateTaskView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedAssignee: AppUser = MockData.employees[0]
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    @State private var subtasks: [Subtask] = []
    @State private var newSubtaskTitle: String = ""

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

                Section("Atanan Kişi") {
                    Picker("Çalışan", selection: $selectedAssignee) {
                        ForEach(MockData.employees) { employee in
                            Text(employee.name).tag(employee)
                        }
                    }
                }

                Section("Son Tarih") {
                    Toggle("Son tarih belirle", isOn: $hasDueDate.animation())
                    if hasDueDate {
                        DatePicker("Tarih", selection: $dueDate, displayedComponents: .date)
                    }
                }

                Section("Alt Görevler") {
                    ForEach(subtasks) { subtask in
                        Text(subtask.title)
                    }
                    .onDelete { indexSet in
                        subtasks.remove(atOffsets: indexSet)
                    }

                    HStack {
                        TextField("Yeni alt görev", text: $newSubtaskTitle)
                        Button {
                            addSubtask()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
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
        subtasks.append(Subtask(title: trimmed))
        newSubtaskTitle = ""
    }

    private func createTask() {
        let task = TaskItem(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            assignee: selectedAssignee,
            status: .todo,
            dueDate: hasDueDate ? dueDate : nil,
            subtasks: subtasks
        )
        onCreate(task)
        dismiss()
    }
}

#Preview {
    CreateTaskView { _ in }
}
