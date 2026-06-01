import SwiftUI

struct DashboardView: View {
    @State private var viewModel: DashboardViewModel
    let user: User

    init(user: User, alertService: AlertServiceProtocol = MockAlertService()) {
        self.user = user
        _viewModel = State(initialValue: DashboardViewModel(alertService: alertService))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.alerts.isEmpty {
                    ProgressView("Carregando alertas")
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Falha ao carregar",
                        systemImage: "wifi.exclamationmark",
                        description: Text(errorMessage)
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            summarySection
                            sensorSimulationLink
                            alertListSection
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.loadAlerts()
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Alertas")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        SensorSimulationView()
                    } label: {
                        Image(systemName: "sensor.tag.radiowaves.forward.fill")
                    }
                    .accessibilityLabel("Sensores IoT")
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Text(user.email)
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                    .accessibilityLabel("Usuario")
                }
            }
            .task {
                if viewModel.alerts.isEmpty {
                    await viewModel.loadAlerts()
                }
            }
        }
    }

    private var summarySection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            DashboardSummaryCard(
                title: "Total de alertas",
                value: "\(viewModel.totalAlerts)",
                systemImage: "bell.badge.fill",
                tint: .blue
            )

            DashboardSummaryCard(
                title: "Criticos",
                value: "\(viewModel.criticalAlerts)",
                systemImage: "exclamationmark.octagon.fill",
                tint: .red
            )

            DashboardSummaryCard(
                title: "Regioes",
                value: "\(viewModel.monitoredRegions)",
                systemImage: "map.fill",
                tint: .green
            )

            DashboardSummaryCard(
                title: "Sensores ativos",
                value: "\(viewModel.activeSensors)",
                systemImage: "sensor.tag.radiowaves.forward.fill",
                tint: .orange
            )
        }
    }

    private var sensorSimulationLink: some View {
        NavigationLink {
            SensorSimulationView()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "waveform.path.ecg")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.blue)
                    .frame(width: 52, height: 52)
                    .background(.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 6) {
                    Text("Simulacao IoT")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("Gerar novas leituras mockadas dos sensores ambientais")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .background(.background, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.separator).opacity(0.25), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var alertListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Alertas recentes")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(viewModel.alerts) { alert in
                NavigationLink {
                    AlertDetailView(alert: alert)
                } label: {
                    AlertCardView(alert: alert)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct DashboardSummaryCard: View {
    let title: String
    let value: String
    let systemImage: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: systemImage)
                .font(.headline.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 36, height: 36)
                .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.8)

                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 116, alignment: .leading)
        .padding(14)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.separator).opacity(0.25), lineWidth: 1)
        }
    }
}

#Preview {
    DashboardView(user: User(email: "demo@spaceguard.edu"))
}
