abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({String message = 'Error del servidor'})
      : super(message: message);
}

class ValidationFailure extends Failure {
  const ValidationFailure({String message = 'Error de validación'})
      : super(message: message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({String message = 'Recurso no encontrado'})
      : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Error de caché'})
      : super(message: message);
}
