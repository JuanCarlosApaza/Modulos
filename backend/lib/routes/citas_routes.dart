import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:postgres/postgres.dart';

import '../src/database.dart';

final citasRoutes = Router()
  ..get('/', _obtenerTodos)
  ..get('/<id>', _obtenerPorId)
  ..get('/cliente/<clienteId>', _obtenerPorCliente)
  ..get('/usuario/<usuarioId>', _obtenerPorUsuario)
  ..get('/fecha/<fecha>', _obtenerPorFecha)
  ..post('/', _crear)
  ..put('/<id>', _actualizar)
  ..delete('/<id>', _eliminar);

Future<Response> _obtenerTodos(Request request) async {
  final result = await db.execute('''
    SELECT id, cliente_id, usuario_id, titulo, descripcion, 
           fecha_inicio, fecha_fin, estado, notas, activo
    FROM citas WHERE activo = true ORDER BY fecha_inicio DESC
  ''');

  final citas = result.map((row) => {
    'id': row[0].toString(),
    'cliente_id': row[1].toString(),
    'usuario_id': row[2].toString(),
    'titulo': row[3],
    'descripcion': row[4],
    'fecha_inicio': row[5].toString(),
    'fecha_fin': row[6].toString(),
    'estado': row[7],
    'notas': row[8],
    'activo': row[9],
  }).toList();

  return Response.ok(jsonEncode(citas), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorId(Request request) async {
  final id = request.params['id'];
  final result = await db.execute(
    Sql.named('SELECT * FROM citas WHERE id = @id'),
    parameters: {'id': id},
  );

  if (result.isEmpty) return Response.notFound('Cita no encontrada');

  final row = result.first;
  final cita = {
    'id': row[0].toString(),
    'cliente_id': row[1].toString(),
    'usuario_id': row[2].toString(),
    'titulo': row[3],
    'descripcion': row[4],
    'fecha_inicio': row[5].toString(),
    'fecha_fin': row[6].toString(),
    'estado': row[7],
    'notas': row[8],
  };

  return Response.ok(jsonEncode(cita), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorCliente(Request request) async {
  final clienteId = request.params['clienteId'];
  final result = await db.execute(
    Sql.named('SELECT * FROM citas WHERE cliente_id = @clienteId AND activo = true ORDER BY fecha_inicio DESC'),
    parameters: {'clienteId': clienteId},
  );

  final citas = result.map((row) => {
    'id': row[0].toString(),
    'cliente_id': row[1].toString(),
    'usuario_id': row[2].toString(),
    'titulo': row[3],
    'descripcion': row[4],
    'fecha_inicio': row[5].toString(),
    'fecha_fin': row[6].toString(),
    'estado': row[7],
    'notas': row[8],
  }).toList();

  return Response.ok(jsonEncode(citas), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorUsuario(Request request) async {
  final usuarioId = request.params['usuarioId'];
  final result = await db.execute(
    Sql.named('SELECT * FROM citas WHERE usuario_id = @usuarioId AND activo = true ORDER BY fecha_inicio DESC'),
    parameters: {'usuarioId': usuarioId},
  );

  final citas = result.map((row) => {
    'id': row[0].toString(),
    'cliente_id': row[1].toString(),
    'usuario_id': row[2].toString(),
    'titulo': row[3],
    'descripcion': row[4],
    'fecha_inicio': row[5].toString(),
    'fecha_fin': row[6].toString(),
    'estado': row[7],
    'notas': row[8],
  }).toList();

  return Response.ok(jsonEncode(citas), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorFecha(Request request) async {
  final fecha = request.params['fecha'];
  final result = await db.execute(
    Sql.named('''
      SELECT * FROM citas 
      WHERE DATE(fecha_inicio) = DATE(@fecha::timestamp) 
      AND activo = true 
      ORDER BY fecha_inicio ASC
    '''),
    parameters: {'fecha': fecha},
  );

  final citas = result.map((row) => {
    'id': row[0].toString(),
    'cliente_id': row[1].toString(),
    'usuario_id': row[2].toString(),
    'titulo': row[3],
    'descripcion': row[4],
    'fecha_inicio': row[5].toString(),
    'fecha_fin': row[6].toString(),
    'estado': row[7],
    'notas': row[8],
  }).toList();

  return Response.ok(jsonEncode(citas), headers: {'Content-Type': 'application/json'});
}

Future<Response> _crear(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      INSERT INTO citas (id, cliente_id, usuario_id, titulo, descripcion, fecha_inicio, fecha_fin, estado, notas)
      VALUES (@id, @cliente_id, @usuario_id, @titulo, @descripcion, @fecha_inicio, @fecha_fin, @estado, @notas)
    '''),
    parameters: {
      'id': data['id'],
      'cliente_id': data['cliente_id'],
      'usuario_id': data['usuario_id'],
      'titulo': data['titulo'],
      'descripcion': data['descripcion'],
      'fecha_inicio': data['fecha_inicio'],
      'fecha_fin': data['fecha_fin'],
      'estado': data['estado'] ?? 'pendiente',
      'notas': data['notas'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Cita creada'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _actualizar(Request request) async {
  final id = request.params['id'];
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      UPDATE citas SET titulo = @titulo, descripcion = @descripcion, 
             fecha_inicio = @fecha_inicio, fecha_fin = @fecha_fin, 
             estado = @estado, notas = @notas
      WHERE id = @id
    '''),
    parameters: {
      'id': id,
      'titulo': data['titulo'],
      'descripcion': data['descripcion'],
      'fecha_inicio': data['fecha_inicio'],
      'fecha_fin': data['fecha_fin'],
      'estado': data['estado'],
      'notas': data['notas'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Cita actualizada'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _eliminar(Request request) async {
  final id = request.params['id'];

  await db.execute(
    Sql.named('UPDATE citas SET activo = false WHERE id = @id'),
    parameters: {'id': id},
  );

  return Response.ok(jsonEncode({'message': 'Cita eliminada'}), headers: {'Content-Type': 'application/json'});
}
