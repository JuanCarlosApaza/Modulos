import '../entities/notificacion.dart';
import '../failures/failure.dart';
import '../repositories/i_notificacion_repository.dart';

class ObtenerTodasNotificacionesUseCase {
  final INotificacionRepository _repository;

  ObtenerTodasNotificacionesUseCase(this._repository);

  Future<(Failure?, List<Notificacion>?)> call() async {
    try {
      final notificaciones = await _repository.obtenerTodas();
      return (null, notificaciones);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerNoLeidasUseCase {
  final INotificacionRepository _repository;

  ObtenerNoLeidasUseCase(this._repository);

  Future<(Failure?, List<Notificacion>?)> call() async {
    try {
      final notificaciones = await _repository.obtenerNoLeidas();
      return (null, notificaciones);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class CrearNotificacionUseCase {
  final INotificacionRepository _repository;

  CrearNotificacionUseCase(this._repository);

  Future<(Failure?, Notificacion?)> call(Notificacion notificacion) async {
    try {
      final nueva = await _repository.crear(notificacion);
      return (null, nueva);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class MarcarComoLeidaUseCase {
  final INotificacionRepository _repository;

  MarcarComoLeidaUseCase(this._repository);

  Future<(Failure?, bool?)> call(String id) async {
    try {
      await _repository.marcarComoLeida(id);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class MarcarTodasComoLeidasUseCase {
  final INotificacionRepository _repository;

  MarcarTodasComoLeidasUseCase(this._repository);

  Future<(Failure?, bool?)> call() async {
    try {
      await _repository.marcarTodasComoLeidas();
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class EliminarNotificacionUseCase {
  final INotificacionRepository _repository;

  EliminarNotificacionUseCase(this._repository);

  Future<(Failure?, bool?)> call(String id) async {
    try {
      await _repository.eliminar(id);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}
