import '../../../shared/src/domain/entities/cliente.dart';
import '../../../shared/src/domain/repositories/icliente_repository.dart';
import '../datasources/cliente_datasource.dart';
import '../models/cliente_dto.dart';

class ClienteRepositoryImpl implements IClienteRepository {
  final ClienteDatasource datasource;

  ClienteRepositoryImpl(this.datasource);

  @override
  Future<List<Cliente>> obtenerTodos() async {
    final dtos = await datasource.obtenerTodos();
    return dtos.map((dto) => _toDomain(dto)).toList();
  }

  @override
  Future<Cliente?> obtenerPorId(String id) async {
    final dto = await datasource.obtenerPorId(id);
    return dto != null ? _toDomain(dto) : null;
  }

  @override
  Future<Cliente?> obtenerPorEmail(String email) async {
    final dto = await datasource.obtenerPorEmail(email);
    return dto != null ? _toDomain(dto) : null;
  }

  @override
  Future<Cliente?> obtenerPorRfc(String rfc) async {
    final dto = await datasource.obtenerPorRfc(rfc);
    return dto != null ? _toDomain(dto) : null;
  }

  @override
  Future<Cliente> crear(Cliente cliente) async {
    final dto = _toDto(cliente);
    final creado = await datasource.crear(dto);
    return _toDomain(creado);
  }

  @override
  Future<Cliente> actualizar(Cliente cliente) async {
    final dto = _toDto(cliente);
    final actualizado = await datasource.actualizar(dto);
    return _toDomain(actualizado);
  }

  @override
  Future<void> eliminar(String id) async {
    await datasource.eliminar(id);
  }

  Cliente _toDomain(ClienteDto dto) {
    return Cliente(
      id: dto.id,
      nombre: dto.nombre,
      email: dto.email,
      telefono: dto.telefono,
      rfc: dto.rfc,
      direccion: dto.direccion,
      notas: dto.notas,
      activo: dto.activo,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  ClienteDto _toDto(Cliente cliente) {
    return ClienteDto(
      id: cliente.id,
      nombre: cliente.nombre,
      email: cliente.email,
      telefono: cliente.telefono,
      rfc: cliente.rfc,
      direccion: cliente.direccion,
      notas: cliente.notas,
      activo: cliente.activo,
      createdAt: cliente.createdAt,
      updatedAt: cliente.updatedAt,
    );
  }
}
