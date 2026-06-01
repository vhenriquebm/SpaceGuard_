import SwiftUI
import Observation

// MARK: - Models

struct User: Identifiable, Equatable {
    let id = UUID()
    let email: String
}

struct Region: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let city: String
    let state: String

    var displayName: String {
        "\(name) - \(city), \(state)"
    }
}

enum RiskLevel: String, CaseIterable, Identifiable {
    case low
    case medium
    case high
    case critical

    var id: String { rawValue }

    var title: String {
        switch self {
        case .low: "Baixo"
        case .medium: "Medio"
        case .high: "Alto"
        case .critical: "Critico"
        }
    }

    var color: Color {
        switch self {
        case .low: .green
        case .medium: .yellow
        case .high: .orange
        case .critical: .red
        }
    }

    var systemImageName: String {
        switch self {
        case .low: "checkmark.shield.fill"
        case .medium: "exclamationmark.triangle.fill"
        case .high: "flame.fill"
        case .critical: "exclamationmark.octagon.fill"
        }
    }

    var sortPriority: Int {
        switch self {
        case .low: 1
        case .medium: 2
        case .high: 3
        case .critical: 4
        }
    }
}

enum AlertType: String, CaseIterable, Identifiable {
    case flood
    case wildfire
    case extremeHeat

    var id: String { rawValue }

    var title: String {
        switch self {
        case .flood: "Enchente"
        case .wildfire: "Queimada"
        case .extremeHeat: "Calor Extremo"
        }
    }

    var systemImageName: String {
        switch self {
        case .flood: "drop.triangle.fill"
        case .wildfire: "flame.fill"
        case .extremeHeat: "thermometer.sun.fill"
        }
    }

    var accentColor: Color {
        switch self {
        case .flood: .blue
        case .wildfire: .red
        case .extremeHeat: .orange
        }
    }
}

struct SensorReading: Equatable {
    let temperature: Double
    let humidity: Double
    let waterLevel: Double
    let smokeDetected: Bool
    let measuredAt: Date
}

struct EnvironmentalAlert: Identifiable, Equatable {
    let id = UUID()
    let type: AlertType
    let region: Region
    let riskLevel: RiskLevel
    let lastUpdated: Date
    let description: String
    let sensorReading: SensorReading
    let recommendation: String
}

// MARK: - Mock Data

enum MockAlertData {
    static let alerts: [EnvironmentalAlert] = [
        EnvironmentalAlert(
            type: .flood,
            region: Region(name: "Bacia do Rio Verde", city: "Recife", state: "PE"),
            riskLevel: .critical,
            lastUpdated: Date().addingTimeInterval(-600),
            description: "Sensores simulados indicam subida rapida do nivel da agua e alta umidade na regiao monitorada.",
            sensorReading: SensorReading(temperature: 27.8, humidity: 91, waterLevel: 4.7, smokeDetected: false, measuredAt: Date().addingTimeInterval(-600)),
            recommendation: "Acionar defesa civil, evitar deslocamentos em vias alagadas e orientar moradores de areas baixas a buscar pontos seguros."
        ),
        EnvironmentalAlert(
            type: .wildfire,
            region: Region(name: "Parque Serra Azul", city: "Goiania", state: "GO"),
            riskLevel: .high,
            lastUpdated: Date().addingTimeInterval(-1_800),
            description: "Baixa umidade, temperatura elevada e deteccao de fumaca sugerem foco ativo de queimada.",
            sensorReading: SensorReading(temperature: 38.4, humidity: 18, waterLevel: 0.3, smokeDetected: true, measuredAt: Date().addingTimeInterval(-1_800)),
            recommendation: "Isolar a area, notificar brigada ambiental e monitorar direcao do vento para prevenir expansao do foco."
        ),
        EnvironmentalAlert(
            type: .extremeHeat,
            region: Region(name: "Zona Urbana Central", city: "Sao Paulo", state: "SP"),
            riskLevel: .medium,
            lastUpdated: Date().addingTimeInterval(-3_600),
            description: "Ilhas de calor urbanas apresentam temperatura acima da media historica para o periodo.",
            sensorReading: SensorReading(temperature: 35.6, humidity: 32, waterLevel: 0.5, smokeDetected: false, measuredAt: Date().addingTimeInterval(-3_600)),
            recommendation: "Reforcar hidratacao, evitar exposicao solar nos horarios criticos e priorizar atendimento a grupos vulneraveis."
        ),
        EnvironmentalAlert(
            type: .flood,
            region: Region(name: "Canal Norte", city: "Manaus", state: "AM"),
            riskLevel: .low,
            lastUpdated: Date().addingTimeInterval(-7_200),
            description: "Nivel da agua permanece dentro da faixa segura, com tendencia estavel nas ultimas leituras.",
            sensorReading: SensorReading(temperature: 29.1, humidity: 74, waterLevel: 1.1, smokeDetected: false, measuredAt: Date().addingTimeInterval(-7_200)),
            recommendation: "Manter monitoramento preventivo e revisar sensores em campo conforme rotina operacional."
        )
    ]
}

