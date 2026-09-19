import '../../../shared/src/domain/entities/configuracion.dart';
import '../../../shared/src/domain/repositories/i_configuracion_repository.dart';
import '../datasources/configuracion_datasource.dart';
import '../models/configuracion_dto.dart' as dto;

class ConfiguracionRepositoryImpl implements IConfiguracionRepository {
  final ConfiguracionDatasource _datasource;

  ConfiguracionRepositoryImpl(this._datasource);

  Configuracion _mapDtoToEntity(dto.ConfiguracionDto d) {
    return Configuracion(
      id: d.id,
      clave: d.clave,
      valor: d.valor,
      descripcion: d.descripcion,
      categoria: d.categoria,
      createdAt: d.createdAt,
      updatedAt: d.updatedAt,
    );
  }

  dto.ConfiguracionDto _mapEntityToDto(Configuracion entity) {
    return dto.ConfiguracionDto(
      id: entity.id,
      clave: entity.clave,
      valor: entity.valor,
      descripcion: entity.descripcion,
      categoria: entity.categoria,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Future<List<Configuracion>> obtenerTodas() async {
    final dtos = await _datasource.obtenerTodas();
    return dtos.map(_mapDtoToEntity).toList();
  }

  @override
  Future<Configuracion> crear(Configuracion configuracion) async {
    final result = await _datasource.crear(_mapEntityToDto(configuracion));
    return _mapDtoToEntity(result);
  }

  @override
  Future<void> actualizar(Configuracion configuracion) async {
    await _datasource.actualizar(_mapEntityToDto(configuracion));
  }

  @override
  Future<void> eliminar(String id) async {
    await _datasource.eliminar(id);
  }
}
