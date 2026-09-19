import 'package:postgres/postgres.dart';

void main() async {
  print('Probando conexión a PostgreSQL...');

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
    print('Conexión exitosa a localhost:5432/Modulos_dev');

    await connection.close();
    print('Desconectado correctamente');
  } catch (e) {
    print('Error de conexión: $e');
  }
}
