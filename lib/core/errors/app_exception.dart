sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

final class AuthException extends AppException {
  const AuthException(super.message);
}

final class NetworkException extends AppException {
  const NetworkException(super.message);
}

final class FirestoreException extends AppException {
  const FirestoreException(super.message);
}

final class StorageException extends AppException {
  const StorageException(super.message);
}

final class ValidationException extends AppException {
  const ValidationException(super.message);
}

final class PermissionException extends AppException {
  const PermissionException(super.message);
}

final class NotFoundException extends AppException {
  const NotFoundException(super.message);
}
