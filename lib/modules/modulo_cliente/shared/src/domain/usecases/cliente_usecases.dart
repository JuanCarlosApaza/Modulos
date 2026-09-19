import '../entities/cliente.dart';
import '../failures/failure.dart';
import '../repositories/icliente_repository.dart';

class ObtenerClientesUseCase {
  final IClienteRepository repository;

  ObtenerClientesUseCase(this.repository);

  Future<(Failure?, List<Cliente>?)> execute() async {
    try {
      final clientes = await repository.obtenerTodos();
      return (null, clientes);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class ObtenerClientePorIdUseCase {
  final IClienteRepository repository;

  ObtenerClientePorIdUseCase(this.repository);

  Future<(Failure?, Cliente?)> execute(String id) async {
    try {
      final cliente = await repository.obtenerPorId(id);
      if (cliente == null) {
        return (const NotFoundFailure(message: 'Cliente no encontrado'), null);
      }
      return (null, cliente);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}

class CrearClienteUseCase {
  final IClienteRepository repository;

  CrearClienteUseCase(this.repository);

  Future<(Failure?, Cliente?)> execute(Cliente cliente) async {
    try {
      if (cliente.email != null) {
        final existente = await repository.obtenerPorEmail(cliente.email!);
        if (existente != null) {
          return (const ValidationFailure(message: 'El email ya está registrado'), null);
        }
      }
      final nuevo = await repository.crear(cliente);
      return (null, nuevo);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}
