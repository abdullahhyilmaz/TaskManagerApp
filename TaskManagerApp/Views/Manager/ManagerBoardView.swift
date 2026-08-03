import SwiftUI

struct ManagerBoardView: View {
    let currentUser: AppUser
    @Environment(TaskStore.self) private var store
    @State private var showCreateTask = false
    @State private var scrollPosition: TaskStatus?
    var onLogout: () -> Void

    private func tasks(for status: TaskStatus) -> [TaskItem] {
        store.tasks.filter { $0.status == status }
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.tasks.isEmpty {
                    ContentUnavailableView(
                        "Henüz görev yok",
                        systemImage: "tray",
                        description: Text("Sağ üstteki + butonuyla yeni bir görev oluşturun.")
                    )
                } else {
                    VStack(spacing: 8) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 16) {
                                ForEach(TaskStatus.allCases) { status in
                                    BoardColumnView(
                                        status: status,
                                        tasks: tasks(for: status),
                                        isManager: true,
                                        onDelete: store.delete
                                    )
                                    .id(status)
                                }
                            }
                            .scrollTargetLayout()
                            .padding(16)
                        }
                        .scrollPosition(id: $scrollPosition)

                        columnIndicator
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Görev Panosu")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(currentUser.name)
                            .font(.footnote.weight(.semibold))
                        Text("Yönetici")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showCreateTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Yeni Görev Oluştur")
                    .accessibilityIdentifier("createTaskButton")
                    Button("Çıkış", action: onLogout)
                        .font(.subheadline)
                }
            }
            .sheet(isPresented: $showCreateTask) {
                CreateTaskView { newTask in
                    store.add(newTask)
                }
            }
        }
    }

    private var columnIndicator: some View {
        HStack(spacing: 8) {
            ForEach(TaskStatus.allCases) { status in
                Capsule()
                    .fill(status == (scrollPosition ?? .todo) ? Color.accentColor : Color(.systemGray4))
                    .frame(width: status == (scrollPosition ?? .todo) ? 18 : 6, height: 6)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            scrollPosition = status
                        }
                    }
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: scrollPosition)
        .padding(.bottom, 4)
    }
}

private struct BoardColumnView: View {
    let status: TaskStatus
    let tasks: [TaskItem]
    let isManager: Bool
    var onDelete: (TaskItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(status.rawValue, systemImage: status.symbolName)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(tasks.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(.quaternary.opacity(0.5), in: Capsule())
            }

            if tasks.isEmpty {
                Text("Bu sütunda görev yok")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 24)
            } else {
                VStack(spacing: 10) {
                    ForEach(tasks) { task in
                        NavigationLink {
                            TaskDetailView(taskID: task.id, isManager: isManager) {
                                onDelete(task)
                            }
                        } label: {
                            TaskCardView(task: task)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(width: 280, alignment: .top)
        .background(.background.opacity(0.6), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("Dolu") {
    ManagerBoardView(currentUser: MockData.manager, onLogout: {})
        .environment(TaskStore())
}

#Preview("Boş") {
    ManagerBoardView(currentUser: MockData.manager, onLogout: {})
        .environment(TaskStore(tasks: []))
}
