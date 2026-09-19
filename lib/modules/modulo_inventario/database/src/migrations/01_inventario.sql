-- ============================================
-- Migración 01: Tabla de Inventario
-- PostgreSQL
-- ============================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Tabla principal de inventario
CREATE TABLE IF NOT EXISTS inventario (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    producto_id     UUID NOT NULL,
    producto_nombre VARCHAR(255) NOT NULL,
    stock_actual    INTEGER NOT NULL DEFAULT 0,
    stock_minimo    INTEGER NOT NULL DEFAULT 0,
    stock_maximo    INTEGER NOT NULL DEFAULT 0,
    ubicacion       VARCHAR(255) NOT NULL,
    activo          BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_inventario_producto_id ON inventario (producto_id);
CREATE INDEX idx_inventario_stock_actual ON inventario (stock_actual);
CREATE INDEX idx_inventario_activo ON inventario (activo);
CREATE INDEX idx_inventario_ubicacion ON inventario (ubicacion);

-- Tabla de movimientos de inventario
CREATE TABLE IF NOT EXISTS movimientos_inventario (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    producto_id     UUID NOT NULL,
    tipo            VARCHAR(50) NOT NULL,
    cantidad        INTEGER NOT NULL,
    descripcion     TEXT,
    usuario_id      UUID NOT NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para movimientos
CREATE INDEX idx_movimientos_producto_id ON movimientos_inventario (producto_id);
CREATE INDEX idx_movimientos_usuario_id ON movimientos_inventario (usuario_id);
CREATE INDEX idx_movimientos_tipo ON movimientos_inventario (tipo);
CREATE INDEX idx_movimientos_created_at ON movimientos_inventario (created_at);

-- Trigger para actualizar updated_at en inventario
CREATE OR REPLACE FUNCTION update_inventario_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_inventario_updated_at
    BEFORE UPDATE ON inventario
    FOR EACH ROW
    EXECUTE FUNCTION update_inventario_updated_at();
