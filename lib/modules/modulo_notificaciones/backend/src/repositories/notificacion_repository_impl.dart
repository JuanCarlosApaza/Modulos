import '../../../shared/src/domain/entities/notificacion.dart';
import '../../../shared/src/domain/repositories/i_notificacion_repository.dart';
import '../datasources/notificacion_datasource.dart';
import '../models/notificacion_dto.dart' as dto;

class NotificacionRepositoryImpl implements INotificacionRepository {
  final NotificacionDatasource _datasource;

  NotificacionRepositoryImpl(this._datasource);

  Notificacion _mapDtoToEntity(dto.NotificacionDto d) {
    return Notificacion(
      id: d.id,
      titulo: d.titulo,
      mensaje: d.mensaje,
      tipo: d.tipo,
      usuarioId: d.usuarioId,
      leida: d.leida,
      createdAt: d.createdAt,
      updatedAt: d.updatedAt,
    );
  }

  dto.NotificacionDto _mapEntityToDto(Notificacion entity) {
    return dto.NotificacionDto(
      id: entity.id,
      titulo: entity.titulo,
      mensaje: entity.mensaje,
      tipo: entity.tipo,
      usuarioId: entity.usuarioId,
      leida: entity.leida,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Future<List<Notificacion>> obtenerTodas() async {
    final dtos = await _datasource.obtenerTodas();
    return dtos.map(_mapDtoToEntity).toList();
  }

  @override
  Future<List<Notificacion>> obtenerNoLeidas() async {
    final dtos = await _datasource.obtenerNoLeidas();
    return dtos.map(_mapDtoToEntity).toList();
  }

  @override
  Future<Notificacion> crear(Notificacion notificacion) async {
    final result = await _datasource.crear(_mapEntityToDto(notificacion));
    return _mapDtoToEntity(result);
  }

  @override
  Future<void> marcarComoLeida(String id) async {
    await _datasource.marcarComoLeida(id);
  }

  @override
  Future<void> marcarTodasComoLeidas() async {
    await _datasource.marcarTodasComoLeidas();
  }

  @override
  Future<void> eliminar(String id) async {
    await _datasource.eliminar(id);
  }
}
