import '../models/configuracion_dto.dart' as dto;

abstract class ConfiguracionDatasource {
  Future<List<dto.ConfiguracionDto>> obtenerTodas();
  Future<dto.ConfiguracionDto> crear(dto.ConfiguracionDto configuracion);
  Future<void> actualizar(dto.ConfiguracionDto configuracion);
  Future<void> eliminar(String id);
}
