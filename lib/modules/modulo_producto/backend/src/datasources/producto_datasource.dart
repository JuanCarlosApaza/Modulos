import '../models/producto_dto.dart';

abstract class ProductoDatasource {
  Future<List<ProductoDto>> obtenerTodos();
  Future<ProductoDto?> obtenerPorId(String id);
  Future<ProductoDto> crear(ProductoDto producto);
  Future<void> actualizar(ProductoDto producto);
  Future<void> eliminar(String id);
}
