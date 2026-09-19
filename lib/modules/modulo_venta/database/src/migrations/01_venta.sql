-- =============================================================================
-- MÓDULO VENTAS: Migración 01 - Ventas y Detalles
-- =============================================================================

-- 1. Tabla de Ventas
CREATE TABLE IF NOT EXISTS ventas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cliente_id UUID REFERENCES clientes(id),
    usuario_id UUID NOT NULL REFERENCES usuarios(id),
    folio SERIAL,
    subtotal DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    descuento DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    total DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    metodo_pago VARCHAR(30) NOT NULL DEFAULT 'efectivo',
    estado VARCHAR(30) NOT NULL DEFAULT 'completada',
    notas TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Tabla de Detalles de Venta
CREATE TABLE IF NOT EXISTS venta_detalles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    venta_id UUID NOT NULL REFERENCES ventas(id) ON DELETE CASCADE,
    producto_id UUID NOT NULL REFERENCES productos(id),
    cantidad INTEGER NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    subtotal DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices de búsqueda
CREATE INDEX IF NOT EXISTS idx_ventas_cliente_id ON ventas(cliente_id);
CREATE INDEX IF NOT EXISTS idx_ventas_usuario_id ON ventas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_ventas_folio ON ventas(folio);
CREATE INDEX IF NOT EXISTS idx_ventas_estado ON ventas(estado);
CREATE INDEX IF NOT EXISTS idx_ventas_created_at ON ventas(created_at);
CREATE INDEX IF NOT EXISTS idx_venta_detalles_venta_id ON venta_detalles(venta_id);
CREATE INDEX IF NOT EXISTS idx_venta_detalles_producto_id ON venta_detalles(producto_id);

-- Trigger de updated_at para ventas
CREATE TRIGGER update_ventas_updated_at
BEFORE UPDATE ON ventas
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
