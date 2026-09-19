import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:postgres/postgres.dart';

import '../src/database.dart';

final notificacionesRoutes = Router()
  ..get('/', _obtenerTodas)
  ..get('/<id>', _obtenerPorId)
  ..get('/usuario/<usuarioId>', _obtenerPorUsuario)
  ..get('/no-leidas', _obtenerNoLeidas)
  ..get('/no-leidas/<usuarioId>', _obtenerNoLeidasPorUsuario)
  ..post('/', _crear)
  ..put('/<id>/leer', _marcarComoLeida)
  ..put('/leer-todas', _marcarTodasComoLeidas)
  ..delete('/<id>', _eliminar);

Future<Response> _obtenerTodas(Request request) async {
  final result = await db.execute('''
    SELECT id, titulo, mensaje, tipo, usuario_id, leida, accion_url, created_at
    FROM notificaciones ORDER BY created_at DESC LIMIT 100
  ''');

  final notificaciones = result.map((row) => {
    'id': row[0].toString(),
    'titulo': row[1],
    'mensaje': row[2],
    'tipo': row[3],
    'usuario_id': row[4]?.toString(),
    'leida': row[5],
    'accion_url': row[6],
    'created_at': row[7].toString(),
  }).toList();

  return Response.ok(jsonEncode(notificaciones), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorId(Request request) async {
  final id = request.params['id'];
  final result = await db.execute(
    Sql.named('SELECT * FROM notificaciones WHERE id = @id'),
    parameters: {'id': id},
  );

  if (result.isEmpty) return Response.notFound('Notificación no encontrada');

  final row = result.first;
  final notificacion = {
    'id': row[0].toString(),
    'titulo': row[1],
    'mensaje': row[2],
    'tipo': row[3],
    'usuario_id': row[4]?.toString(),
    'leida': row[5],
    'accion_url': row[6],
    'created_at': row[7].toString(),
  };

  return Response.ok(jsonEncode(notificacion), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorUsuario(Request request) async {
  final usuarioId = request.params['usuarioId'];
  final result = await db.execute(
    Sql.named('SELECT * FROM notificaciones WHERE usuario_id = @usuarioId ORDER BY created_at DESC'),
    parameters: {'usuarioId': usuarioId},
  );

  final notificaciones = result.map((row) => {
    'id': row[0].toString(),
    'titulo': row[1],
    'mensaje': row[2],
    'tipo': row[3],
    'usuario_id': row[4]?.toString(),
    'leida': row[5],
    'accion_url': row[6],
    'created_at': row[7].toString(),
  }).toList();

  return Response.ok(jsonEncode(notificaciones), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerNoLeidas(Request request) async {
  final result = await db.execute('''
    SELECT * FROM notificaciones WHERE leida = false ORDER BY created_at DESC
  ''');

  final notificaciones = result.map((row) => {
    'id': row[0].toString(),
    'titulo': row[1],
    'mensaje': row[2],
    'tipo': row[3],
    'usuario_id': row[4]?.toString(),
    'leida': row[5],
    'accion_url': row[6],
    'created_at': row[7].toString(),
  }).toList();

  return Response.ok(jsonEncode(notificaciones), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerNoLeidasPorUsuario(Request request) async {
  final usuarioId = request.params['usuarioId'];
  final result = await db.execute(
    Sql.named('SELECT * FROM notificaciones WHERE usuario_id = @usuarioId AND leida = false ORDER BY created_at DESC'),
    parameters: {'usuarioId': usuarioId},
  );

  final notificaciones = result.map((row) => {
    'id': row[0].toString(),
    'titulo': row[1],
    'mensaje': row[2],
    'tipo': row[3],
    'usuario_id': row[4]?.toString(),
    'leida': row[5],
    'accion_url': row[6],
    'created_at': row[7].toString(),
  }).toList();

  return Response.ok(jsonEncode(notificaciones), headers: {'Content-Type': 'application/json'});
}

Future<Response> _crear(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      INSERT INTO notificaciones (id, titulo, mensaje, tipo, usuario_id, leida, accion_url)
      VALUES (@id, @titulo, @mensaje, @tipo, @usuario_id, @leida, @accion_url)
    '''),
    parameters: {
      'id': data['id'],
      'titulo': data['titulo'],
      'mensaje': data['mensaje'],
      'tipo': data['tipo'],
      'usuario_id': data['usuario_id'],
      'leida': data['leida'] ?? false,
      'accion_url': data['accion_url'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Notificación creada'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _marcarComoLeida(Request request) async {
  final id = request.params['id'];

  await db.execute(
    Sql.named('UPDATE notificaciones SET leida = true WHERE id = @id'),
    parameters: {'id': id},
  );

  return Response.ok(jsonEncode({'message': 'Notificación marcada como leída'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _marcarTodasComoLeidas(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);
  final usuarioId = data['usuario_id'];

  if (usuarioId != null) {
    await db.execute(
      Sql.named('UPDATE notificaciones SET leida = true WHERE usuario_id = @usuarioId'),
      parameters: {'usuarioId': usuarioId},
    );
  } else {
    await db.execute('UPDATE notificaciones SET leida = true');
  }

  return Response.ok(jsonEncode({'message': 'Todas marcadas como leídas'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _eliminar(Request request) async {
  final id = request.params['id'];

  await db.execute(
    Sql.named('DELETE FROM notificaciones WHERE id = @id'),
    parameters: {'id': id},
  );

  return Response.ok(jsonEncode({'message': 'Notificación eliminada'}), headers: {'Content-Type': 'application/json'});
}
