import '../../../shared/src/domain/entities/usuario.dart';
import '../../../shared/src/domain/repositories/i_usuario_repository.dart';
import '../datasources/usuario_datasource.dart';
import '../models/usuario_dto.dart';

class UsuarioRepositoryImpl implements IUsuarioRepository {
  final UsuarioDatasource _datasource;

  UsuarioRepositoryImpl(this._datasource);

  Usuario _mapFromDto(UsuarioDto dto) {
    return Usuario(
      id: dto.id,
      nombre: dto.nombre,
      email: dto.email,
      passwordHash: dto.passwordHash,
      telefono: dto.telefono,
      rolId: dto.rolId,
      activo: dto.activo,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  UsuarioDto _mapToDto(Usuario entity) {
    return UsuarioDto(
      id: entity.id,
      nombre: entity.nombre,
      email: entity.email,
      passwordHash: entity.passwordHash,
      telefono: entity.telefono,
      rolId: entity.rolId,
      activo: entity.activo,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Rol _mapRolFromMap(Map<String, String> map) {
    return Rol(id: map['id']!, nombre: map['nombre']!);
  }

  @override
  Future<List<Usuario>> obtenerTodos() async {
    final dtos = await _datasource.obtenerTodos();
    return dtos.map(_mapFromDto).toList();
  }

  @override
  Future<Usuario?> obtenerPorId(String id) async {
    final dto = await _datasource.obtenerPorId(id);
    return dto != null ? _mapFromDto(dto) : null;
  }

  @override
  Future<Usuario> crear(Usuario usuario) async {
    final dto = await _datasource.crear(_mapToDto(usuario));
    return _mapFromDto(dto);
  }

  @override
  Future<void> actualizar(Usuario usuario) async {
    await _datasource.actualizar(_mapToDto(usuario));
  }

  @override
  Future<void> eliminar(String id) async {
    await _datasource.eliminar(id);
  }

  @override
  Future<List<Rol>> obtenerRoles() async {
    final maps = await _datasource.obtenerRoles();
    return maps.map(_mapRolFromMap).toList();
  }
}
