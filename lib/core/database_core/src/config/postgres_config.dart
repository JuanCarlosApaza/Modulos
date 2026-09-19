class DatabaseConfig {
  final String host;
  final int port;
  final String database;
  final String username;
  final String password;
  final bool ssl;

  const DatabaseConfig({
    required this.host,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
    this.ssl = false,
  });

  factory DatabaseConfig.development() {
    return const DatabaseConfig(
      host: 'localhost',
      port: 5432,
      database: 'Modulos_dev',
      username: 'postgres',
      password: 'carlos2026',
    );
  }

  factory DatabaseConfig.production() {
    return const DatabaseConfig(
      host: 'localhost',
      port: 5432,
      database: 'modulos_prod',
      username: 'postgres',
      password: 'postgres',
      ssl: true,
    );
  }
}
