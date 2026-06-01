import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    let email: String

    init(id: UUID = UUID(), email: String) {
        self.id = id
        self.email = email
    }
}
