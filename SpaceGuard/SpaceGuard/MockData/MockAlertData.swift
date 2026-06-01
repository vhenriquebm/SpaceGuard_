import Foundation

enum MockAlertData {
    static let alerts: [EnvironmentalAlert] = [
        EnvironmentalAlert(
            type: .flood,
            region: Region(name: "Bacia do Rio Verde", city: "Recife", state: "PE"),
            riskLevel: .critical,
            lastUpdated: Date().addingTimeInterval(-600),
            description: "Sensores simulados indicam subida rapida do nivel da agua e alta umidade na regiao monitorada.",
            sensorReading: SensorReading(
                temperature: 27.8,
                humidity: 91,
                waterLevel: 4.7,
                smokeDetected: false,
                measuredAt: Date().addingTimeInterval(-600)
            ),
            recommendation: "Acionar defesa civil, evitar deslocamentos em vias alagadas e orientar moradores de areas baixas a buscar pontos seguros."
        ),
        EnvironmentalAlert(
            type: .wildfire,
            region: Region(name: "Parque Serra Azul", city: "Goiania", state: "GO"),
            riskLevel: .high,
            lastUpdated: Date().addingTimeInterval(-1_800),
            description: "Baixa umidade, temperatura elevada e deteccao de fumaca sugerem foco ativo de queimada.",
            sensorReading: SensorReading(
                temperature: 38.4,
                humidity: 18,
                waterLevel: 0.3,
                smokeDetected: true,
                measuredAt: Date().addingTimeInterval(-1_800)
            ),
            recommendation: "Isolar a area, notificar brigada ambiental e monitorar direcao do vento para prevenir expansao do foco."
        ),
        EnvironmentalAlert(
            type: .extremeHeat,
            region: Region(name: "Zona Urbana Central", city: "Sao Paulo", state: "SP"),
            riskLevel: .medium,
            lastUpdated: Date().addingTimeInterval(-3_600),
            description: "Ilhas de calor urbanas apresentam temperatura acima da media historica para o periodo.",
            sensorReading: SensorReading(
                temperature: 35.6,
                humidity: 32,
                waterLevel: 0.5,
                smokeDetected: false,
                measuredAt: Date().addingTimeInterval(-3_600)
            ),
            recommendation: "Reforcar hidratacao, evitar exposicao solar nos horarios criticos e priorizar atendimento a grupos vulneraveis."
        ),
        EnvironmentalAlert(
            type: .flood,
            region: Region(name: "Canal Norte", city: "Manaus", state: "AM"),
            riskLevel: .low,
            lastUpdated: Date().addingTimeInterval(-7_200),
            description: "Nivel da agua permanece dentro da faixa segura, com tendencia estavel nas ultimas leituras.",
            sensorReading: SensorReading(
                temperature: 29.1,
                humidity: 74,
                waterLevel: 1.1,
                smokeDetected: false,
                measuredAt: Date().addingTimeInterval(-7_200)
            ),
            recommendation: "Manter monitoramento preventivo e revisar sensores em campo conforme rotina operacional."
        )
    ]
}
