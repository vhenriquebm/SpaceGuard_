-- =============================================================
--  SpaceGuard — Consultas SQL de Exemplo
-- =============================================================


-- -------------------------------------------------------------
-- CONSULTA 1: Listar todos os alertas por região
-- Mostra o nome da região junto com cada alerta, ordenado
-- pelo mais recente e pelo nível de risco mais alto.
-- -------------------------------------------------------------
SELECT
    r.name                          AS regiao,
    ea.title                        AS alerta,
    ea.alert_type                   AS tipo,
    ea.risk_level                   AS nivel_risco,
    TO_CHAR(ea.created_at, 'DD/MM/YYYY HH24:MI') AS data_criacao
FROM environmental_alerts ea
JOIN regions r ON ea.region_id = r.id
ORDER BY
    CASE ea.risk_level
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH'     THEN 2
        WHEN 'MEDIUM'   THEN 3
        WHEN 'LOW'      THEN 4
    END,
    ea.created_at DESC;


-- -------------------------------------------------------------
-- CONSULTA 2: Sensores ativos por região
-- Lista apenas sensores em operação (status = ACTIVE),
-- agrupados por região para facilitar o monitoramento.
-- -------------------------------------------------------------
SELECT
    r.name        AS regiao,
    r.risk_level  AS risco_regiao,
    s.name        AS sensor,
    s.type        AS tipo_sensor,
    s.status      AS status
FROM sensors s
JOIN regions r ON s.region_id = r.id
WHERE s.status = 'ACTIVE'
ORDER BY r.name, s.name;


-- -------------------------------------------------------------
-- CONSULTA 3: Leituras críticas (temperatura > 40°C ou fumaça > 0.8)
-- Identifica leituras que indicam situação de risco imediato.
-- -------------------------------------------------------------
SELECT
    s.name                          AS sensor,
    r.name                          AS regiao,
    sr.temperature                  AS temperatura_C,
    sr.smoke_level                  AS nivel_fumaca,
    sr.water_level                  AS nivel_agua_m,
    TO_CHAR(sr.recorded_at, 'DD/MM/YYYY HH24:MI') AS registrado_em
FROM sensor_readings sr
JOIN sensors s  ON sr.sensor_id  = s.id
JOIN regions r  ON s.region_id   = r.id
WHERE sr.temperature > 40
   OR sr.smoke_level > 0.8
ORDER BY sr.recorded_at DESC;


-- -------------------------------------------------------------
-- CONSULTA 4: Contagem de alertas por nível de risco
-- Útil para gerar gráficos e relatórios no app iOS.
-- -------------------------------------------------------------
SELECT
    risk_level          AS nivel_risco,
    COUNT(*)            AS total_alertas
FROM environmental_alerts
GROUP BY risk_level
ORDER BY
    CASE risk_level
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH'     THEN 2
        WHEN 'MEDIUM'   THEN 3
        WHEN 'LOW'      THEN 4
    END;


-- -------------------------------------------------------------
-- CONSULTA 5: Regiões ordenadas por maior risco
-- Exibe também quantos sensores e alertas cada região possui.
-- -------------------------------------------------------------
SELECT
    r.name                      AS regiao,
    r.country                   AS pais,
    r.risk_level                AS nivel_risco,
    COUNT(DISTINCT s.id)        AS total_sensores,
    COUNT(DISTINCT ea.id)       AS total_alertas
FROM regions r
LEFT JOIN sensors              s  ON s.region_id  = r.id
LEFT JOIN environmental_alerts ea ON ea.region_id = r.id
GROUP BY r.id, r.name, r.country, r.risk_level
ORDER BY
    CASE r.risk_level
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH'     THEN 2
        WHEN 'MEDIUM'   THEN 3
        WHEN 'LOW'      THEN 4
    END;
