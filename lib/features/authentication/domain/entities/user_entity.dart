import 'package:equatable/equatable.dart';

enum UserRole { student, startup }

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    this.photoUrl,
    this.hasCompletedOnboarding = false,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final String? photoUrl;
  final bool hasCompletedOnboarding;
  final DateTime createdAt;

  bool get isStudent => role == UserRole.student;
  bool get isStartup => role == UserRole.startup;

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        role,
        photoUrl,
        hasCompletedOnboarding,
        createdAt,
      ];
}
