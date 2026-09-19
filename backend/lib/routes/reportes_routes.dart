import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:postgres/postgres.dart';

import '../src/database.dart';

final reportesRoutes = Router()
  ..get('/resumen', _obtenerResumen)
  ..get('/ventas/diarias', _obtenerVentasDiarias)
  ..get('/ventas/periodo', _obtenerVentasPorPeriodo)
  ..get('/productos/mas-vendidos', _obtenerProductosMasVendidos);

Future<Response> _obtenerResumen(Request request) async {
  try {
    final ventasHoy = await db.execute('''
      SELECT COALESCE(SUM(total), 0) FROM ventas 
      WHERE DATE(created_at) = CURRENT_DATE
    ''');

    final totalClientes = await db.execute('SELECT COUNT(*) FROM clientes WHERE activo = true');
    final totalProductos = await db.execute('SELECT COUNT(*) FROM productos WHERE activo = true');
    final ventasPendientes = await db.execute("SELECT COUNT(*) FROM ventas WHERE estado = 'pendiente'");
    final promedioVenta = await db.execute('''
      SELECT COALESCE(AVG(total), 0) FROM ventas 
      WHERE DATE(created_at) = CURRENT_DATE
    ''');

    final resumen = {
      'total_ventas_hoy': double.parse(ventasHoy.first[0].toString()),
      'total_clientes': int.parse(totalClientes.first[0].toString()),
      'total_productos': int.parse(totalProductos.first[0].toString()),
      'ventas_pendientes': int.parse(ventasPendientes.first[0].toString()),
      'promedio_venta': double.parse(promedioVenta.first[0].toString()),
    };

    return Response.ok(jsonEncode(resumen), headers: {'Content-Type': 'application/json'});
  } catch (e) {
    print('Error en resumen: $e');
    return Response.internalServerError(body: 'Error: $e');
  }
}

Future<Response> _obtenerVentasDiarias(Request request) async {
  final result = await db.execute('''
    SELECT DATE(created_at) as fecha, COUNT(*) as cantidad, SUM(total) as total_ventas, AVG(total) as promedio
    FROM ventas
    GROUP BY DATE(created_at)
    ORDER BY fecha DESC
    LIMIT 30
  ''');

  final ventas = result.map((row) => {
    'fecha': row[0].toString(),
    'cantidad_ventas': row[1],
    'total_ventas': (row[2] as num).toDouble(),
    'promedio_venta': (row[3] as num).toDouble(),
  }).toList();

  return Response.ok(jsonEncode(ventas), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerVentasPorPeriodo(Request request) async {
  final inicio = request.url.queryParameters['inicio'];
  final fin = request.url.queryParameters['fin'];

  if (inicio == null || fin == null) {
    return Response.badRequest(body: jsonEncode({'error': 'Se requieren parámetros inicio y fin'}));
  }

  final result = await db.execute(
    Sql.named('''
      SELECT DATE(created_at) as fecha, COUNT(*) as cantidad, SUM(total) as total_ventas, AVG(total) as promedio
      FROM ventas WHERE created_at >= @inicio AND created_at <= @fin
      GROUP BY DATE(created_at)
      ORDER BY fecha ASC
    '''),
    parameters: {'inicio': inicio, 'fin': fin},
  );

  final ventas = result.map((row) => {
    'fecha': row[0].toString(),
    'cantidad_ventas': row[1],
    'total_ventas': (row[2] as num).toDouble(),
    'promedio_venta': (row[3] as num).toDouble(),
  }).toList();

  return Response.ok(jsonEncode(ventas), headers: {'Content-Type': 'application/json'});
}

Future<Response> _obtenerProductosMasVendidos(Request request) async {
  final result = await db.execute('''
    SELECT p.id, p.nombre, SUM(vd.cantidad) as cantidad_vendida, SUM(vd.subtotal) as total_generado
    FROM venta_detalles vd
    JOIN productos p ON vd.producto_id = p.id
    JOIN ventas v ON vd.venta_id = v.id
    GROUP BY p.id, p.nombre
    ORDER BY cantidad_vendida DESC
    LIMIT 10
  ''');

  final productos = result.map((row) => {
    'producto_id': row[0].toString(),
    'nombre_producto': row[1],
    'cantidad_vendida': row[2],
    'total_generado': (row[3] as num).toDouble(),
  }).toList();

  return Response.ok(jsonEncode(productos), headers: {'Content-Type': 'application/json'});
}
