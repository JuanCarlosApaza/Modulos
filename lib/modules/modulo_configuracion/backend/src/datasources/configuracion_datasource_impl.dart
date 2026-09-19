import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/configuracion_dto.dart' as dto;

class ConfiguracionDatasourceImpl {
  static const String _baseUrl = 'http://localhost:8080/api/configuracion';

  Future<List<dto.ConfiguracionDto>> obtenerTodas() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.ConfiguracionDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener configuraciones');
    }
  }

  Future<dto.ConfiguracionDto> crear(dto.ConfiguracionDto configuracion) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'clave': configuracion.clave,
        'valor': configuracion.valor,
        'descripcion': configuracion.descripcion,
        'categoria': configuracion.categoria,
      }),
    );

    if (response.statusCode == 200) {
      return configuracion;
    } else {
      throw Exception('Error al crear configuración');
    }
  }

  Future<void> actualizar(dto.ConfiguracionDto configuracion) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${configuracion.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'clave': configuracion.clave,
        'valor': configuracion.valor,
        'descripcion': configuracion.descripcion,
        'categoria': configuracion.categoria,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar configuración');
    }
  }

  Future<void> eliminar(String id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
  }
}
