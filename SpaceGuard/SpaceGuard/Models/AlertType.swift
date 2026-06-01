import SwiftUI

enum AlertType: String, CaseIterable, Identifiable {
    case flood
    case wildfire
    case extremeHeat

    var id: String { rawValue }

    var title: String {
        switch self {
        case .flood:
            return "Enchente"
        case .wildfire:
            return "Queimada"
        case .extremeHeat:
            return "Calor Extremo"
        }
    }

    var systemImageName: String {
        switch self {
        case .flood:
            return "drop.triangle.fill"
        case .wildfire:
            return "flame.fill"
        case .extremeHeat:
            return "thermometer.sun.fill"
        }
    }

    var accentColor: Color {
        switch self {
        case .flood:
            return .blue
        case .wildfire:
            return .red
        case .extremeHeat:
            return .orange
        }
    }
}
