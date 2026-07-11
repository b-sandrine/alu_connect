import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

enum UserRole { student, startup }

@freezed
abstract class UserEntity with _$UserEntity {
  const UserEntity._();

  const factory UserEntity({
    required String id,
    required String email,
    required String displayName,
    required UserRole role,
    String? photoUrl,
    @Default(false) bool hasCompletedOnboarding,
    required DateTime createdAt,
  }) = _UserEntity;

  bool get isStudent => role == UserRole.student;
  bool get isStartup => role == UserRole.startup;
}
