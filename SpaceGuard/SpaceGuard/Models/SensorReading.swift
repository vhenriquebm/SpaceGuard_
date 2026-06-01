import Foundation

struct SensorReading: Equatable {
    let temperature: Double
    let humidity: Double
    let waterLevel: Double
    let smokeDetected: Bool
    let measuredAt: Date
}
