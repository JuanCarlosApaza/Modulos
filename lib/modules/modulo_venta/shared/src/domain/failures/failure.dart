abstract class Failure {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Error del servidor',
    super.code,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Error de caché',
    super.code,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'No encontrado',
    super.code,
  });
}
