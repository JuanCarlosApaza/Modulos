import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/usuario_dto.dart' as dto;

class UsuarioDatasourceImpl {
  static const String _baseUrl = 'http://localhost:8080/api/usuarios';

  Future<List<dto.UsuarioDto>> obtenerTodos() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.UsuarioDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  Future<dto.UsuarioDto?> obtenerPorId(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return dto.UsuarioDto.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener usuario');
    }
  }

  Future<dto.UsuarioDto> crear(dto.UsuarioDto usuario) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': usuario.id,
        'nombre': usuario.nombre,
        'email': usuario.email,
        'password_hash': usuario.passwordHash,
        'telefono': usuario.telefono,
        'rol_id': usuario.rolId,
      }),
    );

    if (response.statusCode == 200) {
      return usuario;
    } else {
      throw Exception('Error al crear usuario');
    }
  }

  Future<void> actualizar(dto.UsuarioDto usuario) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${usuario.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': usuario.id,
        'nombre': usuario.nombre,
        'email': usuario.email,
        'password_hash': usuario.passwordHash,
        'telefono': usuario.telefono,
        'rol_id': usuario.rolId,
        'activo': usuario.activo,
      }),
    );
    if (response.statusCode != 200) throw Exception('Error al actualizar usuario');
  }

  Future<List<Map<String, String>>> obtenerRoles() async {
    final response = await http.get(Uri.parse('$_baseUrl/roles'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => {'id': json['id'] as String, 'nombre': json['nombre'] as String}).toList();
    } else {
      throw Exception('Error al obtener roles');
    }
  }

  Future<void> eliminar(String id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
  }
}
