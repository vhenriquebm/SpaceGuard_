import Foundation
import SwiftUI

struct SimulatedSensorReading: Identifiable, Equatable {
    let id: UUID
    let sensorType: SensorType
    let region: Region
    let value: Double
    let unit: String
    let riskLevel: RiskLevel
    let measuredAt: Date
    let sourceReading: SensorReading

    init(
        id: UUID = UUID(),
        sensorType: SensorType,
        region: Region,
        value: Double,
        unit: String,
        riskLevel: RiskLevel,
        measuredAt: Date,
        sourceReading: SensorReading
    ) {
        self.id = id
        self.sensorType = sensorType
        self.region = region
        self.value = value
        self.unit = unit
        self.riskLevel = riskLevel
        self.measuredAt = measuredAt
        self.sourceReading = sourceReading
    }

    var formattedValue: String {
        switch sensorType {
        case .smoke:
            return value > 0 ? "Detectada" : "Ausente"
        case .humidity:
            return "\(value.formatted(.number.precision(.fractionLength(0))))"
        default:
            return "\(value.formatted(.number.precision(.fractionLength(1))))"
        }
    }
}

enum SensorType: String, CaseIterable, Identifiable {
    case temperature
    case humidity
    case waterLevel
    case smoke

    var id: String { rawValue }

    var title: String {
        switch self {
        case .temperature:
            return "Temperatura"
        case .humidity:
            return "Umidade"
        case .waterLevel:
            return "Nivel da agua"
        case .smoke:
            return "Fumaca"
        }
    }

    var systemImageName: String {
        switch self {
        case .temperature:
            return "thermometer.sun.fill"
        case .humidity:
            return "humidity.fill"
        case .waterLevel:
            return "water.waves"
        case .smoke:
            return "smoke.fill"
        }
    }

    var tint: Color {
        switch self {
        case .temperature:
            return .orange
        case .humidity:
            return .blue
        case .waterLevel:
            return .cyan
        case .smoke:
            return .red
        }
    }
}
