class Producto {
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

  const Producto({
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

  Producto copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? sku,
    double? precioCompra,
    double? precioVenta,
    String? unidadMedida,
    String? categoriaId,
    int? stockActual,
    int? stockMinimo,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      sku: sku ?? this.sku,
      precioCompra: precioCompra ?? this.precioCompra,
      precioVenta: precioVenta ?? this.precioVenta,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      categoriaId: categoriaId ?? this.categoriaId,
      stockActual: stockActual ?? this.stockActual,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Producto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre;

  @override
  int get hashCode => id.hashCode ^ nombre.hashCode;
}

class Categoria {
  final String id;
  final String nombre;
  final String? descripcion;
  final bool activa;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Categoria({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.activa,
    this.createdAt,
    this.updatedAt,
  });

  Categoria copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    bool? activa,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Categoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      activa: activa ?? this.activa,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Categoria &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre;

  @override
  int get hashCode => id.hashCode ^ nombre.hashCode;
}
