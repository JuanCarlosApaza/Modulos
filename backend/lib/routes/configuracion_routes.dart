import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:postgres/postgres.dart';

import '../src/database.dart';

final configuracionRoutes = Router()
  ..get('/', _obtenerTodas)
  ..get('/<id>', _obtenerPorId)
  ..get('/clave/<clave>', _obtenerPorClave)
  ..post('/', _crear)
  ..put('/<id>', _actualizar)
  ..delete('/<id>', _eliminar);

Future<Response> _obtenerTodas(Request request) async {
  final result = await db.execute('''
    SELECT id, clave, valor, descripcion, tipo, activo
    FROM configuracion WHERE activo = true ORDER BY clave ASC
  ''');

  final configuraciones = result.map((row) => {
    'id': row[0].toString(),
    'clave': row[1],
    'valor': row[2],
    'descripcion': row[3],
    'tipo': row[4],
    'activo': row[5],
  }).toList();

  return Response.ok(jsonEncode(configuraciones), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorId(Request request) async {
  final id = request.params['id'];
  final result = await db.execute(
    Sql.named('SELECT * FROM configuracion WHERE id = @id'),
    parameters: {'id': id},
  );

  if (result.isEmpty) return Response.notFound('Configuración no encontrada');

  final row = result.first;
  final config = {
    'id': row[0].toString(),
    'clave': row[1],
    'valor': row[2],
    'descripcion': row[3],
    'tipo': row[4],
    'activo': row[5],
  };

  return Response.ok(jsonEncode(config), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorClave(Request request) async {
  final clave = request.params['clave'];
  final result = await db.execute(
    Sql.named('SELECT * FROM configuracion WHERE clave = @clave'),
    parameters: {'clave': clave},
  );

  if (result.isEmpty) return Response.notFound('Configuración no encontrada');

  final row = result.first;
  final config = {
    'id': row[0].toString(),
    'clave': row[1],
    'valor': row[2],
    'descripcion': row[3],
    'tipo': row[4],
    'activo': row[5],
  };

  return Response.ok(jsonEncode(config), headers: {'Content-Type': 'application/json'});
}

Future<Response> _crear(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      INSERT INTO configuracion (id, clave, valor, descripcion, tipo)
      VALUES (@id, @clave, @valor, @descripcion, @tipo)
    '''),
    parameters: {
      'id': data['id'],
      'clave': data['clave'],
      'valor': data['valor'],
      'descripcion': data['descripcion'],
      'tipo': data['tipo'] ?? 'texto',
    },
  );

  return Response.ok(jsonEncode({'message': 'Configuración creada'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _actualizar(Request request) async {
  final id = request.params['id'];
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      UPDATE configuracion SET valor = @valor, descripcion = @descripcion, tipo = @tipo
      WHERE id = @id
    '''),
    parameters: {
      'id': id,
      'valor': data['valor'],
      'descripcion': data['descripcion'],
      'tipo': data['tipo'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Configuración actualizada'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _eliminar(Request request) async {
  final id = request.params['id'];

  await db.execute(
    Sql.named('UPDATE configuracion SET activo = false WHERE id = @id'),
    parameters: {'id': id},
  );

  return Response.ok(jsonEncode({'message': 'Configuración eliminada'}), headers: {'Content-Type': 'application/json'});
}
