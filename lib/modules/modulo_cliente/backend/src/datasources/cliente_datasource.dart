import '../models/cliente_dto.dart';

abstract class ClienteDatasource {
  Future<List<ClienteDto>> obtenerTodos();
  Future<ClienteDto?> obtenerPorId(String id);
  Future<ClienteDto?> obtenerPorEmail(String email);
  Future<ClienteDto?> obtenerPorRfc(String rfc);
  Future<ClienteDto> crear(ClienteDto cliente);
  Future<ClienteDto> actualizar(ClienteDto cliente);
  Future<void> eliminar(String id);
}
