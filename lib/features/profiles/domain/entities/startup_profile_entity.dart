import 'package:freezed_annotation/freezed_annotation.dart';

part 'startup_profile_entity.freezed.dart';

enum GalleryCategory { office, events, products, achievements }

@freezed
abstract class FounderEntity with _$FounderEntity {
  const factory FounderEntity({
    required String id,
    required String name,
    required String role,
    String? photoUrl,
    String? linkedinUrl,
    String? email,
  }) = _FounderEntity;
}

@freezed
abstract class TeamMemberEntity with _$TeamMemberEntity {
  const factory TeamMemberEntity({
    required String id,
    required String name,
    required String role,
    required String department,
    String? photoUrl,
  }) = _TeamMemberEntity;
}

@freezed
abstract class GalleryImageEntity with _$GalleryImageEntity {
  const factory GalleryImageEntity({
    required String id,
    required String url,
    required GalleryCategory category,
    required DateTime uploadedAt,
  }) = _GalleryImageEntity;
}

@freezed
abstract class StartupProfileEntity with _$StartupProfileEntity {
  const StartupProfileEntity._();

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
    int? founded,
    @Default('') String startupStage,
    @Default('') String companySize,
    @Default('') String mission,
    @Default('') String vision,
    @Default('') String culture,
    @Default(<FounderEntity>[]) List<FounderEntity> founders,
    @Default(<TeamMemberEntity>[]) List<TeamMemberEntity> teamMembers,
    @Default(<GalleryImageEntity>[]) List<GalleryImageEntity> galleryImages,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StartupProfileEntity;

  static const stages = [
    'Idea',
    'MVP',
    'Seed',
    'Series A',
    'Series B+',
    'Growth',
  ];

  static const companySizes = [
    '1-10',
    '11-50',
    '51-200',
    '201-500',
    '500+',
  ];

  bool get hasAboutContent =>
      mission.isNotEmpty || vision.isNotEmpty || culture.isNotEmpty;
}
