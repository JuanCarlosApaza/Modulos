import '../entities/inventario.dart';
import '../entities/movimiento_inventario.dart';

abstract class IInventarioRepository {
  Future<List<Inventario>> obtenerTodos();
  Future<List<Inventario>> obtenerStockBajo();
  Future<List<MovimientoInventario>> obtenerMovimientos(String productoId);
  Future<void> actualizar(Inventario item);
  Future<void> eliminar(String id);
  Future<List<MovimientoInventario>> obtenerTodosMovimientos();
  Future<MovimientoInventario> registrarMovimiento({
    required String productoId,
    required String tipo,
    required int cantidad,
    String? descripcion,
    required String usuarioId,
  });
}
