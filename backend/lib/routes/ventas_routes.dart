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

final ventasRoutes = Router()
  ..get('/', _obtenerTodos)
  ..get('/<id>', _obtenerPorId)
  ..post('/', _crear)
  ..put('/<id>', _actualizar)
  ..delete('/<id>', _eliminar);

Future<Response> _obtenerTodos(Request request) async {
  final result = await db.execute('''
    SELECT v.id, v.cliente_id, v.usuario_id, v.folio, v.subtotal, v.descuento,
           v.total, v.metodo_pago, v.estado, v.notas, v.created_at
    FROM ventas v ORDER BY v.created_at DESC
  ''');

  final ventas = result.map((row) => {
    'id': row[0].toString(),
    'cliente_id': row[1],
    'usuario_id': row[2],
    'folio': row[3],
    'subtotal': _toDouble(row[4]),
    'descuento': _toDouble(row[5]),
    'total': _toDouble(row[6]),
    'metodo_pago': row[7],
    'estado': row[8],
    'notas': row[9],
    'created_at': row[10].toString(),
  }).toList();

  return Response.ok(jsonEncode(ventas), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorId(Request request) async {
  final id = request.params['id'];
  final result = await db.execute(
    Sql.named('SELECT * FROM ventas WHERE id = @id'),
    parameters: {'id': id},
  );

  if (result.isEmpty) return Response.notFound('Venta no encontrada');

  final row = result.first;
  final venta = {
    'id': row[0].toString(),
    'cliente_id': row[1],
    'usuario_id': row[2],
    'folio': row[3],
    'total': row[6],
    'estado': row[8],
  };

  return Response.ok(jsonEncode(venta), headers: {'Content-Type': 'application/json'});
}

Future<Response> _crear(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      INSERT INTO ventas (id, cliente_id, usuario_id, subtotal, descuento, total, metodo_pago, estado, notas)
      VALUES (@id, @cliente_id, @usuario_id, @subtotal, @descuento, @total, @metodo_pago, @estado, @notas)
    '''),
    parameters: {
      'id': data['id'],
      'cliente_id': data['cliente_id'],
      'usuario_id': data['usuario_id'],
      'subtotal': data['subtotal'],
      'descuento': data['descuento'],
      'total': data['total'],
      'metodo_pago': data['metodo_pago'],
      'estado': data['estado'],
      'notas': data['notas'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Venta creada'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _actualizar(Request request) async {
  final id = request.params['id'];
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      UPDATE ventas SET estado = @estado, notas = @notas WHERE id = @id
    '''),
    parameters: {
      'id': id,
      'estado': data['estado'],
      'notas': data['notas'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Venta actualizada'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _eliminar(Request request) async {
  final id = request.params['id'];

  await db.execute(
    Sql.named("UPDATE ventas SET estado = 'cancelada' WHERE id = @id"),
    parameters: {'id': id},
  );

  return Response.ok(jsonEncode({'message': 'Venta cancelada'}), headers: {'Content-Type': 'application/json'});
}
