-- =============================================================
--  SpaceGuard — Script de Banco de Dados
--  Sistema de Monitoramento Ambiental
--  PostgreSQL 15+
-- =============================================================

-- Apaga as tabelas na ordem correta (respeita FKs)
DROP TABLE IF EXISTS sensor_readings       CASCADE;
DROP TABLE IF EXISTS environmental_alerts  CASCADE;
DROP TABLE IF EXISTS sensors               CASCADE;
DROP TABLE IF EXISTS regions               CASCADE;
DROP TABLE IF EXISTS users                 CASCADE;

-- =============================================================
-- TABELA: users
-- Armazena os usuários do sistema (administradores e operadores)
-- =============================================================
CREATE TABLE users (
    id            BIGSERIAL    PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at    TIMESTAMP    DEFAULT NOW()
);

-- =============================================================
-- TABELA: regions
-- Regiões geográficas monitoradas (ex.: Amazônia, Pantanal)
-- =============================================================
CREATE TABLE regions (
    id         BIGSERIAL    PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    country    VARCHAR(255) NOT NULL,
    risk_level VARCHAR(50)  NOT NULL,

    CONSTRAINT regions_risk_level_check
        CHECK (risk_level IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL'))
);

-- =============================================================
-- TABELA: sensors
-- Sensores IoT instalados nas regiões
-- Cada sensor pertence a exatamente uma região
-- =============================================================
CREATE TABLE sensors (
    id        BIGSERIAL    PRIMARY KEY,
    name      VARCHAR(255) NOT NULL,
    type      VARCHAR(50)  NOT NULL,
    status    VARCHAR(50)  NOT NULL,
    region_id BIGINT       NOT NULL,

    CONSTRAINT sensors_type_check
        CHECK (type IN ('TEMPERATURE', 'SMOKE', 'WATER', 'HUMIDITY', 'MULTI')),

    CONSTRAINT sensors_status_check
        CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE')),

    CONSTRAINT fk_sensors_region
        FOREIGN KEY (region_id) REFERENCES regions(id)
);

-- =============================================================
-- TABELA: sensor_readings
-- Leituras periódicas registradas pelos sensores
-- Cada leitura pertence a exatamente um sensor
-- =============================================================
CREATE TABLE sensor_readings (
    id          BIGSERIAL         PRIMARY KEY,
    temperature DOUBLE PRECISION,
    smoke_level DOUBLE PRECISION,
    water_level DOUBLE PRECISION,
    recorded_at TIMESTAMP         DEFAULT NOW(),
    sensor_id   BIGINT            NOT NULL,

    CONSTRAINT fk_readings_sensor
        FOREIGN KEY (sensor_id) REFERENCES sensors(id)
);

-- =============================================================
-- TABELA: environmental_alerts
-- Alertas ambientais gerados para uma região
-- =============================================================
CREATE TABLE environmental_alerts (
    id          BIGSERIAL    PRIMARY KEY,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    risk_level  VARCHAR(50)  NOT NULL,
    alert_type  VARCHAR(50)  NOT NULL,
    created_at  TIMESTAMP    DEFAULT NOW(),
    region_id   BIGINT       NOT NULL,

    CONSTRAINT alerts_risk_level_check
        CHECK (risk_level IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),

    CONSTRAINT alerts_alert_type_check
        CHECK (alert_type IN ('FIRE', 'FLOOD', 'SMOKE', 'CRITICAL_EVENT')),

    CONSTRAINT fk_alerts_region
        FOREIGN KEY (region_id) REFERENCES regions(id)
);

-- =============================================================
-- Índices para melhorar performance nas consultas mais comuns
-- =============================================================
CREATE INDEX idx_sensors_region      ON sensors(region_id);
CREATE INDEX idx_readings_sensor     ON sensor_readings(sensor_id);
CREATE INDEX idx_readings_recorded   ON sensor_readings(recorded_at DESC);
CREATE INDEX idx_alerts_region       ON environmental_alerts(region_id);
CREATE INDEX idx_alerts_risk         ON environmental_alerts(risk_level);
