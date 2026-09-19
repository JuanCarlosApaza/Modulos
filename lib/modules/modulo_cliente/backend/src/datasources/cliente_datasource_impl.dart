import 'dart:convert';
import 'package:http/http.dart' as http;

import 'cliente_datasource.dart';
import '../models/cliente_dto.dart';

class ClienteDatasourceImpl implements ClienteDatasource {
  static const String _baseUrl = 'http://localhost:8080/api/clientes';

  @override
  Future<List<ClienteDto>> obtenerTodos() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ClienteDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener clientes');
    }
  }

  @override
  Future<ClienteDto?> obtenerPorId(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return ClienteDto.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener cliente');
    }
  }

  @override
  Future<ClienteDto?> obtenerPorEmail(String email) async {
    final response = await http.get(Uri.parse('$_baseUrl?email=$email'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) return null;
      return ClienteDto.fromJson(data.first);
    } else {
      throw Exception('Error al buscar cliente por email');
    }
  }

  @override
  Future<ClienteDto?> obtenerPorRfc(String rfc) async {
    final response = await http.get(Uri.parse('$_baseUrl?rfc=$rfc'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) return null;
      return ClienteDto.fromJson(data.first);
    } else {
      throw Exception('Error al buscar cliente por RFC');
    }
  }

  @override
  Future<ClienteDto> crear(ClienteDto cliente) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': cliente.nombre,
        'email': cliente.email,
        'telefono': cliente.telefono,
        'rfc': cliente.rfc,
        'direccion': cliente.direccion,
        'notas': cliente.notas,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ClienteDto.fromJson(data);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Error al crear cliente');
    }
  }

  @override
  Future<ClienteDto> actualizar(ClienteDto cliente) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${cliente.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': cliente.nombre,
        'email': cliente.email,
        'telefono': cliente.telefono,
        'rfc': cliente.rfc,
        'direccion': cliente.direccion,
        'notas': cliente.notas,
      }),
    );

    if (response.statusCode == 200) {
      return cliente;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Error al actualizar cliente');
    }
  }

  @override
  Future<void> eliminar(String id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
  }
}
