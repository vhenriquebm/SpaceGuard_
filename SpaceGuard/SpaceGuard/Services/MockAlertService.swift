import Foundation

struct MockAlertService: AlertServiceProtocol {
    func fetchAlerts() async throws -> [EnvironmentalAlert] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return MockAlertData.alerts
    }
}

