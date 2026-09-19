import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:postgres/postgres.dart';

import '../src/database.dart';

final usuariosRoutes = Router()
  ..get('/', _obtenerTodos)
  ..get('/roles', _obtenerRoles)
  ..get('/<id>', _obtenerPorId)
  ..post('/', _crear)
  ..put('/<id>', _actualizar)
  ..delete('/<id>', _eliminar);

Future<Response> _obtenerRoles(Request request) async {
  final result = await db.execute('SELECT id, nombre FROM roles ORDER BY nombre');
  final roles = result.map((row) => {
    'id': row[0].toString(),
    'nombre': row[1],
  }).toList();
  return Response.ok(jsonEncode(roles), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerTodos(Request request) async {
  final result = await db.execute('''
    SELECT u.id, u.nombre, u.email, u.telefono, u.rol_id, u.activo, u.created_at, u.updated_at
    FROM usuarios u WHERE u.activo = true ORDER BY u.created_at DESC
  ''');

  final usuarios = result.map((row) => {
    'id': row[0].toString(),
    'nombre': row[1],
    'email': row[2],
    'telefono': row[3],
    'rol_id': row[4],
    'activo': row[5],
    'created_at': row[6].toString(),
    'updated_at': row[7].toString(),
  }).toList();

  return Response.ok(jsonEncode(usuarios), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorId(Request request) async {
  final id = request.params['id'];
  final result = await db.execute(
    Sql.named('SELECT * FROM usuarios WHERE id = @id'),
    parameters: {'id': id},
  );

  if (result.isEmpty) return Response.notFound('Usuario no encontrado');

  final row = result.first;
  final usuario = {
    'id': row[0].toString(),
    'nombre': row[1],
    'email': row[2],
    'telefono': row[4],
    'rol_id': row[5],
    'activo': row[6],
  };

  return Response.ok(jsonEncode(usuario), headers: {'Content-Type': 'application/json'});
}

Future<Response> _crear(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      INSERT INTO usuarios (id, nombre, email, password_hash, telefono, rol_id)
      VALUES (@id, @nombre, @email, @password_hash, @telefono, @rol_id)
    '''),
    parameters: {
      'id': data['id'],
      'nombre': data['nombre'],
      'email': data['email'],
      'password_hash': data['password_hash'] ?? '',
      'telefono': data['telefono'],
      'rol_id': data['rol_id'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Usuario creado'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _actualizar(Request request) async {
  final id = request.params['id'];
  final body = await request.readAsString();
  final data = jsonDecode(body);

  await db.execute(
    Sql.named('''
      UPDATE usuarios SET nombre = @nombre, email = @email, telefono = @telefono, rol_id = @rol_id
      WHERE id = @id
    '''),
    parameters: {
      'id': id,
      'nombre': data['nombre'],
      'email': data['email'],
      'telefono': data['telefono'],
      'rol_id': data['rol_id'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Usuario actualizado'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _eliminar(Request request) async {
  final id = request.params['id'];

  await db.execute(
    Sql.named('UPDATE usuarios SET activo = false WHERE id = @id'),
    parameters: {'id': id},
  );

  return Response.ok(jsonEncode({'message': 'Usuario eliminado'}), headers: {'Content-Type': 'application/json'});
}
