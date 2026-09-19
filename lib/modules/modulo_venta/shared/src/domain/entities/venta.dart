class Venta {
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

  const Venta({
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

  Venta copyWith({
    String? id,
    String? clienteId,
    String? usuarioId,
    int? folio,
    double? subtotal,
    double? descuento,
    double? total,
    String? metodoPago,
    String? estado,
    String? notas,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Venta(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      usuarioId: usuarioId ?? this.usuarioId,
      folio: folio ?? this.folio,
      subtotal: subtotal ?? this.subtotal,
      descuento: descuento ?? this.descuento,
      total: total ?? this.total,
      metodoPago: metodoPago ?? this.metodoPago,
      estado: estado ?? this.estado,
      notas: notas ?? this.notas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Venta &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class VentaDetalle {
  final String id;
  final String ventaId;
  final String productoId;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final DateTime? createdAt;

  const VentaDetalle({
    required this.id,
    required this.ventaId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    this.createdAt,
  });

  VentaDetalle copyWith({
    String? id,
    String? ventaId,
    String? productoId,
    int? cantidad,
    double? precioUnitario,
    double? subtotal,
    DateTime? createdAt,
  }) {
    return VentaDetalle(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      subtotal: subtotal ?? this.subtotal,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VentaDetalle &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
