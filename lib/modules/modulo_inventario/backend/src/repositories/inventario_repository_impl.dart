import '../../../shared/src/domain/entities/inventario.dart';
import '../../../shared/src/domain/entities/movimiento_inventario.dart';
import '../../../shared/src/domain/repositories/i_inventario_repository.dart';
import '../datasources/inventario_datasource.dart';
import '../models/inventario_dto.dart' as dto;

class InventarioRepositoryImpl implements IInventarioRepository {
  final InventarioDatasource _datasource;

  InventarioRepositoryImpl(this._datasource);

  Inventario _mapDtoToEntity(dto.InventarioDto d) {
    return Inventario(
      id: d.id,
      productoId: d.productoId,
      productoNombre: d.productoNombre,
      stockActual: d.stockActual,
      stockMinimo: d.stockMinimo,
      stockMaximo: d.stockMaximo,
      ubicacion: d.ubicacion,
      activo: d.activo,
      createdAt: d.createdAt,
      updatedAt: d.updatedAt,
    );
  }

  dto.InventarioDto _mapEntityToDto(Inventario entity) {
    return dto.InventarioDto(
      id: entity.id,
      productoId: entity.productoId,
      productoNombre: entity.productoNombre,
      stockActual: entity.stockActual,
      stockMinimo: entity.stockMinimo,
      stockMaximo: entity.stockMaximo,
      ubicacion: entity.ubicacion,
      activo: entity.activo,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  MovimientoInventario _mapMovimientoDtoToEntity(
      dto.MovimientoInventarioDto d) {
    return MovimientoInventario(
      id: d.id,
      productoId: d.productoId,
      tipo: d.tipo,
      cantidad: d.cantidad,
      descripcion: d.descripcion,
      usuarioId: d.usuarioId,
      createdAt: d.createdAt,
    );
  }

  @override
  Future<List<Inventario>> obtenerTodos() async {
    final dtos = await _datasource.obtenerTodos();
    return dtos.map(_mapDtoToEntity).toList();
  }

  @override
  Future<List<Inventario>> obtenerStockBajo() async {
    final dtos = await _datasource.obtenerStockBajo();
    return dtos.map(_mapDtoToEntity).toList();
  }

  @override
  Future<List<MovimientoInventario>> obtenerMovimientos(
      String productoId) async {
    final dtos = await _datasource.obtenerMovimientos(productoId);
    return dtos.map(_mapMovimientoDtoToEntity).toList();
  }

  @override
  Future<void> actualizar(Inventario item) async {
    await _datasource.actualizar(_mapEntityToDto(item));
  }

  @override
  Future<void> eliminar(String id) async {
    await _datasource.eliminar(id);
  }

  @override
  Future<List<MovimientoInventario>> obtenerTodosMovimientos() async {
    final dtos = await _datasource.obtenerTodosMovimientos();
    return dtos.map(_mapMovimientoDtoToEntity).toList();
  }

  @override
  Future<MovimientoInventario> registrarMovimiento({
    required String productoId,
    required String tipo,
    required int cantidad,
    String? descripcion,
    required String usuarioId,
  }) async {
    final result = await _datasource.registrarMovimiento(
      productoId: productoId,
      tipo: tipo,
      cantidad: cantidad,
      descripcion: descripcion,
      usuarioId: usuarioId,
    );
    return _mapMovimientoDtoToEntity(result);
  }
}
