class VentaDto {
  final String id;
  final String? clienteId;
  final String usuarioId;
  final int? folio;
  final double subtotal;
  final double descuento;
  final double total;
  final String metodoPago;
  final String estado;
  final String? notas;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VentaDto({
    required this.id,
    this.clienteId,
    required this.usuarioId,
    this.folio,
    required this.subtotal,
    required this.descuento,
    required this.total,
    required this.metodoPago,
    required this.estado,
    this.notas,
    this.createdAt,
    this.updatedAt,
  });

  factory VentaDto.fromJson(Map<String, dynamic> json) {
    return VentaDto(
      id: json['id'] as String,
      clienteId: json['cliente_id'] as String?,
      usuarioId: json['usuario_id'] as String,
      folio: json['folio'] as int?,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      descuento: (json['descuento'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      metodoPago: json['metodo_pago'] as String? ?? 'efectivo',
      estado: json['estado'] as String? ?? 'completada',
      notas: json['notas'] as String?,
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
      'cliente_id': clienteId,
      'usuario_id': usuarioId,
      'folio': folio,
      'subtotal': subtotal,
      'descuento': descuento,
      'total': total,
      'metodo_pago': metodoPago,
      'estado': estado,
      'notas': notas,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class VentaDetalleDto {
  final String id;
  final String ventaId;
  final String productoId;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final DateTime? createdAt;

  const VentaDetalleDto({
    required this.id,
    required this.ventaId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    this.createdAt,
  });

  factory VentaDetalleDto.fromJson(Map<String, dynamic> json) {
    return VentaDetalleDto(
      id: json['id'] as String,
      ventaId: json['venta_id'] as String,
      productoId: json['producto_id'] as String,
      cantidad: json['cantidad'] as int? ?? 1,
      precioUnitario: (json['precio_unitario'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venta_id': ventaId,
      'producto_id': productoId,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario,
      'subtotal': subtotal,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
