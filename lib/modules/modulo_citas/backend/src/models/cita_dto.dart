class CitaDto {
  final String id;
  final String clienteId;
  final String usuarioId;
  final String titulo;
  final String? descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String estado;
  final String? notas;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CitaDto({
    required this.id,
    required this.clienteId,
    required this.usuarioId,
    required this.titulo,
    this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    this.estado = 'pendiente',
    this.notas,
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  factory CitaDto.fromJson(Map<String, dynamic> json) {
    return CitaDto(
      id: json['id'] as String,
      clienteId: json['cliente_id'] as String,
      usuarioId: json['usuario_id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String?,
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: DateTime.parse(json['fecha_fin'] as String),
      estado: json['estado'] as String? ?? 'pendiente',
      notas: json['notas'] as String?,
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
      'cliente_id': clienteId,
      'usuario_id': usuarioId,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_fin': fechaFin.toIso8601String(),
      'estado': estado,
      'notas': notas,
      'activo': activo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
