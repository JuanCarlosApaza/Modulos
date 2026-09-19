class UsuarioDto {
  final String id;
  final String nombre;
  final String email;
  final String? passwordHash;
  final String? telefono;
  final String rolId;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UsuarioDto({
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

  factory UsuarioDto.fromJson(Map<String, dynamic> json) {
    return UsuarioDto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      passwordHash: json['password_hash'] as String?,
      telefono: json['telefono'] as String?,
      rolId: json['rol_id'] as String,
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
      'email': email,
      'password_hash': passwordHash,
      'telefono': telefono,
      'rol_id': rolId,
      'activo': activo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class RolDto {
  final String id;
  final String nombre;
  final String? descripcion;
  final DateTime? createdAt;

  const RolDto({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.createdAt,
  });

  factory RolDto.fromJson(Map<String, dynamic> json) {
    return RolDto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
