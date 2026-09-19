-- Migration 01: Create citas table

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS citas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL,
    usuario_id UUID NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_inicio TIMESTAMP WITH TIME ZONE NOT NULL,
    fecha_fin TIMESTAMP WITH TIME ZONE NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'pendiente',
    notas TEXT,
    activo BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_citas_cliente_id ON citas(cliente_id);
CREATE INDEX idx_citas_usuario_id ON citas(usuario_id);
CREATE INDEX idx_citas_estado ON citas(estado);
CREATE INDEX idx_citas_fecha_inicio ON citas(fecha_inicio);
CREATE INDEX idx_citas_activo ON citas(activo);

-- Auto-update updated_at trigger
CREATE OR REPLACE FUNCTION update_citas_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_citas_updated_at
    BEFORE UPDATE ON citas
    FOR EACH ROW
    EXECUTE FUNCTION update_citas_updated_at();
