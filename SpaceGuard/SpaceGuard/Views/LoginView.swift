import SwiftUI

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    let onLogin: (User) -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 14) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundStyle(.blue)

                VStack(spacing: 6) {
                    Text("SpaceGuard")
                        .font(.largeTitle.weight(.bold))

                    Text("Monitoramento ambiental inteligente")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(spacing: 14) {
                TextField("E-mail", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))

                SecureField("Senha", text: $viewModel.password)
                    .textContentType(.password)
                    .submitLabel(.go)
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .onSubmit { submit() }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: submit) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Entrar")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading)
            }

            Spacer()
        }
        .padding(24)
        .background(Color(.systemGroupedBackground))
    }

    private func submit() {
        Task {
            if let user = await viewModel.login() {
                onLogin(user)
            }
        }
    }
}

#Preview {
    LoginView { _ in }
}
