import '../../../shared/src/domain/entities/cita.dart';
import '../../../shared/src/domain/repositories/i_cita_repository.dart';
import '../datasources/cita_datasource.dart';
import '../models/cita_dto.dart';

class CitaRepositoryImpl implements ICitaRepository {
  final CitaDatasource _datasource;

  CitaRepositoryImpl(this._datasource);

  Cita _mapFromDto(CitaDto dto) {
    return Cita(
      id: dto.id,
      clienteId: dto.clienteId,
      usuarioId: dto.usuarioId,
      titulo: dto.titulo,
      descripcion: dto.descripcion,
      fechaInicio: dto.fechaInicio,
      fechaFin: dto.fechaFin,
      estado: dto.estado,
      notas: dto.notas,
      activo: dto.activo,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  CitaDto _mapToDto(Cita entity) {
    return CitaDto(
      id: entity.id,
      clienteId: entity.clienteId,
      usuarioId: entity.usuarioId,
      titulo: entity.titulo,
      descripcion: entity.descripcion,
      fechaInicio: entity.fechaInicio,
      fechaFin: entity.fechaFin,
      estado: entity.estado,
      notas: entity.notas,
      activo: entity.activo,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Future<List<Cita>> obtenerTodos() async {
    final dtos = await _datasource.obtenerTodos();
    return dtos.map(_mapFromDto).toList();
  }

  @override
  Future<Cita?> obtenerPorId(String id) async {
    final dto = await _datasource.obtenerPorId(id);
    return dto != null ? _mapFromDto(dto) : null;
  }

  @override
  Future<List<Cita>> obtenerPorCliente(String clienteId) async {
    final dtos = await _datasource.obtenerPorCliente(clienteId);
    return dtos.map(_mapFromDto).toList();
  }

  @override
  Future<List<Cita>> obtenerPorFecha(DateTime fecha) async {
    final dtos = await _datasource.obtenerPorFecha(fecha);
    return dtos.map(_mapFromDto).toList();
  }

  @override
  Future<Cita> crear(Cita cita) async {
    final dto = await _datasource.crear(_mapToDto(cita));
    return _mapFromDto(dto);
  }

  @override
  Future<void> actualizar(Cita cita) async {
    await _datasource.actualizar(_mapToDto(cita));
  }

  @override
  Future<void> eliminar(String id) async {
    await _datasource.eliminar(id);
  }
}
