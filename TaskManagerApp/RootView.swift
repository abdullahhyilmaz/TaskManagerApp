import SwiftUI

struct RootView: View {
    @State private var currentUser: AppUser?
    @State private var store = TaskStore()

    var body: some View {
        Group {
            if let currentUser {
                switch currentUser.role {
                case .manager:
                    ManagerBoardView(
                        currentUser: currentUser,
                        onLogout: { self.currentUser = nil }
                    )
                case .employee:
                    EmployeeTaskListView(
                        currentUser: currentUser,
                        onLogout: { self.currentUser = nil }
                    )
                }
            } else {
                LoginView(
                    onDemoManagerLogin: { currentUser = MockData.manager },
                    onDemoEmployeeLogin: { currentUser = MockData.currentEmployee }
                )
            }
        }
        .environment(store)
        .animation(.default, value: currentUser)
    }
}

#Preview {
    RootView()
}
