import '../entities/usuario.dart';
import '../failures/failure.dart';
import '../repositories/i_usuario_repository.dart';

class ObtenerTodosUsuariosUseCase {
  final IUsuarioRepository _repository;

  ObtenerTodosUsuariosUseCase(this._repository);

  Future<(Failure?, List<Usuario>?)> call() async {
    try {
      final usuarios = await _repository.obtenerTodos();
      return (null, usuarios);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerUsuarioPorIdUseCase {
  final IUsuarioRepository _repository;

  ObtenerUsuarioPorIdUseCase(this._repository);

  Future<(Failure?, Usuario?)> call(String id) async {
    try {
      final usuario = await _repository.obtenerPorId(id);
      if (usuario == null) {
        return (const NotFoundFailure(message: 'Usuario no encontrado'), null);
      }
      return (null, usuario);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class CrearUsuarioUseCase {
  final IUsuarioRepository _repository;

  CrearUsuarioUseCase(this._repository);

  Future<(Failure?, Usuario?)> call(Usuario usuario) async {
    try {
      final nuevo = await _repository.crear(usuario);
      return (null, nuevo);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ActualizarUsuarioUseCase {
  final IUsuarioRepository _repository;

  ActualizarUsuarioUseCase(this._repository);

  Future<(Failure?, bool?)> call(Usuario usuario) async {
    try {
      await _repository.actualizar(usuario);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class EliminarUsuarioUseCase {
  final IUsuarioRepository _repository;

  EliminarUsuarioUseCase(this._repository);

  Future<(Failure?, bool?)> call(String id) async {
    try {
      await _repository.eliminar(id);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerRolesUseCase {
  final IUsuarioRepository _repository;

  ObtenerRolesUseCase(this._repository);

  Future<(Failure?, List<Rol>?)> call() async {
    try {
      final roles = await _repository.obtenerRoles();
      return (null, roles);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}
