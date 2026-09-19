import '../../../shared/src/domain/entities/venta.dart';
import '../../../shared/src/domain/repositories/iventa_repository.dart';
import '../datasources/venta_datasource.dart';
import '../models/venta_dto.dart';

class VentaRepositoryImpl implements IVentaRepository {
  final VentaDatasource datasource;

  VentaRepositoryImpl(this.datasource);

  @override
  Future<List<Venta>> obtenerTodos() async {
    final dtos = await datasource.obtenerTodos();
    return dtos.map((dto) => _toDomain(dto)).toList();
  }

  @override
  Future<Venta?> obtenerPorId(String id) async {
    final dto = await datasource.obtenerPorId(id);
    return dto != null ? _toDomain(dto) : null;
  }

  @override
  Future<Venta> crear(Venta venta) async {
    final dto = _toDto(venta);
    final creado = await datasource.crear(dto);
    return _toDomain(creado);
  }

  @override
  Future<void> eliminar(String id) async {
    await datasource.eliminar(id);
  }

  Venta _toDomain(VentaDto dto) {
    return Venta(
      id: dto.id,
      clienteId: dto.clienteId,
      usuarioId: dto.usuarioId,
      folio: dto.folio,
      subtotal: dto.subtotal,
      descuento: dto.descuento,
      total: dto.total,
      metodoPago: dto.metodoPago,
      estado: dto.estado,
      notas: dto.notas,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  VentaDto _toDto(Venta venta) {
    return VentaDto(
      id: venta.id,
      clienteId: venta.clienteId,
      usuarioId: venta.usuarioId,
      folio: venta.folio,
      subtotal: venta.subtotal,
      descuento: venta.descuento,
      total: venta.total,
      metodoPago: venta.metodoPago,
      estado: venta.estado,
      notas: venta.notas,
      createdAt: venta.createdAt,
      updatedAt: venta.updatedAt,
    );
  }
}
