import '../entities/usuario.dart';

abstract class IUsuarioRepository {
  Future<List<Usuario>> obtenerTodos();
  Future<Usuario?> obtenerPorId(String id);
  Future<Usuario> crear(Usuario usuario);
  Future<void> actualizar(Usuario usuario);
  Future<void> eliminar(String id);
  Future<List<Rol>> obtenerRoles();
}
