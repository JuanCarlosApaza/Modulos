import '../entities/configuracion.dart';

abstract class IConfiguracionRepository {
  Future<List<Configuracion>> obtenerTodas();
  Future<Configuracion> crear(Configuracion configuracion);
  Future<void> actualizar(Configuracion configuracion);
  Future<void> eliminar(String id);
}
