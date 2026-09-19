-- =============================================================================
-- MÓDULO PRODUCTOS: Migración 01 - Productos y Categorías
-- =============================================================================

-- 1. Tabla de Categorías
CREATE TABLE IF NOT EXISTS categorias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    activa BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Tabla de Productos
CREATE TABLE IF NOT EXISTS productos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    sku VARCHAR(50),
    precio_compra DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    precio_venta DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    unidad_medida VARCHAR(30) NOT NULL DEFAULT 'pieza',
    categoria_id UUID REFERENCES categorias(id),
    stock_actual INTEGER NOT NULL DEFAULT 0,
    stock_minimo INTEGER NOT NULL DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices de búsqueda
CREATE INDEX IF NOT EXISTS idx_productos_nombre ON productos(nombre);
CREATE INDEX IF NOT EXISTS idx_productos_sku ON productos(sku);
CREATE INDEX IF NOT EXISTS idx_productos_categoria_id ON productos(categoria_id);
CREATE INDEX IF NOT EXISTS idx_productos_activo ON productos(activo);
CREATE INDEX IF NOT EXISTS idx_categorias_nombre ON categorias(nombre);
CREATE INDEX IF NOT EXISTS idx_categorias_activa ON categorias(activa);

-- Trigger de updated_at para productos
CREATE TRIGGER update_productos_updated_at
BEFORE UPDATE ON productos
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger de updated_at para categorías
CREATE TRIGGER update_categorias_updated_at
BEFORE UPDATE ON categorias
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
