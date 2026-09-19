class Configuracion {
  final String id;
  final String clave;
  final String valor;
  final String? descripcion;
  final String categoria;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Configuracion({
    required this.id,
    required this.clave,
    required this.valor,
    this.descripcion,
    required this.categoria,
    this.createdAt,
    this.updatedAt,
  });

  Configuracion copyWith({
    String? id,
    String? clave,
    String? valor,
    String? descripcion,
    String? categoria,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Configuracion(
      id: id ?? this.id,
      clave: clave ?? this.clave,
      valor: valor ?? this.valor,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Configuracion &&
        other.id == id &&
        other.clave == clave &&
        other.valor == valor &&
        other.descripcion == descripcion &&
        other.categoria == categoria &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      clave,
      valor,
      descripcion,
      categoria,
      createdAt,
      updatedAt,
    );
  }
}
