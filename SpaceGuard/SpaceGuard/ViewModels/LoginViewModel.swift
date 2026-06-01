import Foundation
import Observation

@MainActor
@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    var errorMessage: String?
    var isLoading = false

    var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func login() async -> User? {
        errorMessage = nil

        guard canSubmit else {
            errorMessage = "Informe e-mail e senha para entrar."
            return nil
        }

        isLoading = true
        defer { isLoading = false }

        try? await Task.sleep(nanoseconds: 250_000_000)
        return User(email: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
