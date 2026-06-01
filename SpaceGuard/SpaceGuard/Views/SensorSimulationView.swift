import SwiftUI

struct SensorSimulationView: View {
    @State private var viewModel: SensorSimulationViewModel

    init(viewModel: SensorSimulationViewModel = SensorSimulationViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                simulationHeader

                if !viewModel.highRiskReadings.isEmpty {
                    highRiskAlert
                }

                ForEach(viewModel.readings) { reading in
                    SensorReadingCardView(reading: reading)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Sensores IoT")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.simulateNewReading()
                    }
                } label: {
                    Label("Simular nova leitura", systemImage: "arrow.clockwise")
                }
                .disabled(viewModel.isSimulating)
            }
        }
    }

    private var simulationHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "sensor.tag.radiowaves.forward.fill")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.blue)
                    .frame(width: 44, height: 44)
                    .background(.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Simulacao de sensores ambientais")
                        .font(.headline)

                    Text("\(viewModel.activeSensorCount) sensores mockados ativos")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            Button {
                Task {
                    await viewModel.simulateNewReading()
                }
            } label: {
                if viewModel.isSimulating {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Label("Simular nova leitura", systemImage: "waveform.path.ecg")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isSimulating)

            if let lastSimulationDate = viewModel.lastSimulationDate {
                Label("Ultima simulacao \(lastSimulationDate.formatted(date: .abbreviated, time: .shortened))", systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }

    private var highRiskAlert: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
                .font(.title3.weight(.semibold))

            VStack(alignment: .leading, spacing: 4) {
                Text("Leitura critica detectada")
                    .font(.headline)

                Text("Ha \(viewModel.highRiskReadings.count) sensor(es) com risco alto ou critico nesta simulacao.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background(.red.opacity(0.10), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.red.opacity(0.35), lineWidth: 1)
        }
    }
}

private struct SensorReadingCardView: View {
    let reading: SimulatedSensorReading

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: reading.sensorType.systemImageName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(reading.sensorType.tint)
                    .frame(width: 44, height: 44)
                    .background(reading.sensorType.tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(reading.sensorType.title)
                            .font(.headline)

                        Spacer(minLength: 8)

                        RiskBadgeView(riskLevel: reading.riskLevel)
                    }

                    Text(reading.region.displayName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(reading.formattedValue)
                    .font(.title2.weight(.bold))
                    .minimumScaleFactor(0.75)

                Text(reading.unit)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                Spacer()
            }

            Label("Medido em \(reading.measuredAt.formatted(date: .abbreviated, time: .shortened))", systemImage: "calendar.badge.clock")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: reading.riskLevel == .high || reading.riskLevel == .critical ? 1.5 : 1)
        }
    }

    private var borderColor: Color {
        if reading.riskLevel == .high || reading.riskLevel == .critical {
            return reading.riskLevel.color.opacity(0.65)
        }
        return Color(.separator).opacity(0.25)
    }
}

#Preview {
    NavigationStack {
        SensorSimulationView()
    }
}
