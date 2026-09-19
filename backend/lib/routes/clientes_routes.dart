import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:postgres/postgres.dart';

import '../src/database.dart';

final clientesRoutes = Router()
  ..get('/', _obtenerTodos)
  ..get('/<id>', _obtenerPorId)
  ..post('/', _crear)
  ..put('/<id>', _actualizar)
  ..delete('/<id>', _eliminar);

String? _validarCliente(Map<String, dynamic> data) {
  final nombre = (data['nombre'] as String?)?.trim() ?? '';
  final email = (data['email'] as String?)?.trim() ?? '';
  final telefono = (data['telefono'] as String?)?.trim() ?? '';
  final rfc = (data['rfc'] as String?)?.trim() ?? '';
  final direccion = (data['direccion'] as String?)?.trim() ?? '';
  final notas = (data['notas'] as String?)?.trim() ?? '';

  if (nombre.isEmpty) return 'El nombre es requerido';
  if (nombre.length < 2) return 'El nombre debe tener mínimo 2 caracteres';
  if (nombre.length > 150) return 'El nombre debe tener máximo 150 caracteres';
  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$').hasMatch(nombre)) return 'El nombre solo puede contener letras y espacios';

  if (email.isNotEmpty) {
    if (email.length > 255) return 'El email debe tener máximo 255 caracteres';
    if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(email)) return 'Formato de email inválido';
  }

  if (telefono.isNotEmpty) {
    if (telefono.length > 30) return 'El teléfono debe tener máximo 30 caracteres';
    if (!RegExp(r'^[\d\s\-\(\)\+]+$').hasMatch(telefono)) return 'El teléfono solo puede contener números, espacios, guiones, paréntesis y +';
  }

  if (rfc.isNotEmpty) {
    if (rfc.length < 12 || rfc.length > 13) return 'El RFC debe tener 12 o 13 caracteres';
    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(rfc)) return 'El RFC solo puede contener caracteres alfanuméricos';
  }

  if (direccion.isNotEmpty && direccion.length > 500) return 'La dirección debe tener máximo 500 caracteres';
  if (notas.isNotEmpty && notas.length > 1000) return 'Las notas deben tener máximo 1000 caracteres';

  return null;
}

Future<Response> _obtenerTodos(Request request) async {
  final result = await db.execute('''
    SELECT id, nombre, email, telefono, rfc, direccion, notas, activo
    FROM clientes WHERE activo = true ORDER BY created_at DESC
  ''');

  final clientes = result.map((row) => {
    'id': row[0].toString(),
    'nombre': row[1],
    'email': row[2],
    'telefono': row[3],
    'rfc': row[4],
    'direccion': row[5],
    'notas': row[6],
    'activo': row[7],
  }).toList();

  return Response.ok(jsonEncode(clientes), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerPorId(Request request) async {
  final id = request.params['id'];
  final result = await db.execute(
    Sql.named('SELECT id, nombre, email, telefono, rfc, direccion, notas, activo FROM clientes WHERE id = @id'),
    parameters: {'id': id},
  );

  if (result.isEmpty) return Response.notFound('Cliente no encontrado');

  final row = result.first;
  final cliente = {
    'id': row[0].toString(),
    'nombre': row[1],
    'email': row[2],
    'telefono': row[3],
    'rfc': row[4],
    'direccion': row[5],
    'notas': row[6],
    'activo': row[7],
  };

  return Response.ok(jsonEncode(cliente), headers: {'Content-Type': 'application/json'});
}

Future<Response> _crear(Request request) async {
  final body = await request.readAsString();
  final data = jsonDecode(body);

  final error = _validarCliente(data);
  if (error != null) {
    return Response(400, body: jsonEncode({'error': error}), headers: {'Content-Type': 'application/json'});
  }

  final result = await db.execute(
    Sql.named('''
      INSERT INTO clientes (nombre, email, telefono, rfc, direccion, notas)
      VALUES (@nombre, @email, @telefono, @rfc, @direccion, @notas)
      RETURNING id, nombre, email, telefono, rfc, direccion, notas, activo
    '''),
    parameters: {
      'nombre': data['nombre'],
      'email': data['email'],
      'telefono': data['telefono'],
      'rfc': data['rfc'],
      'direccion': data['direccion'],
      'notas': data['notas'],
    },
  );

  final row = result.first;
  final cliente = {
    'id': row[0].toString(),
    'nombre': row[1],
    'email': row[2],
    'telefono': row[3],
    'rfc': row[4],
    'direccion': row[5],
    'notas': row[6],
    'activo': row[7],
  };

  return Response.ok(jsonEncode(cliente), headers: {'Content-Type': 'application/json'});
}

Future<Response> _actualizar(Request request) async {
  final id = request.params['id'];
  final body = await request.readAsString();
  final data = jsonDecode(body);

  final error = _validarCliente(data);
  if (error != null) {
    return Response(400, body: jsonEncode({'error': error}), headers: {'Content-Type': 'application/json'});
  }

  await db.execute(
    Sql.named('''
      UPDATE clientes SET nombre = @nombre, email = @email, telefono = @telefono, rfc = @rfc,
      direccion = @direccion, notas = @notas
      WHERE id = @id
    '''),
    parameters: {
      'id': id,
      'nombre': data['nombre'],
      'email': data['email'],
      'telefono': data['telefono'],
      'rfc': data['rfc'],
      'direccion': data['direccion'],
      'notas': data['notas'],
    },
  );

  return Response.ok(jsonEncode({'message': 'Cliente actualizado'}), headers: {'Content-Type': 'application/json'});
}

Future<Response> _eliminar(Request request) async {
  final id = request.params['id'];

  await db.execute(
    Sql.named('UPDATE clientes SET activo = false WHERE id = @id'),
    parameters: {'id': id},
  );

  return Response.ok(jsonEncode({'message': 'Cliente eliminado'}), headers: {'Content-Type': 'application/json'});
}
