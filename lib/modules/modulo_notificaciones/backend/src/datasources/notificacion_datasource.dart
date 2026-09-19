import '../models/notificacion_dto.dart' as dto;

abstract class NotificacionDatasource {
  Future<List<dto.NotificacionDto>> obtenerTodas();
  Future<List<dto.NotificacionDto>> obtenerNoLeidas();
  Future<dto.NotificacionDto> crear(dto.NotificacionDto notificacion);
  Future<void> marcarComoLeida(String id);
  Future<void> marcarTodasComoLeidas();
  Future<void> eliminar(String id);
}
