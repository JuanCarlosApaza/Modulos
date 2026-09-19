import '../entities/venta.dart';
import '../failures/failure.dart';
import '../repositories/iventa_repository.dart';

class ObtenerVentasUseCase {
  final IVentaRepository repository;

  ObtenerVentasUseCase(this.repository);

  Future<(Failure?, List<Venta>?)> execute() async {
    try {
      final ventas = await repository.obtenerTodos();
      return (null, ventas);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerVentaPorIdUseCase {
  final IVentaRepository repository;

  ObtenerVentaPorIdUseCase(this.repository);

  Future<(Failure?, Venta?)> execute(String id) async {
    try {
      final venta = await repository.obtenerPorId(id);
      if (venta == null) {
        return (const NotFoundFailure(message: 'Venta no encontrada'), null);
      }
      return (null, venta);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class CrearVentaUseCase {
  final IVentaRepository repository;

  CrearVentaUseCase(this.repository);

  Future<(Failure?, Venta?)> execute(Venta venta) async {
    try {
      if (venta.total <= 0) {
        return (const ValidationFailure(message: 'El total de la venta debe ser mayor a 0'), null);
      }
      if (venta.usuarioId.isEmpty) {
        return (const ValidationFailure(message: 'El usuario es requerido'), null);
      }
      final nueva = await repository.crear(venta);
      return (null, nueva);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class EliminarVentaUseCase {
  final IVentaRepository repository;

  EliminarVentaUseCase(this.repository);

  Future<(Failure?, bool?)> execute(String id) async {
    try {
      final existente = await repository.obtenerPorId(id);
      if (existente == null) {
        return (const NotFoundFailure(message: 'Venta no encontrada'), null);
      }
      await repository.eliminar(id);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}
