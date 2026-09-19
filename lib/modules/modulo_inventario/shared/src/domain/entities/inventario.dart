class Inventario {
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

  const Inventario({
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

  Inventario copyWith({
    String? id,
    String? productoId,
    String? productoNombre,
    int? stockActual,
    int? stockMinimo,
    int? stockMaximo,
    String? ubicacion,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Inventario(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      productoNombre: productoNombre ?? this.productoNombre,
      stockActual: stockActual ?? this.stockActual,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      stockMaximo: stockMaximo ?? this.stockMaximo,
      ubicacion: ubicacion ?? this.ubicacion,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Inventario &&
        other.id == id &&
        other.productoId == productoId &&
        other.productoNombre == productoNombre &&
        other.stockActual == stockActual &&
        other.stockMinimo == stockMinimo &&
        other.stockMaximo == stockMaximo &&
        other.ubicacion == ubicacion &&
        other.activo == activo &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      productoId,
      productoNombre,
      stockActual,
      stockMinimo,
      stockMaximo,
      ubicacion,
      activo,
      createdAt,
      updatedAt,
    );
  }
}
