class ClienteDto {
  final String id;
  final String nombre;
  final String? email;
  final String? telefono;
  final String? rfc;
  final String? direccion;
  final String? notas;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ClienteDto({required this.id, required this.nombre, this.email, this.telefono, this.rfc, this.direccion, this.notas, required this.activo, this.createdAt, this.updatedAt});

  factory ClienteDto.fromJson(Map<String, dynamic> json) {
    return ClienteDto(
      id: json['id'] as String, nombre: json['nombre'] as String,
      email: json['email'] as String?, telefono: json['telefono'] as String?,
      rfc: json['rfc'] as String?, direccion: json['direccion'] as String?,
      notas: json['notas'] as String?, activo: json['activo'] as bool? ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'email': email, 'telefono': telefono, 'rfc': rfc, 'direccion': direccion, 'notas': notas, 'activo': activo, 'created_at': createdAt?.toIso8601String(), 'updated_at': updatedAt?.toIso8601String()};
  }
}
