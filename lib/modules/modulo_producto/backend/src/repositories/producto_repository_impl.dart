import '../../../shared/src/domain/entities/producto.dart';
import '../../../shared/src/domain/repositories/iproducto_repository.dart';
import '../datasources/producto_datasource.dart';
import '../models/producto_dto.dart';

class ProductoRepositoryImpl implements IProductoRepository {
  final ProductoDatasource datasource;

  ProductoRepositoryImpl(this.datasource);

  @override
  Future<List<Producto>> obtenerTodos() async {
    final dtos = await datasource.obtenerTodos();
    return dtos.map((dto) => _toDomain(dto)).toList();
  }

  @override
  Future<Producto?> obtenerPorId(String id) async {
    final dto = await datasource.obtenerPorId(id);
    return dto != null ? _toDomain(dto) : null;
  }

  @override
  Future<Producto> crear(Producto producto) async {
    final dto = _toDto(producto);
    final creado = await datasource.crear(dto);
    return _toDomain(creado);
  }

  @override
  Future<void> actualizar(Producto producto) async {
    final dto = _toDto(producto);
    await datasource.actualizar(dto);
  }

  @override
  Future<void> eliminar(String id) async {
    await datasource.eliminar(id);
  }

  Producto _toDomain(ProductoDto dto) {
    return Producto(
      id: dto.id,
      nombre: dto.nombre,
      descripcion: dto.descripcion,
      sku: dto.sku,
      precioCompra: dto.precioCompra,
      precioVenta: dto.precioVenta,
      unidadMedida: dto.unidadMedida,
      categoriaId: dto.categoriaId,
      stockActual: dto.stockActual,
      stockMinimo: dto.stockMinimo,
      activo: dto.activo,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  ProductoDto _toDto(Producto producto) {
    return ProductoDto(
      id: producto.id,
      nombre: producto.nombre,
      descripcion: producto.descripcion,
      sku: producto.sku,
      precioCompra: producto.precioCompra,
      precioVenta: producto.precioVenta,
      unidadMedida: producto.unidadMedida,
      categoriaId: producto.categoriaId,
      stockActual: producto.stockActual,
      stockMinimo: producto.stockMinimo,
      activo: producto.activo,
      createdAt: producto.createdAt,
      updatedAt: producto.updatedAt,
    );
  }
}
