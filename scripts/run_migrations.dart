import 'dart:io';
import 'package:postgres/postgres.dart';

void main() async {
  print('Ejecutando migraciones...');

  try {
    final connection = await Connection.open(
      Endpoint(
        host: 'localhost',
        port: 5432,
        database: 'Modulos_dev',
        username: 'postgres',
        password: 'carlos2026',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );
    print('Conectado a PostgreSQL');

    final migrations = [
      'lib/modules/modulo_usuarios/database/src/migrations/01_usuarios_roles.sql',
      'lib/modules/modulo_producto/database/src/migrations/01_producto.sql',
      'lib/modules/modulo_cliente/database/src/migrations/01_cliente.sql',
      'lib/modules/modulo_venta/database/src/migrations/01_venta.sql',
      'lib/modules/modulo_citas/database/src/migrations/01_cita.sql',
      'lib/modules/modulo_inventario/database/src/migrations/01_inventario.sql',
      'lib/modules/modulo_reportes/database/src/migrations/01_reportes.sql',
      'lib/modules/modulo_notificaciones/database/src/migrations/01_notificaciones.sql',
      'lib/modules/modulo_configuracion/database/src/migrations/01_configuracion.sql',
    ];

    for (final path in migrations) {
      final file = File(path);
      if (!file.existsSync()) {
        print('Saltando $path (no existe)');
        continue;
      }
      final sql = file.readAsStringSync();
      print('Ejecutando $path...');
      await connection.execute(sql);
      print('  OK');
    }

    print('Migraciones completadas');
    await connection.close();
  } catch (e) {
    print('Error: $e');
  }
}
