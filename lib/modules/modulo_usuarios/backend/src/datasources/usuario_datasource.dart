import '../models/usuario_dto.dart';

abstract class UsuarioDatasource {
  Future<List<UsuarioDto>> obtenerTodos();
  Future<UsuarioDto?> obtenerPorId(String id);
  Future<UsuarioDto> crear(UsuarioDto usuario);
  Future<void> actualizar(UsuarioDto usuario);
  Future<void> eliminar(String id);
  Future<List<Map<String, String>>> obtenerRoles();
}
