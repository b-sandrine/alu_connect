import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_profile_entity.freezed.dart';

@freezed
abstract class StudentProfileEntity with _$StudentProfileEntity {
  const StudentProfileEntity._();

  const factory StudentProfileEntity({
    required String id,
    required String ownerId,
    String? photoUrl,
    required String university,
    required String degree,
    required String yearOfStudy,
    required String location,
    required String bio,
    @Default('') String careerInterests,
    @Default('') String personalStatement,
    @Default(<String>[]) List<String> skills,
    String? resumeUrl,
    String? resumeFileName,
    DateTime? resumeUploadedAt,
    String? portfolioUrl,
    String? githubUrl,
    String? linkedinUrl,
    String? behanceUrl,
    String? dribbbleUrl,
    String? mediumUrl,
    String? personalWebsiteUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StudentProfileEntity;

  /// Percentage of the profile's fields that are filled in. Drives the
  /// "verification" badge (100% = verified) instead of an admin-granted
  /// flag, matching how startups' isVerified differs from this.
  int get completionPercentage {
    final fields = <Object?>[
      photoUrl,
      university.isNotEmpty ? university : null,
      degree.isNotEmpty ? degree : null,
      yearOfStudy.isNotEmpty ? yearOfStudy : null,
      location.isNotEmpty ? location : null,
      bio.isNotEmpty ? bio : null,
      careerInterests.isNotEmpty ? careerInterests : null,
      personalStatement.isNotEmpty ? personalStatement : null,
      skills.isNotEmpty ? skills : null,
      resumeUrl,
      hasPortfolioLinks ? true : null,
    ];
    final filled = fields.where((f) => f != null).length;
    return ((filled / fields.length) * 100).round();
  }

  bool get hasResume => resumeUrl != null;

  bool get hasPortfolioLinks =>
      portfolioUrl != null ||
      githubUrl != null ||
      linkedinUrl != null ||
      behanceUrl != null ||
      dribbbleUrl != null ||
      mediumUrl != null ||
      personalWebsiteUrl != null;

  bool get isComplete => completionPercentage >= 100;
}
