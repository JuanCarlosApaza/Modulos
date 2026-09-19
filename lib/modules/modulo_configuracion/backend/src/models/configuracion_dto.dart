class ConfiguracionDto {
  final String id;
  final String clave;
  final String valor;
  final String? descripcion;
  final String categoria;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ConfiguracionDto({
    required this.id,
    required this.clave,
    required this.valor,
    this.descripcion,
    required this.categoria,
    this.createdAt,
    this.updatedAt,
  });

  factory ConfiguracionDto.fromJson(Map<String, dynamic> json) {
    return ConfiguracionDto(
      id: json['id'] as String,
      clave: json['clave'] as String,
      valor: json['valor'] as String,
      descripcion: json['descripcion'] as String?,
      categoria: json['categoria'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clave': clave,
      'valor': valor,
      'descripcion': descripcion,
      'categoria': categoria,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
