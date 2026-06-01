import Foundation

struct EnvironmentalAlert: Identifiable, Equatable {
    let id: UUID
    let type: AlertType
    let region: Region
    let riskLevel: RiskLevel
    let lastUpdated: Date
    let description: String
    let sensorReading: SensorReading
    let recommendation: String

    init(
        id: UUID = UUID(),
        type: AlertType,
        region: Region,
        riskLevel: RiskLevel,
        lastUpdated: Date,
        description: String,
        sensorReading: SensorReading,
        recommendation: String
    ) {
        self.id = id
        self.type = type
        self.region = region
        self.riskLevel = riskLevel
        self.lastUpdated = lastUpdated
        self.description = description
        self.sensorReading = sensorReading
        self.recommendation = recommendation
    }
}
