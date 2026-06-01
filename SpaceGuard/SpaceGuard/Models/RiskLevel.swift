import SwiftUI

enum RiskLevel: String, CaseIterable, Identifiable {
    case low
    case medium
    case high
    case critical

    var id: String { rawValue }

    var title: String {
        switch self {
        case .low:
            return "Baixo"
        case .medium:
            return "Medio"
        case .high:
            return "Alto"
        case .critical:
            return "Critico"
        }
    }

    var color: Color {
        switch self {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .orange
        case .critical:
            return .red
        }
    }

    var systemImageName: String {
        switch self {
        case .low:
            return "checkmark.shield.fill"
        case .medium:
            return "exclamationmark.triangle.fill"
        case .high:
            return "flame.fill"
        case .critical:
            return "exclamationmark.octagon.fill"
        }
    }
}
