import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:postgres/postgres.dart';

import '../src/database.dart';

final inventarioRoutes = Router()
  ..get('/', _obtenerTodos)
  ..get('/<id>', _obtenerPorId)
  ..get('/producto/<productoId>', _obtenerPorProducto)
  ..get('/stock-bajo', _obtenerStockBajo)
  ..get('/movimientos', _obtenerTodosLosMovimientos)
  ..get('/movimientos/<productoId>', _obtenerMovimientos)
  ..put('/<id>', _actualizarStock)
  ..post('/movimientos', _registrarMovimiento);

Future<Response> _obtenerTodos(Request request) async {
  final result = await db.execute('''
    SELECT i.id, i.producto_id, i.stock_actual, i.stock_minimo, i.stock_maximo, i.ubicacion, i.activo,
           p.nombre as producto_nombre
    FROM inventario i
    JOIN productos p ON i.producto_id = p.id
    WHERE i.activo = true ORDER BY i.stock_actual ASC
  ''');

  final items = result.map((row) => {
    'id': row[0].toString(),
    'producto_id': row[1].toString(),
    'stock_actual': row[2],
    'stock_minimo': row[3],
    'stock_maximo': row[4],
    'ubicacion': row[5],
    'activo': row[6],
    'producto_nombre': row[7],
  }).toList();

  return Response.ok(jsonEncode(items), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorId(Request request) async {
  final id = request.params['id'];
  final result = await db.execute(
    Sql.named('SELECT * FROM inventario WHERE id = @id'),
    parameters: {'id': id},
  );

  if (result.isEmpty) return Response.notFound('Item no encontrado');

  final row = result.first;
  final item = {
    'id': row[0].toString(),
    'producto_id': row[1].toString(),
    'stock_actual': row[2],
    'stock_minimo': row[3],
    'stock_maximo': row[4],
    'ubicacion': row[5],
  };

  return Response.ok(jsonEncode(item), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorProducto(Request request) async {
  final productoId = request.params['productoId'];
  final result = await db.execute(
    Sql.named('SELECT * FROM inventario WHERE producto_id = @productoId'),
    parameters: {'productoId': productoId},
  );

  if (result.isEmpty) return Response.notFound('Producto no encontrado en inventario');

  final row = result.first;
  final item = {
    'id': row[0].toString(),
    'producto_id': row[1].toString(),
    'stock_actual': row[2],
    'stock_minimo': row[3],
    'stock_maximo': row[4],
    'ubicacion': row[5],
  };

  return Response.ok(jsonEncode(item), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerStockBajo(Request request) async {
  final result = await db.execute('''
    SELECT i.id, i.producto_id, i.stock_actual, i.stock_minimo, i.stock_maximo, i.ubicacion,
           p.nombre as producto_nombre
    FROM inventario i
    JOIN productos p ON i.producto_id = p.id
    WHERE i.activo = true AND i.stock_actual <= i.stock_minimo
    ORDER BY i.stock_actual ASC
  ''');

  final items = result.map((row) => {
    'id': row[0].toString(),
    'producto_id': row[1].toString(),
    'stock_actual': row[2],
    'stock_minimo': row[3],
    'stock_maximo': row[4],
    'ubicacion': row[5],
    'producto_nombre': row[6],
  }).toList();

  return Response.ok(jsonEncode(items), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerTodosLosMovimientos(Request request) async {
  final result = await db.execute('''
    SELECT m.id, m.producto_id, m.tipo, m.cantidad, m.motivo, m.referencia, m.created_at,
           p.nombre as producto_nombre
    FROM movimientos_inventario m
    JOIN productos p ON m.producto_id = p.id
    ORDER BY m.created_at DESC
    LIMIT 100
  ''');

  final movimientos = result.map((row) => {
    'id': row[0].toString(),
    'producto_id': row[1].toString(),
    'tipo': row[2],
    'cantidad': row[3],
    'motivo': row[4],
    'referencia': row[5],
    'created_at': row[6].toString(),
    'producto_nombre': row[7],
  }).toList();

  return Response.ok(jsonEncode(movimientos), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerMovimientos(Request request) async {
  final productoId = request.params['productoId'];
  final result = await db.execute(
    Sql.named('SELECT * FROM movimientos_inventario WHERE producto_id = @productoId ORDER BY created_at DESC'),
    parameters: {'productoId': productoId},
  );

  final movimientos = result.map((row) => {
    'id': row[0].toString(),
    'producto_id': row[1].toString(),
    'tipo': row[2],
    'cantidad': row[3],
    'motivo': row[4],
    'referencia': row[5],
    'created_at': row[6].toString(),
  }).toList();

  return Response.ok(jsonEncode(movimientos), headers: {'Content-Type': 'application/json'});
}

Future<Response> _actualizarStock(Request request) async {
  final id = request.params['id'];
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      UPDATE inventario SET stock_actual = @stock_actual, stock_minimo = @stock_minimo, 
             stock_maximo = @stock_maximo, ubicacion = @ubicacion
      WHERE id = @id
    '''),
    parameters: {
      'id': id,
      'stock_actual': data['stock_actual'],
      'stock_minimo': data['stock_minimo'],
      'stock_maximo': data['stock_maximo'],
      'ubicacion': data['ubicacion'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Stock actualizado'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _registrarMovimiento(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      INSERT INTO movimientos_inventario (id, producto_id, tipo, cantidad, motivo, referencia)
      VALUES (@id, @producto_id, @tipo, @cantidad, @motivo, @referencia)
    '''),
    parameters: {
      'id': data['id'],
      'producto_id': data['producto_id'],
      'tipo': data['tipo'],
      'cantidad': data['cantidad'],
      'motivo': data['motivo'],
      'referencia': data['referencia'],
    },
  );

  if (data['tipo'] == 'entrada') {
    await db.execute(
      Sql.named('UPDATE inventario SET stock_actual = stock_actual + @cantidad WHERE producto_id = @productoId'),
      parameters: {'cantidad': data['cantidad'], 'productoId': data['producto_id']},
    );
  } else if (data['tipo'] == 'salida') {
    await db.execute(
      Sql.named('UPDATE inventario SET stock_actual = stock_actual - @cantidad WHERE producto_id = @productoId'),
      parameters: {'cantidad': data['cantidad'], 'productoId': data['producto_id']},
    );
  }

  return Response.ok(jsonEncode({'message': 'Movimiento registrado'}), headers: {'Content-Type': 'application/json'});
}
