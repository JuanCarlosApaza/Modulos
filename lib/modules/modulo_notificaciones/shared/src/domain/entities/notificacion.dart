class Notificacion {
  final String id;
  final String titulo;
  final String mensaje;
  final String tipo;
  final String usuarioId;
  final bool leida;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Notificacion({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.usuarioId,
    this.leida = false,
    this.createdAt,
    this.updatedAt,
  });

  Notificacion copyWith({
    String? id,
    String? titulo,
    String? mensaje,
    String? tipo,
    String? usuarioId,
    bool? leida,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Notificacion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      tipo: tipo ?? this.tipo,
      usuarioId: usuarioId ?? this.usuarioId,
      leida: leida ?? this.leida,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Notificacion &&
        other.id == id &&
        other.titulo == titulo &&
        other.mensaje == mensaje &&
        other.tipo == tipo &&
        other.usuarioId == usuarioId &&
        other.leida == leida &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      titulo,
      mensaje,
      tipo,
      usuarioId,
      leida,
      createdAt,
      updatedAt,
    );
  }
}
