import '../entities/inventario.dart';
import '../entities/movimiento_inventario.dart';
import '../failures/failure.dart';
import '../repositories/i_inventario_repository.dart';

class ObtenerTodosInventarioUseCase {
  final IInventarioRepository _repository;

  ObtenerTodosInventarioUseCase(this._repository);

  Future<(Failure?, List<Inventario>?)> call() async {
    try {
      final items = await _repository.obtenerTodos();
      return (null, items);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerStockBajoUseCase {
  final IInventarioRepository _repository;

  ObtenerStockBajoUseCase(this._repository);

  Future<(Failure?, List<Inventario>?)> call() async {
    try {
      final items = await _repository.obtenerStockBajo();
      return (null, items);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerMovimientosUseCase {
  final IInventarioRepository _repository;

  ObtenerMovimientosUseCase(this._repository);

  Future<(Failure?, List<MovimientoInventario>?)> call(String productoId) async {
    try {
      final movimientos = await _repository.obtenerMovimientos(productoId);
      return (null, movimientos);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ActualizarInventarioUseCase {
  final IInventarioRepository _repository;

  ActualizarInventarioUseCase(this._repository);

  Future<(Failure?, bool?)> call(Inventario item) async {
    try {
      await _repository.actualizar(item);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class EliminarInventarioUseCase {
  final IInventarioRepository _repository;

  EliminarInventarioUseCase(this._repository);

  Future<(Failure?, bool?)> call(String id) async {
    try {
      await _repository.eliminar(id);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerTodosMovimientosUseCase {
  final IInventarioRepository _repository;

  ObtenerTodosMovimientosUseCase(this._repository);

  Future<(Failure?, List<MovimientoInventario>?)> call() async {
    try {
      final movimientos = await _repository.obtenerTodosMovimientos();
      return (null, movimientos);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class RegistrarMovimientoUseCase {
  final IInventarioRepository _repository;

  RegistrarMovimientoUseCase(this._repository);

  Future<(Failure?, MovimientoInventario?)> call({
    required String productoId,
    required String tipo,
    required int cantidad,
    String? descripcion,
    required String usuarioId,
  }) async {
    try {
      final movimiento = await _repository.registrarMovimiento(
        productoId: productoId,
        tipo: tipo,
        cantidad: cantidad,
        descripcion: descripcion,
        usuarioId: usuarioId,
      );
      return (null, movimiento);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}
