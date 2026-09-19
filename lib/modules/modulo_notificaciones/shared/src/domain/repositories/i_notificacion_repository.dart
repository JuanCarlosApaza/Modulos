import '../entities/notificacion.dart';

abstract class INotificacionRepository {
  Future<List<Notificacion>> obtenerTodas();
  Future<List<Notificacion>> obtenerNoLeidas();
  Future<Notificacion> crear(Notificacion notificacion);
  Future<void> marcarComoLeida(String id);
  Future<void> marcarTodasComoLeidas();
  Future<void> eliminar(String id);
}
