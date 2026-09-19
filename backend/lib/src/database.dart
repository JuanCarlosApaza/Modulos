import 'package:postgres/postgres.dart';
import 'config/server_config.dart';

late Connection db;

Future<void> connectDatabase() async {
  db = await Connection.open(
    Endpoint(
      host: ServerConfig.dbHost,
      port: ServerConfig.dbPort,
      database: ServerConfig.dbName,
      username: ServerConfig.dbUser,
      password: ServerConfig.dbPass,
    ),
    settings: ConnectionSettings(sslMode: SslMode.disable),
  );
}
