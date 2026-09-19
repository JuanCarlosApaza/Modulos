class ProductoDto {
  final String id;
  final String nombre;
  final String? descripcion;
  final String? sku;
  final double precioCompra;
  final double precioVenta;
  final String unidadMedida;
  final String? categoriaId;
  final int stockActual;
  final int stockMinimo;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductoDto({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.sku,
    required this.precioCompra,
    required this.precioVenta,
    required this.unidadMedida,
    this.categoriaId,
    required this.stockActual,
    required this.stockMinimo,
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductoDto.fromJson(Map<String, dynamic> json) {
    return ProductoDto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      sku: json['sku'] as String?,
      precioCompra: (json['precio_compra'] as num?)?.toDouble() ?? 0.0,
      precioVenta: (json['precio_venta'] as num?)?.toDouble() ?? 0.0,
      unidadMedida: json['unidad_medida'] as String? ?? 'pieza',
      categoriaId: json['categoria_id'] as String?,
      stockActual: json['stock_actual'] as int? ?? 0,
      stockMinimo: json['stock_minimo'] as int? ?? 0,
      activo: json['activo'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'sku': sku,
      'precio_compra': precioCompra,
      'precio_venta': precioVenta,
      'unidad_medida': unidadMedida,
      'categoria_id': categoriaId,
      'stock_actual': stockActual,
      'stock_minimo': stockMinimo,
      'activo': activo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class CategoriaDto {
  final String id;
  final String nombre;
  final String? descripcion;
  final bool activa;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoriaDto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.activa,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoriaDto.fromJson(Map<String, dynamic> json) {
    return CategoriaDto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      activa: json['activa'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'activa': activa,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
