import Foundation
import Observation

@MainActor
@Observable
final class DashboardViewModel {
    private let alertService: AlertServiceProtocol

    var alerts: [EnvironmentalAlert] = []
    var isLoading = false
    var errorMessage: String?

    init(alertService: AlertServiceProtocol) {
        self.alertService = alertService
    }

    var totalAlerts: Int {
        alerts.count
    }

    var criticalAlerts: Int {
        alerts.filter { $0.riskLevel == .critical }.count
    }

    var monitoredRegions: Int {
        alerts.reduce(into: [Region]()) { regions, alert in
            if !regions.contains(alert.region) {
                regions.append(alert.region)
            }
        }.count
    }

    var activeSensors: Int {
        monitoredRegions * SensorType.allCases.count
    }

    func loadAlerts() async {
        isLoading = true
        errorMessage = nil

        do {
            alerts = try await alertService.fetchAlerts()
                .sorted { $0.riskLevel.sortPriority > $1.riskLevel.sortPriority }
        } catch {
            errorMessage = "Nao foi possivel carregar os alertas."
        }

        isLoading = false
    }
}

private extension RiskLevel {
    var sortPriority: Int {
        switch self {
        case .low:
            return 1
        case .medium:
            return 2
        case .high:
            return 3
        case .critical:
            return 4
        }
    }
}
