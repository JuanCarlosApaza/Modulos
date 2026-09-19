import '../entities/cliente.dart';

abstract class IClienteRepository {
  Future<List<Cliente>> obtenerTodos();
  Future<Cliente?> obtenerPorId(String id);
  Future<Cliente?> obtenerPorEmail(String email);
  Future<Cliente?> obtenerPorRfc(String rfc);
  Future<Cliente> crear(Cliente cliente);
  Future<Cliente> actualizar(Cliente cliente);
  Future<void> eliminar(String id);
}
