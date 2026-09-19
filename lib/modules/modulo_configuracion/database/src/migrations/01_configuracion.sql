-- ============================================
-- Migración 01: Tabla de Configuración
-- PostgreSQL
-- ============================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Tabla de configuración
CREATE TABLE IF NOT EXISTS configuracion (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clave           VARCHAR(255) NOT NULL UNIQUE,
    valor           TEXT NOT NULL,
    descripcion     TEXT,
    categoria       VARCHAR(100) NOT NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_configuracion_clave ON configuracion (clave);
CREATE INDEX idx_configuracion_categoria ON configuracion (categoria);
CREATE INDEX idx_configuracion_created_at ON configuracion (created_at);

-- Índice compuesto para búsquedas por categoría y clave
CREATE INDEX idx_configuracion_categoria_clave ON configuracion (categoria, clave);

-- Trigger para actualizar updated_at
CREATE OR REPLACE FUNCTION update_configuracion_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_configuracion_updated_at
    BEFORE UPDATE ON configuracion
    FOR EACH ROW
    EXECUTE FUNCTION update_configuracion_updated_at();
