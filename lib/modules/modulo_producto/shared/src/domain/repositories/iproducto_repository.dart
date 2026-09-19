import '../entities/producto.dart';

abstract class IProductoRepository {
  Future<List<Producto>> obtenerTodos();
  Future<Producto?> obtenerPorId(String id);
  Future<Producto> crear(Producto producto);
  Future<void> actualizar(Producto producto);
  Future<void> eliminar(String id);
}
