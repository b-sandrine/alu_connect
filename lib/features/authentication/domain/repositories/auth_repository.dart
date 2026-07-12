import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  });

  Future<void> signOut();

  Future<UserEntity?> getCurrentUser();

  Future<void> completeOnboarding(String userId);

  Future<void> updateFcmToken(String userId, String token);

  Future<void> clearFcmToken(String userId);

  Future<void> updateLastActiveAt(String userId);

  /// Watches any user's public fields — used to show presence (online /
  /// last seen) for a chat counterpart, not just the signed-in user.
  Stream<UserEntity?> watchUserById(String userId);

  bool get isEmailVerified;

  Future<void> sendEmailVerification();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Re-authenticates, deletes the user's Firestore profile/identity docs,
  /// then deletes the Firebase Auth account itself. Irreversible.
  Future<void> deleteAccount({required String password});
}
