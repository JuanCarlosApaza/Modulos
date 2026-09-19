import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../lib/src/config/server_config.dart';
import '../lib/src/database.dart';
import '../lib/routes/usuarios_routes.dart';
import '../lib/routes/productos_routes.dart';
import '../lib/routes/clientes_routes.dart';
import '../lib/routes/ventas_routes.dart';
import '../lib/routes/citas_routes.dart';
import '../lib/routes/inventario_routes.dart';
import '../lib/routes/reportes_routes.dart';
import '../lib/routes/notificaciones_routes.dart';
import '../lib/routes/configuracion_routes.dart';
import '../lib/routes/swagger_routes.dart';

void main() async {
  // Conectar a PostgreSQL
  await connectDatabase();
  print('Conectado a PostgreSQL');

  // Configurar rutas
  final router = Router()
    ..mount('/api/usuarios', usuariosRoutes)
    ..mount('/api/productos', productosRoutes)
    ..mount('/api/clientes', clientesRoutes)
    ..mount('/api/ventas', ventasRoutes)
    ..mount('/api/citas', citasRoutes)
    ..mount('/api/inventario', inventarioRoutes)
    ..mount('/api/reportes', reportesRoutes)
    ..mount('/api/notificaciones', notificacionesRoutes)
    ..mount('/api/configuracion', configuracionRoutes)
    ..mount('/docs', swaggerRoutes);

  // Middleware CORS
  final corsMiddleware = (Handler handler) {
    return (request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        });
      }

      final response = await handler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      });
    };
  };

  final handler = Pipeline().addMiddleware(corsMiddleware).addHandler(router);

  // Iniciar servidor
  final server = await io.serve(handler, ServerConfig.host, ServerConfig.port);
  print('Servidor corriendo en http://${server.address.host}:${server.port}');
}
