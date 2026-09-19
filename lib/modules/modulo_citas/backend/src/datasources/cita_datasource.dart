import '../models/cita_dto.dart';

abstract class CitaDatasource {
  Future<List<CitaDto>> obtenerTodos();
  Future<CitaDto?> obtenerPorId(String id);
  Future<List<CitaDto>> obtenerPorCliente(String clienteId);
  Future<List<CitaDto>> obtenerPorFecha(DateTime fecha);
  Future<CitaDto> crear(CitaDto cita);
  Future<void> actualizar(CitaDto cita);
  Future<void> eliminar(String id);
}
