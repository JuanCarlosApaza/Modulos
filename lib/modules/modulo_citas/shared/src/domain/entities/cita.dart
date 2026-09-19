class Cita {
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

  const Cita({
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

  Cita copyWith({
    String? id,
    String? clienteId,
    String? usuarioId,
    String? titulo,
    String? descripcion,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? estado,
    String? notas,
    bool? activo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cita(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      usuarioId: usuarioId ?? this.usuarioId,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      estado: estado ?? this.estado,
      notas: notas ?? this.notas,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cita &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          clienteId == other.clienteId &&
          usuarioId == other.usuarioId &&
          titulo == other.titulo &&
          descripcion == other.descripcion &&
          fechaInicio == other.fechaInicio &&
          fechaFin == other.fechaFin &&
          estado == other.estado &&
          notas == other.notas &&
          activo == other.activo &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
        id,
        clienteId,
        usuarioId,
        titulo,
        descripcion,
        fechaInicio,
        fechaFin,
        estado,
        notas,
        activo,
        createdAt,
        updatedAt,
      );
}
