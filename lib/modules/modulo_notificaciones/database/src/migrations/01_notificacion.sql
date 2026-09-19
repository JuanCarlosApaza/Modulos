-- ============================================
-- Migración 01: Tabla de Notificaciones
-- PostgreSQL
-- ============================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Tabla de notificaciones
CREATE TABLE IF NOT EXISTS notificaciones (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titulo          VARCHAR(255) NOT NULL,
    mensaje         TEXT NOT NULL,
    tipo            VARCHAR(50) NOT NULL,
    usuario_id      UUID NOT NULL,
    leida           BOOLEAN NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_notificaciones_usuario_id ON notificaciones (usuario_id);
CREATE INDEX idx_notificaciones_tipo ON notificaciones (tipo);
CREATE INDEX idx_notificaciones_leida ON notificaciones (leida);
CREATE INDEX idx_notificaciones_created_at ON notificaciones (created_at);
CREATE INDEX idx_notificaciones_no_leidas ON notificaciones (usuario_id, leida) WHERE leida = FALSE;

-- Trigger para actualizar updated_at
CREATE OR REPLACE FUNCTION update_notificaciones_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_notificaciones_updated_at
    BEFORE UPDATE ON notificaciones
    FOR EACH ROW
    EXECUTE FUNCTION update_notificaciones_updated_at();
