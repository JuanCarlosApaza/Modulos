import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/producto_dto.dart' as dto;

class ProductoDatasourceImpl {
  static const String _baseUrl = 'http://localhost:8080/api/productos';

  Future<List<dto.ProductoDto>> obtenerTodos() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => dto.ProductoDto.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  Future<dto.ProductoDto?> obtenerPorId(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return dto.ProductoDto.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener producto');
    }
  }

  Future<dto.ProductoDto> crear(dto.ProductoDto producto) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': producto.id,
        'nombre': producto.nombre,
        'descripcion': producto.descripcion,
        'sku': producto.sku,
        'precio_compra': producto.precioCompra,
        'precio_venta': producto.precioVenta,
        'unidad_medida': producto.unidadMedida,
        'categoria_id': producto.categoriaId,
        'stock_actual': producto.stockActual,
        'stock_minimo': producto.stockMinimo,
      }),
    );

    if (response.statusCode == 200) {
      return producto;
    } else {
      throw Exception('Error al crear producto');
    }
  }

  Future<void> actualizar(dto.ProductoDto producto) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${producto.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': producto.nombre,
        'descripcion': producto.descripcion,
        'sku': producto.sku,
        'precio_compra': producto.precioCompra,
        'precio_venta': producto.precioVenta,
        'unidad_medida': producto.unidadMedida,
        'categoria_id': producto.categoriaId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto');
    }
  }

  Future<void> eliminar(String id) async {
    await http.delete(Uri.parse('$_baseUrl/$id'));
  }
}
