import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/venta_dto.dart' as dto;

class VentaDatasourceImpl {
  static const String _baseUrl = 'http://localhost:8080/api/ventas';

  Future<List<dto.VentaDto>> obtenerTodos() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.VentaDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener ventas');
    }
  }

  Future<dto.VentaDto?> obtenerPorId(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return dto.VentaDto.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener venta');
    }
  }

  Future<dto.VentaDto> crear(dto.VentaDto venta) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': venta.id,
        'cliente_id': venta.clienteId,
        'usuario_id': venta.usuarioId,
        'subtotal': venta.subtotal,
        'descuento': venta.descuento,
        'total': venta.total,
        'metodo_pago': venta.metodoPago,
        'estado': venta.estado,
        'notas': venta.notas,
      }),
    );

    if (response.statusCode == 200) {
      return venta;
    } else {
      throw Exception('Error al crear venta');
    }
  }

  Future<void> eliminar(String id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
  }
}
