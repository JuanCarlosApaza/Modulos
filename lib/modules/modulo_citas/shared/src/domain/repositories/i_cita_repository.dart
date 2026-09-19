import '../entities/cita.dart';

abstract class ICitaRepository {
  Future<List<Cita>> obtenerTodos();
  Future<Cita?> obtenerPorId(String id);
  Future<List<Cita>> obtenerPorCliente(String clienteId);
  Future<List<Cita>> obtenerPorFecha(DateTime fecha);
  Future<Cita> crear(Cita cita);
  Future<void> actualizar(Cita cita);
  Future<void> eliminar(String id);
}
