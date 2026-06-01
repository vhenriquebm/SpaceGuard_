import Foundation

struct Region: Identifiable, Equatable {
    let id: UUID
    let name: String
    let city: String
    let state: String

    init(id: UUID = UUID(), name: String, city: String, state: String) {
        self.id = id
        self.name = name
        self.city = city
        self.state = state
    }

    var displayName: String {
        "\(name) - \(city), \(state)"
    }
}
