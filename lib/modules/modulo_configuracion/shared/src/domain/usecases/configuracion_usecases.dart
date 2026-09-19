import '../entities/configuracion.dart';
import '../failures/failure.dart';
import '../repositories/i_configuracion_repository.dart';

class ObtenerTodasConfiguracionUseCase {
  final IConfiguracionRepository _repository;

  ObtenerTodasConfiguracionUseCase(this._repository);

  Future<(Failure?, List<Configuracion>?)> call() async {
    try {
      final configuraciones = await _repository.obtenerTodas();
      return (null, configuraciones);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class CrearConfiguracionUseCase {
  final IConfiguracionRepository _repository;

  CrearConfiguracionUseCase(this._repository);

  Future<(Failure?, Configuracion?)> call(Configuracion configuracion) async {
    try {
      final nueva = await _repository.crear(configuracion);
      return (null, nueva);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ActualizarConfiguracionUseCase {
  final IConfiguracionRepository _repository;

  ActualizarConfiguracionUseCase(this._repository);

  Future<(Failure?, bool?)> call(Configuracion configuracion) async {
    try {
      await _repository.actualizar(configuracion);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class EliminarConfiguracionUseCase {
  final IConfiguracionRepository _repository;

  EliminarConfiguracionUseCase(this._repository);

  Future<(Failure?, bool?)> call(String id) async {
    try {
      await _repository.eliminar(id);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}
