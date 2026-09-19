import '../models/venta_dto.dart';

abstract class VentaDatasource {
  Future<List<VentaDto>> obtenerTodos();
  Future<VentaDto?> obtenerPorId(String id);
  Future<VentaDto> crear(VentaDto venta);
  Future<void> eliminar(String id);
}
