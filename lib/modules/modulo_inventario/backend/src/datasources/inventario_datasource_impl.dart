import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/inventario_dto.dart' as dto;

class InventarioDatasourceImpl {
  static const String _baseUrl = 'http://localhost:8080/api/inventario';

  Future<List<dto.InventarioDto>> obtenerTodos() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.InventarioDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener inventario');
    }
  }

  Future<List<dto.InventarioDto>> obtenerStockBajo() async {
    final response = await http.get(Uri.parse('$_baseUrl/stock-bajo'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.InventarioDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener stock bajo');
    }
  }

  Future<List<dto.MovimientoInventarioDto>> obtenerMovimientos(
      String productoId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/$productoId/movimientos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => dto.MovimientoInventarioDto.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al obtener movimientos');
    }
  }

  Future<void> actualizar(dto.InventarioDto item) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'stock_minimo': item.stockMinimo,
        'stock_maximo': item.stockMaximo,
        'ubicacion': item.ubicacion,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al actualizar inventario');
    }
  }

  Future<void> eliminar(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar inventario');
    }
  }

  Future<List<dto.MovimientoInventarioDto>> obtenerTodosMovimientos() async {
    final response = await http.get(Uri.parse('$_baseUrl/movimientos'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.MovimientoInventarioDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener movimientos');
    }
  }

  Future<dto.MovimientoInventarioDto> registrarMovimiento({
    required String productoId,
    required String tipo,
    required int cantidad,
    String? descripcion,
    required String usuarioId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/movimientos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'producto_id': productoId,
        'tipo': tipo,
        'cantidad': cantidad,
        'descripcion': descripcion,
        'usuario_id': usuarioId,
      }),
    );

    if (response.statusCode == 200) {
      return dto.MovimientoInventarioDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar movimiento');
    }
  }
}
