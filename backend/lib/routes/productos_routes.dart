import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:postgres/postgres.dart';

import '../src/database.dart';

/// Convierte cualquier tipo retornado por la DB a double de forma segura.
/// Compatible con PostgreSQL (numeric → String), MySQL (DECIMAL → double), SQLite (dinámico).
double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// Convierte cualquier tipo retornado por la DB a int de forma segura.
int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

final productosRoutes = Router()
  ..get('/', _obtenerTodos)
  ..get('/<id>', _obtenerPorId)
  ..post('/', _crear)
  ..put('/<id>', _actualizar)
  ..delete('/<id>', _eliminar);

Future<Response> _obtenerTodos(Request request) async {
  final result = await db.execute('''
    SELECT p.id, p.nombre, p.descripcion, p.sku, p.precio_compra, p.precio_venta,
           p.unidad_medida, p.categoria_id, p.stock_actual, p.stock_minimo, p.activo
    FROM productos p WHERE p.activo = true ORDER BY p.created_at DESC
  ''');

  final productos = result.map((row) => {
    'id': row[0].toString(),
    'nombre': row[1],
    'descripcion': row[2],
    'sku': row[3],
    'precio_compra': _toDouble(row[4]),
    'precio_venta': _toDouble(row[5]),
    'unidad_medida': row[6],
    'categoria_id': row[7],
    'stock_actual': _toInt(row[8]),
    'stock_minimo': _toInt(row[9]),
    'activo': row[10],
  }).toList();

  return Response.ok(jsonEncode(productos), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorId(Request request) async {
  final id = request.params['id'];
  final result = await db.execute(
    Sql.named('SELECT * FROM productos WHERE id = @id'),
    parameters: {'id': id},
  );

  if (result.isEmpty) return Response.notFound('Producto no encontrado');

  final row = result.first;
  final producto = {
    'id': row[0].toString(),
    'nombre': row[1],
    'descripcion': row[2],
    'sku': row[3],
    'precio_venta': row[5],
    'stock_actual': row[8],
  };

  return Response.ok(jsonEncode(producto), headers: {'Content-Type': 'application/json'});
}

Future<Response> _crear(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      INSERT INTO productos (id, nombre, descripcion, sku, precio_compra, precio_venta, unidad_medida, categoria_id, stock_actual, stock_minimo)
      VALUES (@id, @nombre, @descripcion, @sku, @precio_compra, @precio_venta, @unidad_medida, @categoria_id, @stock_actual, @stock_minimo)
    '''),
    parameters: {
      'id': data['id'],
      'nombre': data['nombre'],
      'descripcion': data['descripcion'],
      'sku': data['sku'],
      'precio_compra': data['precio_compra'],
      'precio_venta': data['precio_venta'],
      'unidad_medida': data['unidad_medida'],
      'categoria_id': data['categoria_id'],
      'stock_actual': data['stock_actual'],
      'stock_minimo': data['stock_minimo'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Producto creado'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _actualizar(Request request) async {
  final id = request.params['id'];
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      UPDATE productos SET nombre = @nombre, descripcion = @descripcion, sku = @sku,
             precio_venta = @precio_venta, stock_actual = @stock_actual
      WHERE id = @id
    '''),
    parameters: {
      'id': id,
      'nombre': data['nombre'],
      'descripcion': data['descripcion'],
      'sku': data['sku'],
      'precio_venta': data['precio_venta'],
      'stock_actual': data['stock_actual'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Producto actualizado'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _eliminar(Request request) async {
  final id = request.params['id'];

  await db.execute(
    Sql.named('UPDATE productos SET activo = false WHERE id = @id'),
    parameters: {'id': id},
  );

  return Response.ok(jsonEncode({'message': 'Producto eliminado'}), headers: {'Content-Type': 'application/json'});
}
