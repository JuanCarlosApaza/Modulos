import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/notificacion_dto.dart' as dto;

class NotificacionDatasourceImpl {
  static const String _baseUrl = 'http://localhost:8080/api/notificaciones';

  Future<List<dto.NotificacionDto>> obtenerTodas() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.NotificacionDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener notificaciones');
    }
  }

  Future<List<dto.NotificacionDto>> obtenerNoLeidas() async {
    final response = await http.get(Uri.parse('$_baseUrl/no-leidas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.NotificacionDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener notificaciones no leídas');
    }
  }

  Future<dto.NotificacionDto> crear(dto.NotificacionDto notificacion) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'titulo': notificacion.titulo,
        'mensaje': notificacion.mensaje,
        'tipo': notificacion.tipo,
        'usuario_id': notificacion.usuarioId,
      }),
    );

    if (response.statusCode == 200) {
      return notificacion;
    } else {
      throw Exception('Error al crear notificación');
    }
  }

  Future<void> marcarComoLeida(String id) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id/leer'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al marcar notificación como leída');
    }
  }

  Future<void> marcarTodasComoLeidas() async {
    final response = await http.put(
      Uri.parse('$_baseUrl/leer-todas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al marcar todas como leídas');
    }
  }

  Future<void> eliminar(String id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
  }
}