// MARK: - Services

protocol AlertServiceProtocol {
    func fetchAlerts() async throws -> [EnvironmentalAlert]
}

struct MockAlertService: AlertServiceProtocol {
    func fetchAlerts() async throws -> [EnvironmentalAlert] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return MockAlertData.alerts
    }
}

// MARK: - ViewModels

@MainActor
@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    var errorMessage: String?
    var isLoading = false

    var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func login() async -> User? {
        errorMessage = nil

        guard canSubmit else {
            errorMessage = "Informe e-mail e senha para entrar."
            return nil
        }

        isLoading = true
        defer { isLoading = false }

        try? await Task.sleep(nanoseconds: 250_000_000)
        return User(email: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

@MainActor
@Observable
final class DashboardViewModel {
    private let alertService: AlertServiceProtocol

    var alerts: [EnvironmentalAlert] = []
    var isLoading = false
    var errorMessage: String?

    init(alertService: AlertServiceProtocol) {
        self.alertService = alertService
    }

    func loadAlerts() async {
        isLoading = true
        errorMessage = nil

        do {
            alerts = try await alertService.fetchAlerts()
                .sorted { $0.riskLevel.sortPriority > $1.riskLevel.sortPriority }
        } catch {
            errorMessage = "Nao foi possivel carregar os alertas."
        }

        isLoading = false
    }
}

// MARK: - Root

struct ContentView: View {
    @State private var loggedUser: User?

    var body: some View {
        Group {
            if let loggedUser {
                DashboardView(user: loggedUser)
            } else {
                LoginView { user in
                    loggedUser = user
                }
            }
        }
    }
}

// MARK: - Views

struct LoginView: View {
    @State private var viewModel = LoginViewModel()
    let onLogin: (User) -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 14) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundStyle(.blue)

                VStack(spacing: 6) {
                    Text("SpaceGuard")
                        .font(.largeTitle.weight(.bold))

                    Text("Monitoramento ambiental inteligente")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(spacing: 14) {
                TextField("E-mail", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))

                SecureField("Senha", text: $viewModel.password)
                    .textContentType(.password)
                    .submitLabel(.go)
                    .padding()
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .onSubmit { submit() }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: submit) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Entrar")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading)
            }

            Spacer()
        }
        .padding(24)
        .background(Color(.systemGroupedBackground))
    }

    private func submit() {
        Task {
            if let user = await viewModel.login() {
                onLogin(user)
            }
        }
    }
}

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
                    ContentUnavailableView("Falha ao carregar", systemImage: "wifi.exclamationmark", description: Text(errorMessage))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.alerts) { alert in
                                NavigationLink {
                                    AlertDetailView(alert: alert)
                                } label: {
                                    AlertCardView(alert: alert)
                                }
                                .buttonStyle(.plain)
                            }
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
}

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
                SensorMetricView(title: "Temperatura", value: String(format: "%.1f C", alert.sensorReading.temperature), systemImage: "thermometer.medium", tint: .orange)
                SensorMetricView(title: "Umidade", value: String(format: "%.0f%%", alert.sensorReading.humidity), systemImage: "humidity.fill", tint: .blue)
                SensorMetricView(title: "Nivel da agua", value: String(format: "%.1f m", alert.sensorReading.waterLevel), systemImage: "water.waves", tint: .cyan)
                SensorMetricView(title: "Fumaca", value: alert.sensorReading.smokeDetected ? "Detectada" : "Ausente", systemImage: alert.sensorReading.smokeDetected ? "smoke.fill" : "checkmark.circle.fill", tint: alert.sensorReading.smokeDetected ? .red : .green)
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
    ContentView()
}
