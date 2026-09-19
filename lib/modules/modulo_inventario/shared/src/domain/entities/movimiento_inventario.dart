class MovimientoInventario {
  final String id;
  final String productoId;
  final String tipo;
  final int cantidad;
  final String? descripcion;
  final String usuarioId;
  final DateTime? createdAt;

  const MovimientoInventario({
    required this.id,
    required this.productoId,
    required this.tipo,
    required this.cantidad,
    this.descripcion,
    required this.usuarioId,
    this.createdAt,
  });

  MovimientoInventario copyWith({
    String? id,
    String? productoId,
    String? tipo,
    int? cantidad,
    String? descripcion,
    String? usuarioId,
    DateTime? createdAt,
  }) {
    return MovimientoInventario(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      descripcion: descripcion ?? this.descripcion,
      usuarioId: usuarioId ?? this.usuarioId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MovimientoInventario &&
        other.id == id &&
        other.productoId == productoId &&
        other.tipo == tipo &&
        other.cantidad == cantidad &&
        other.descripcion == descripcion &&
        other.usuarioId == usuarioId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      productoId,
      tipo,
      cantidad,
      descripcion,
      usuarioId,
      createdAt,
    );
  }
}
