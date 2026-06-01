import Foundation

protocol AlertServiceProtocol {
    func fetchAlerts() async throws -> [EnvironmentalAlert]
}
