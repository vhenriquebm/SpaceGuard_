import SwiftUI

struct AlertDetailView: View {
    let alert: EnvironmentalAlert

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                section(title: "Regiao") {
                    Text(alert.region.displayName)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                section(title: "Descricao") {
                    Text(alert.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                sensorSection
                section(title: "Recomendacao") {
                    Text(alert.recommendation)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.primary)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(alert.type.accentColor.opacity(0.15))

                    Image(systemName: alert.type.systemImageName)
                        .font(.title.weight(.semibold))
                        .foregroundStyle(alert.type.accentColor)
                }
                .frame(width: 64, height: 64)

                VStack(alignment: .leading, spacing: 8) {
                    Text(alert.type.title)
                        .font(.title2.weight(.bold))

                    RiskBadgeView(riskLevel: alert.riskLevel)
                }

                Spacer()
            }

            Label("Ultima atualizacao \(alert.lastUpdated.formatted(date: .abbreviated, time: .shortened))", systemImage: "clock")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }

    private var sensorSection: some View {
        section(title: "Sensores simulados") {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                SensorMetricView(
                    title: "Temperatura",
                    value: "\(alert.sensorReading.temperature, specifier: "%.1f") C",
                    systemImage: "thermometer.medium",
                    tint: .orange
                )

                SensorMetricView(
                    title: "Umidade",
                    value: "\(alert.sensorReading.humidity, specifier: "%.0f")%",
                    systemImage: "humidity.fill",
                    tint: .blue
                )

                SensorMetricView(
                    title: "Nivel da agua",
                    value: "\(alert.sensorReading.waterLevel, specifier: "%.1f") m",
                    systemImage: "water.waves",
                    tint: .cyan
                )

                SensorMetricView(
                    title: "Fumaca",
                    value: alert.sensorReading.smokeDetected ? "Detectada" : "Ausente",
                    systemImage: alert.sensorReading.smokeDetected ? "smoke.fill" : "checkmark.circle.fill",
                    tint: alert.sensorReading.smokeDetected ? .red : .green
                )
            }

            Text("Medicao em \(alert.sensorReading.measuredAt.formatted(date: .abbreviated, time: .shortened))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct SensorMetricView: View {
    let title: String
    let value: String
    let systemImage: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.headline)
                    .minimumScaleFactor(0.8)

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 104, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        AlertDetailView(alert: MockAlertData.alerts[0])
    }
}
