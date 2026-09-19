import 'package:postgres/postgres.dart';

void main() async {
  print('Verificando tablas en PostgreSQL...');

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

    final result = await connection.execute('''
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
      ORDER BY table_name
    ''');

    print('Tablas encontradas:');
    for (final row in result) {
      print('  - ${row[0]}');
    }

    await connection.close();
  } catch (e) {
    print('Error: $e');
  }
}
