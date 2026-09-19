import '../entities/producto.dart';
import '../failures/failure.dart';
import '../repositories/iproducto_repository.dart';

class ObtenerProductosUseCase {
  final IProductoRepository repository;

  ObtenerProductosUseCase(this.repository);

  Future<(Failure?, List<Producto>?)> execute() async {
    try {
      final productos = await repository.obtenerTodos();
      return (null, productos);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerProductoPorIdUseCase {
  final IProductoRepository repository;

  ObtenerProductoPorIdUseCase(this.repository);

  Future<(Failure?, Producto?)> execute(String id) async {
    try {
      final producto = await repository.obtenerPorId(id);
      if (producto == null) {
        return (const NotFoundFailure(message: 'Producto no encontrado'), null);
      }
      return (null, producto);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class CrearProductoUseCase {
  final IProductoRepository repository;

  CrearProductoUseCase(this.repository);

  Future<(Failure?, Producto?)> execute(Producto producto) async {
    try {
      if (producto.nombre.isEmpty) {
        return (const ValidationFailure(message: 'El nombre del producto es requerido'), null);
      }
      if (producto.precioVenta <= 0) {
        return (const ValidationFailure(message: 'El precio de venta debe ser mayor a 0'), null);
      }
      final nuevo = await repository.crear(producto);
      return (null, nuevo);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ActualizarProductoUseCase {
  final IProductoRepository repository;

  ActualizarProductoUseCase(this.repository);

  Future<(Failure?, bool?)> execute(Producto producto) async {
    try {
      final existente = await repository.obtenerPorId(producto.id);
      if (existente == null) {
        return (const NotFoundFailure(message: 'Producto no encontrado'), null);
      }
      await repository.actualizar(producto);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class EliminarProductoUseCase {
  final IProductoRepository repository;

  EliminarProductoUseCase(this.repository);

  Future<(Failure?, bool?)> execute(String id) async {
    try {
      final existente = await repository.obtenerPorId(id);
      if (existente == null) {
        return (const NotFoundFailure(message: 'Producto no encontrado'), null);
      }
      await repository.eliminar(id);
      return (null, null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}
