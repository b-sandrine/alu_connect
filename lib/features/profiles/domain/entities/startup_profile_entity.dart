import 'package:freezed_annotation/freezed_annotation.dart';

part 'startup_profile_entity.freezed.dart';

@freezed
abstract class StartupProfileEntity with _$StartupProfileEntity {
  const factory StartupProfileEntity({
    required String id,
    required String ownerId,
    required String companyName,
    required String tagline,
    required String description,
    required String industry,
    required String location,
    String? website,
    String? logoUrl,
    @Default(false) bool isVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StartupProfileEntity;
}
