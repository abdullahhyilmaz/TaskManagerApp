import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUp = false

    var onDemoManagerLogin: () -> Void
    var onDemoEmployeeLogin: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header

                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("E-posta")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            TextField("ornek@sirket.com", text: $email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .padding(12)
                                .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: 12))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Şifre")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            SecureField("••••••••", text: $password)
                                .padding(12)
                                .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    Button {
                        // Gerçek auth yarın eklenecek
                    } label: {
                        Text("Giriş Yap")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button {
                        showSignUp = true
                    } label: {
                        Text("Hesabın yok mu? **Kayıt ol**")
                            .font(.subheadline)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.blue)

                    demoSection
                }
                .padding(24)
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "checklist")
                .font(.system(size: 44))
                .foregroundStyle(.blue)
                .padding(.bottom, 4)
            Text("TaskManagerApp")
                .font(.title2.bold())
            Text("Ekibinizin görevlerini tek yerden yönetin")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 32)
    }

    private var demoSection: some View {
        VStack(spacing: 12) {
            HStack {
                VStack { Divider() }
                Text("Demo Girişi")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                VStack { Divider() }
            }
            .padding(.top, 8)

            Button(action: onDemoManagerLogin) {
                Label("Demo: Yönetici olarak gir", systemImage: "person.badge.key.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.bordered)

            Button(action: onDemoEmployeeLogin) {
                Label("Demo: Çalışan olarak gir", systemImage: "person.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    LoginView(onDemoManagerLogin: {}, onDemoEmployeeLogin: {})
}
