import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    this.photoUrl,
    this.hasCompletedOnboarding = false,
    required this.createdAt,
    this.lastActiveAt,
  });

  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final String? photoUrl;
  final bool hasCompletedOnboarding;
  final DateTime createdAt;
  final DateTime? lastActiveAt;

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] as String,
      displayName: data['displayName'] as String,
      role: UserRole.values.byName(data['role'] as String),
      photoUrl: data['photoUrl'] as String?,
      hasCompletedOnboarding: data['hasCompletedOnboarding'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActiveAt: data['lastActiveAt'] != null
          ? (data['lastActiveAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'photoUrl': photoUrl,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActiveAt':
          lastActiveAt != null ? Timestamp.fromDate(lastActiveAt!) : null,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName,
      role: role,
      photoUrl: photoUrl,
      hasCompletedOnboarding: hasCompletedOnboarding,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt,
    );
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    bool? hasCompletedOnboarding,
  }) {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      role: role,
      photoUrl: photoUrl ?? this.photoUrl,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt,
    );
  }
}
