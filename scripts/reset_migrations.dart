import 'package:postgres/postgres.dart';

void main() async {
  print('Reseteando migraciones...');

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

    await connection.execute('DROP TABLE IF EXISTS _migrations CASCADE');
    print('Tabla _migrations eliminada');

    await connection.close();
    print('Listo');
  } catch (e) {
    print('Error: $e');
  }
}
