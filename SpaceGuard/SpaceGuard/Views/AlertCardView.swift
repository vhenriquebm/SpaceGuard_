import SwiftUI

struct AlertCardView: View {
    let alert: EnvironmentalAlert

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(alert.type.accentColor.opacity(0.15))

                Image(systemName: alert.type.systemImageName)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(alert.type.accentColor)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Text(alert.type.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Spacer(minLength: 8)

                    RiskBadgeView(riskLevel: alert.riskLevel)
                }

                Text(alert.region.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Label("Atualizado \(alert.lastUpdated.formatted(date: .omitted, time: .shortened))", systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.separator).opacity(0.25), lineWidth: 1)
        }
    }
}

struct RiskBadgeView: View {
    let riskLevel: RiskLevel

    var body: some View {
        Label(riskLevel.title, systemImage: riskLevel.systemImageName)
            .font(.caption.weight(.semibold))
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(riskLevel.color)
            .background(riskLevel.color.opacity(0.12), in: Capsule())
    }
}

#Preview {
    AlertCardView(alert: MockAlertData.alerts[0])
        .padding()
        .background(Color(.systemGroupedBackground))
}
