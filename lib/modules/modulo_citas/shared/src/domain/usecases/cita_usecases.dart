import '../entities/cita.dart';
import '../failures/failure.dart';
import '../repositories/i_cita_repository.dart';

class ObtenerTodasLasCitasUseCase {
  final ICitaRepository _repository;

  ObtenerTodasLasCitasUseCase(this._repository);

  Future<(Failure?, List<Cita>?)> call() async {
    try {
      final citas = await _repository.obtenerTodos();
      return (null, citas);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerCitaPorIdUseCase {
  final ICitaRepository _repository;

  ObtenerCitaPorIdUseCase(this._repository);

  Future<(Failure?, Cita?)> call(String id) async {
    try {
      final cita = await _repository.obtenerPorId(id);
      if (cita == null) {
        return (const NotFoundFailure(message: 'Cita no encontrada'), null);
      }
      return (null, cita);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerCitasPorClienteUseCase {
  final ICitaRepository _repository;

  ObtenerCitasPorClienteUseCase(this._repository);

  Future<(Failure?, List<Cita>?)> call(String clienteId) async {
    try {
      final citas = await _repository.obtenerPorCliente(clienteId);
      return (null, citas);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerCitasPorFechaUseCase {
  final ICitaRepository _repository;

  ObtenerCitasPorFechaUseCase(this._repository);

  Future<(Failure?, List<Cita>?)> call(DateTime fecha) async {
    try {
      final citas = await _repository.obtenerPorFecha(fecha);
      return (null, citas);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class CrearCitaUseCase {
  final ICitaRepository _repository;

  CrearCitaUseCase(this._repository);

  Future<(Failure?, Cita?)> call(Cita cita) async {
    try {
      final nueva = await _repository.crear(cita);
      return (null, nueva);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ActualizarCitaUseCase {
  final ICitaRepository _repository;

  ActualizarCitaUseCase(this._repository);

  Future<(Failure?, bool?)> call(Cita cita) async {
    try {
      await _repository.actualizar(cita);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class EliminarCitaUseCase {
  final ICitaRepository _repository;

  EliminarCitaUseCase(this._repository);

  Future<(Failure?, bool?)> call(String id) async {
    try {
      await _repository.eliminar(id);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}
