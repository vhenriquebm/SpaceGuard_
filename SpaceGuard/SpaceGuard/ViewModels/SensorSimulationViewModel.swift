import Foundation
import Observation

@MainActor
@Observable
final class SensorSimulationViewModel {
    private let regions: [Region]

    var readings: [SimulatedSensorReading] = []
    var isSimulating = false
    var lastSimulationDate: Date?

    init(regions: [Region] = MockAlertData.alerts.map(\.region)) {
        self.regions = regions
        readings = Self.makeReadings(for: regions)
        lastSimulationDate = readings.map(\.measuredAt).max()
    }

    var activeSensorCount: Int {
        readings.count
    }

    var highRiskReadings: [SimulatedSensorReading] {
        readings.filter { $0.riskLevel == .high || $0.riskLevel == .critical }
    }

    func simulateNewReading() async {
        isSimulating = true
        try? await Task.sleep(nanoseconds: 250_000_000)

        readings = Self.makeReadings(for: regions).sorted { first, second in
            first.riskLevel.sortPriority > second.riskLevel.sortPriority
        }
        lastSimulationDate = Date()
        isSimulating = false
    }
}

private extension SensorSimulationViewModel {
    static func makeReadings(for regions: [Region]) -> [SimulatedSensorReading] {
        regions.flatMap { region in
            let sourceReading = makeSensorReading()
            return [
                SimulatedSensorReading(
                    sensorType: .temperature,
                    region: region,
                    value: sourceReading.temperature,
                    unit: "C",
                    riskLevel: riskLevelForTemperature(sourceReading.temperature),
                    measuredAt: sourceReading.measuredAt,
                    sourceReading: sourceReading
                ),
                SimulatedSensorReading(
                    sensorType: .humidity,
                    region: region,
                    value: sourceReading.humidity,
                    unit: "%",
                    riskLevel: riskLevelForHumidity(sourceReading.humidity),
                    measuredAt: sourceReading.measuredAt,
                    sourceReading: sourceReading
                ),
                SimulatedSensorReading(
                    sensorType: .waterLevel,
                    region: region,
                    value: sourceReading.waterLevel,
                    unit: "m",
                    riskLevel: riskLevelForWaterLevel(sourceReading.waterLevel),
                    measuredAt: sourceReading.measuredAt,
                    sourceReading: sourceReading
                ),
                SimulatedSensorReading(
                    sensorType: .smoke,
                    region: region,
                    value: sourceReading.smokeDetected ? 1 : 0,
                    unit: "",
                    riskLevel: sourceReading.smokeDetected ? .high : .low,
                    measuredAt: sourceReading.measuredAt,
                    sourceReading: sourceReading
                )
            ]
        }
    }

    static func makeSensorReading() -> SensorReading {
        SensorReading(
            temperature: Double.random(in: 22...43),
            humidity: Double.random(in: 12...94),
            waterLevel: Double.random(in: 0.2...5.4),
            smokeDetected: Bool.random() && Bool.random(),
            measuredAt: Date()
        )
    }

    static func riskLevelForTemperature(_ value: Double) -> RiskLevel {
        switch value {
        case 40...:
            return .critical
        case 36..<40:
            return .high
        case 32..<36:
            return .medium
        default:
            return .low
        }
    }

    static func riskLevelForHumidity(_ value: Double) -> RiskLevel {
        switch value {
        case ..<20:
            return .high
        case 20..<35, 85...:
            return .medium
        default:
            return .low
        }
    }

    static func riskLevelForWaterLevel(_ value: Double) -> RiskLevel {
        switch value {
        case 4.5...:
            return .critical
        case 3.2..<4.5:
            return .high
        case 2.0..<3.2:
            return .medium
        default:
            return .low
        }
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
