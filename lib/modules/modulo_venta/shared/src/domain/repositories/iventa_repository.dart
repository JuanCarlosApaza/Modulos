import '../entities/venta.dart';

abstract class IVentaRepository {
  Future<List<Venta>> obtenerTodos();
  Future<Venta?> obtenerPorId(String id);
  Future<Venta> crear(Venta venta);
  Future<void> eliminar(String id);
}
