import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedRole: UserRole = .employee

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ad Soyad")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    TextField("Adınız Soyadınız", text: $name)
                        .textInputAutocapitalization(.words)
                        .padding(12)
                        .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: 12))
                }

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

                VStack(alignment: .leading, spacing: 8) {
                    Text("Rol")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Picker("Rol", selection: $selectedRole) {
                        ForEach(UserRole.allCases) { role in
                            Text(role.rawValue).tag(role)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Button {
                    // Gerçek kayıt işlemi yarın eklenecek
                } label: {
                    Text("Kayıt Ol")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 8)
            }
            .padding(24)
        }
        .navigationTitle("Kayıt Ol")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
