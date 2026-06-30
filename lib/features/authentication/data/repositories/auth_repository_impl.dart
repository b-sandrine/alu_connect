import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final AuthRemoteDatasource _datasource;

  @override
  Stream<UserEntity?> get authStateChanges => _datasource.authStateChanges;

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _datasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) {
    return _datasource.createUserWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
      role: role,
    );
  }

  @override
  Future<void> signOut() => _datasource.signOut();

  @override
  Future<UserEntity?> getCurrentUser() => _datasource.getCurrentUser();

  @override
  Future<void> completeOnboarding(String userId) =>
      _datasource.completeOnboarding(userId);
}
