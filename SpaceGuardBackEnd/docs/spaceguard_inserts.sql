-- =============================================================
--  SpaceGuard — Dados de Exemplo
--  Execute APÓS o spaceguard_schema.sql
-- =============================================================

-- =============================================================
-- USUÁRIOS (2)
-- Senhas são hashes BCrypt. Valor real: admin123 / operador123
-- =============================================================
INSERT INTO users (email, password_hash, created_at) VALUES
    ('admin@spaceguard.com',
     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
     '2026-01-10 08:00:00'),

    ('operador@spaceguard.com',
     '$2a$10$DummyHashExemploParaDocumentacaoAcademica1234567890AB',
     '2026-02-15 09:30:00');


-- =============================================================
-- REGIÕES (3)
-- =============================================================
INSERT INTO regions (name, country, risk_level) VALUES
    ('Amazônia',  'Brasil', 'HIGH'),
    ('Pantanal',  'Brasil', 'CRITICAL'),
    ('Cerrado',   'Brasil', 'MEDIUM');


-- =============================================================
-- SENSORES (5)
-- Distribuídos pelas 3 regiões
-- =============================================================
INSERT INTO sensors (name, type, status, region_id) VALUES
    ('Sensor-AM-001', 'MULTI',       'ACTIVE',      1),   -- Amazônia
    ('Sensor-AM-002', 'SMOKE',       'ACTIVE',      1),   -- Amazônia
    ('Sensor-PT-001', 'TEMPERATURE', 'ACTIVE',      2),   -- Pantanal
    ('Sensor-PT-002', 'WATER',       'MAINTENANCE', 2),   -- Pantanal
    ('Sensor-CE-001', 'HUMIDITY',    'ACTIVE',      3);   -- Cerrado


-- =============================================================
-- LEITURAS DE SENSORES (8)
-- Simulam coleta de dados ao longo do tempo
-- =============================================================
INSERT INTO sensor_readings (temperature, smoke_level, water_level, recorded_at, sensor_id) VALUES
    -- Amazônia — Sensor-AM-001 (MULTI): temperatura e fumaça elevadas
    (39.5, 0.65, 1.80, '2026-06-01 06:00:00', 1),
    (41.2, 0.78, 1.75, '2026-06-01 12:00:00', 1),
    (43.8, 0.91, 1.60, '2026-06-01 18:00:00', 1),

    -- Amazônia — Sensor-AM-002 (SMOKE): nível de fumaça crítico
    (NULL, 0.95, NULL, '2026-06-01 14:00:00', 2),
    (NULL, 0.87, NULL, '2026-06-01 20:00:00', 2),

    -- Pantanal — Sensor-PT-001 (TEMPERATURE): calor extremo
    (47.3, NULL, NULL, '2026-06-01 13:00:00', 3),
    (45.1, NULL, NULL, '2026-06-01 17:00:00', 3),

    -- Cerrado — Sensor-CE-001 (HUMIDITY): umidade baixa (risco de incêndio)
    (35.0, 0.30, NULL, '2026-06-01 10:00:00', 5);


-- =============================================================
-- ALERTAS AMBIENTAIS (5)
-- =============================================================
INSERT INTO environmental_alerts (title, description, risk_level, alert_type, created_at, region_id) VALUES
    (
        'Incêndio Detectado — Setor Norte',
        'Temperatura acima de 45°C e fumaça densa detectadas no setor norte. Risco imediato de propagação.',
        'CRITICAL', 'FIRE',
        '2026-06-01 18:30:00', 2
    ),
    (
        'Risco de Enchente — Bacia do Rio',
        'Nível da água subindo acima do limiar de 2m. Áreas de várzea em alerta.',
        'HIGH', 'FLOOD',
        '2026-06-01 09:00:00', 1
    ),
    (
        'Fumaça Densa — Área de Preservação',
        'Sensor AM-002 registrou índice de fumaça > 0.9 por mais de 3 horas consecutivas.',
        'HIGH', 'SMOKE',
        '2026-06-01 15:00:00', 1
    ),
    (
        'Temperatura Extrema — Zona de Seca',
        'Temperatura média de 46°C registrada. Risco elevado de ignição espontânea.',
        'CRITICAL', 'CRITICAL_EVENT',
        '2026-06-01 14:00:00', 2
    ),
    (
        'Umidade Crítica — Alerta Preventivo',
        'Umidade relativa abaixo de 15%. Condições favoráveis para inicio de incêndio.',
        'MEDIUM', 'FIRE',
        '2026-06-01 11:00:00', 3
    );
