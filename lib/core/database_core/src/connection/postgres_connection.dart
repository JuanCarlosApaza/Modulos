import 'package:postgres/postgres.dart';

import '../config/postgres_config.dart';

class PostgresConnection {
  static PostgresConnection? _instance;
  Connection? _connection;

  PostgresConnection._();

  static PostgresConnection get instance {
    _instance ??= PostgresConnection._();
    return _instance!;
  }

  Connection get connection {
    if (_connection == null) {
      throw Exception('Conexión no inicializada. Llama a connect() primero.');
    }
    return _connection!;
  }

  Future<void> connect(DatabaseConfig config) async {
    _connection = await Connection.open(
      Endpoint(
        host: config.host,
        port: config.port,
        database: config.database,
        username: config.username,
        password: config.password,
      ),
      settings: ConnectionSettings(sslMode: config.ssl ? SslMode.require : SslMode.disable),
    );
  }

  Future<void> disconnect() async {
    if (_connection != null) {
      await _connection!.close();
    }
    _instance = null;
  }

  bool get isConnected => _connection != null;
}
