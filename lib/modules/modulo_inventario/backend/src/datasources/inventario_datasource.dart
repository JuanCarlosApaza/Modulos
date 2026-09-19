import '../models/inventario_dto.dart' as dto;

abstract class InventarioDatasource {
  Future<List<dto.InventarioDto>> obtenerTodos();
  Future<List<dto.InventarioDto>> obtenerStockBajo();
  Future<List<dto.MovimientoInventarioDto>> obtenerMovimientos(
      String productoId);
  Future<void> actualizar(dto.InventarioDto item);
  Future<void> eliminar(String id);
  Future<List<dto.MovimientoInventarioDto>> obtenerTodosMovimientos();
  Future<dto.MovimientoInventarioDto> registrarMovimiento({
    required String productoId,
    required String tipo,
    required int cantidad,
    String? descripcion,
    required String usuarioId,
  });
}
