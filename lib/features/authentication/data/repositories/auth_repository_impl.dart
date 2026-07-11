import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final AuthRemoteDatasource _datasource;

  @override
  Stream<UserEntity?> get authStateChanges =>
      _datasource.authStateChanges.map((model) => model?.toEntity());

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final model = await _datasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return model.toEntity();
  }

  @override
  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    final model = await _datasource.createUserWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
      role: role,
    );
    return model.toEntity();
  }

  @override
  Future<void> signOut() => _datasource.signOut();

  @override
  Future<UserEntity?> getCurrentUser() async {
    final model = await _datasource.getCurrentUser();
    return model?.toEntity();
  }

  @override
  Future<void> completeOnboarding(String userId) =>
      _datasource.completeOnboarding(userId);

  @override
  Future<void> updateFcmToken(String userId, String token) =>
      _datasource.updateFcmToken(userId, token);

  @override
  Future<void> updateLastActiveAt(String userId) =>
      _datasource.updateLastActiveAt(userId);

  @override
  Stream<UserEntity?> watchUserById(String userId) =>
      _datasource.watchUserById(userId).map((model) => model?.toEntity());
}
