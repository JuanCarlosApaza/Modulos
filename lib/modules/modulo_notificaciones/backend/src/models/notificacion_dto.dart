class NotificacionDto {
  final String id;
  final String titulo;
  final String mensaje;
  final String tipo;
  final String usuarioId;
  final bool leida;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificacionDto({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.usuarioId,
    this.leida = false,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificacionDto.fromJson(Map<String, dynamic> json) {
    return NotificacionDto(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      mensaje: json['mensaje'] as String,
      tipo: json['tipo'] as String,
      usuarioId: json['usuario_id'] as String,
      leida: json['leida'] as bool? ?? false,
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
      'titulo': titulo,
      'mensaje': mensaje,
      'tipo': tipo,
      'usuario_id': usuarioId,
      'leida': leida,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
