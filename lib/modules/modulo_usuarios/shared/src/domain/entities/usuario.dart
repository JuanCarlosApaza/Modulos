class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String? passwordHash;
  final String? telefono;
  final String rolId;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    this.passwordHash,
    this.telefono,
    required this.rolId,
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  Usuario copyWith({
    String? id,
    String? nombre,
    String? email,
    String? passwordHash,
    String? telefono,
    String? rolId,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      telefono: telefono ?? this.telefono,
      rolId: rolId ?? this.rolId,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Usuario &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          email == other.email &&
          passwordHash == other.passwordHash &&
          telefono == other.telefono &&
          rolId == other.rolId &&
          activo == other.activo &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
        id,
        nombre,
        email,
        passwordHash,
        telefono,
        rolId,
        activo,
        createdAt,
        updatedAt,
      );
}

class Rol {
  final String id;
  final String nombre;
  final String? descripcion;
  final DateTime? createdAt;

  const Rol({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.createdAt,
  });

  Rol copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    DateTime? createdAt,
  }) {
    return Rol(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rol &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          descripcion == other.descripcion &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(id, nombre, descripcion, createdAt);
}
