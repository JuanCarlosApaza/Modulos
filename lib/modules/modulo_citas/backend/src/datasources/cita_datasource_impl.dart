import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cita_dto.dart' as dto;

class CitaDatasourceImpl {
  static const String _baseUrl = 'http://localhost:8080/api/citas';

  Future<List<dto.CitaDto>> obtenerTodos() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.CitaDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener citas');
    }
  }

  Future<dto.CitaDto?> obtenerPorId(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return dto.CitaDto.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener cita');
    }
  }

  Future<List<dto.CitaDto>> obtenerPorCliente(String clienteId) async {
    final response = await http.get(Uri.parse('$_baseUrl/cliente/$clienteId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.CitaDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener citas del cliente');
    }
  }

  Future<List<dto.CitaDto>> obtenerPorFecha(DateTime fecha) async {
    final fechaStr = fecha.toIso8601String().split('T')[0];
    final response = await http.get(Uri.parse('$_baseUrl/fecha/$fechaStr'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.CitaDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener citas por fecha');
    }
  }

  Future<dto.CitaDto> crear(dto.CitaDto cita) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': cita.id,
        'cliente_id': cita.clienteId,
        'usuario_id': cita.usuarioId,
        'titulo': cita.titulo,
        'descripcion': cita.descripcion,
        'fecha_inicio': cita.fechaInicio.toIso8601String(),
        'fecha_fin': cita.fechaFin.toIso8601String(),
        'estado': cita.estado,
        'notas': cita.notas,
      }),
    );

    if (response.statusCode == 200) {
      return cita;
    } else {
      throw Exception('Error al crear cita');
    }
  }

  Future<void> actualizar(dto.CitaDto cita) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${cita.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'titulo': cita.titulo,
        'descripcion': cita.descripcion,
        'fecha_inicio': cita.fechaInicio.toIso8601String(),
        'fecha_fin': cita.fechaFin.toIso8601String(),
        'estado': cita.estado,
        'notas': cita.notas,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar cita');
    }
  }

  Future<void> eliminar(String id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
  }
}
