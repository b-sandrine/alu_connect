import 'package:firebase_auth/firebase_auth.dart';
import '../errors/app_exception.dart';

class FirebaseErrorMapper {
  FirebaseErrorMapper._();

  static AppException fromAuthException(FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found' || 'invalid-credential' =>
        const AuthException('Incorrect email or password.'),
      'wrong-password' => const AuthException('Incorrect password.'),
      'email-already-in-use' =>
        const AuthException('An account already exists with this email.'),
      'invalid-email' => const AuthException('The email address is invalid.'),
      'weak-password' => const AuthException('Password is too weak. Use at least 8 characters.'),
      'user-disabled' => const AuthException('This account has been disabled.'),
      'too-many-requests' =>
        const AuthException('Too many attempts. Please try again later.'),
      'network-request-failed' => const NetworkException('No internet connection.'),
      'requires-recent-login' =>
        const AuthException('Please sign in again to continue.'),
      // Firebase Auth REST API returns this when the Email/Password provider
      // is not enabled in the Firebase Console.
      'configuration-not-found' || 'CONFIGURATION_NOT_FOUND' =>
        const AuthException(
          'Sign-in is not configured. Please contact support.',
        ),
      _ => AuthException('Authentication failed: ${e.message ?? e.code}'),
    };
  }

  static AppException fromCode(String code) {
    return switch (code) {
      'permission-denied' => const PermissionException('You do not have permission to perform this action.'),
      'not-found' => const NotFoundException('The requested resource was not found.'),
      'unavailable' => const NetworkException('Service temporarily unavailable. Please try again.'),
      'deadline-exceeded' => const NetworkException('Request timed out. Please try again.'),
      _ => FirestoreException('Operation failed: $code'),
    };
  }
}
