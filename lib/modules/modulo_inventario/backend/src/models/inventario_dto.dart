class InventarioDto {
  final String id;
  final String productoId;
  final String productoNombre;
  final int stockActual;
  final int stockMinimo;
  final int stockMaximo;
  final String ubicacion;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const InventarioDto({
    required this.id,
    required this.productoId,
    required this.productoNombre,
    required this.stockActual,
    required this.stockMinimo,
    required this.stockMaximo,
    required this.ubicacion,
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  factory InventarioDto.fromJson(Map<String, dynamic> json) {
    return InventarioDto(
      id: json['id'] as String,
      productoId: json['producto_id'] as String,
      productoNombre: json['producto_nombre'] as String,
      stockActual: json['stock_actual'] as int,
      stockMinimo: json['stock_minimo'] as int,
      stockMaximo: json['stock_maximo'] as int,
      ubicacion: json['ubicacion'] as String,
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
      'producto_id': productoId,
      'producto_nombre': productoNombre,
      'stock_actual': stockActual,
      'stock_minimo': stockMinimo,
      'stock_maximo': stockMaximo,
      'ubicacion': ubicacion,
      'activo': activo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class MovimientoInventarioDto {
  final String id;
  final String productoId;
  final String tipo;
  final int cantidad;
  final String? descripcion;
  final String usuarioId;
  final DateTime? createdAt;

  const MovimientoInventarioDto({
    required this.id,
    required this.productoId,
    required this.tipo,
    required this.cantidad,
    this.descripcion,
    required this.usuarioId,
    this.createdAt,
  });

  factory MovimientoInventarioDto.fromJson(Map<String, dynamic> json) {
    return MovimientoInventarioDto(
      id: json['id'] as String,
      productoId: json['producto_id'] as String,
      tipo: json['tipo'] as String,
      cantidad: json['cantidad'] as int,
      descripcion: json['descripcion'] as String?,
      usuarioId: json['usuario_id'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto_id': productoId,
      'tipo': tipo,
      'cantidad': cantidad,
      'descripcion': descripcion,
      'usuario_id': usuarioId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
