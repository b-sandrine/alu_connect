// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_profile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProjectEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get technologies => throw _privateConstructorUsedError;
  String? get githubUrl => throw _privateConstructorUsedError;
  String? get liveDemoUrl => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;

  /// Create a copy of ProjectEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectEntityCopyWith<ProjectEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectEntityCopyWith<$Res> {
  factory $ProjectEntityCopyWith(
          ProjectEntity value, $Res Function(ProjectEntity) then) =
      _$ProjectEntityCopyWithImpl<$Res, ProjectEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      List<String> technologies,
      String? githubUrl,
      String? liveDemoUrl,
      List<String> imageUrls});
}

/// @nodoc
class _$ProjectEntityCopyWithImpl<$Res, $Val extends ProjectEntity>
    implements $ProjectEntityCopyWith<$Res> {
  _$ProjectEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? technologies = null,
    Object? githubUrl = freezed,
    Object? liveDemoUrl = freezed,
    Object? imageUrls = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      technologies: null == technologies
          ? _value.technologies
          : technologies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      githubUrl: freezed == githubUrl
          ? _value.githubUrl
          : githubUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      liveDemoUrl: freezed == liveDemoUrl
          ? _value.liveDemoUrl
          : liveDemoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectEntityImplCopyWith<$Res>
    implements $ProjectEntityCopyWith<$Res> {
  factory _$$ProjectEntityImplCopyWith(
          _$ProjectEntityImpl value, $Res Function(_$ProjectEntityImpl) then) =
      __$$ProjectEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      List<String> technologies,
      String? githubUrl,
      String? liveDemoUrl,
      List<String> imageUrls});
}

/// @nodoc
class __$$ProjectEntityImplCopyWithImpl<$Res>
    extends _$ProjectEntityCopyWithImpl<$Res, _$ProjectEntityImpl>
    implements _$$ProjectEntityImplCopyWith<$Res> {
  __$$ProjectEntityImplCopyWithImpl(
      _$ProjectEntityImpl _value, $Res Function(_$ProjectEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? technologies = null,
    Object? githubUrl = freezed,
    Object? liveDemoUrl = freezed,
    Object? imageUrls = null,
  }) {
    return _then(_$ProjectEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      technologies: null == technologies
          ? _value._technologies
          : technologies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      githubUrl: freezed == githubUrl
          ? _value.githubUrl
          : githubUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      liveDemoUrl: freezed == liveDemoUrl
          ? _value.liveDemoUrl
          : liveDemoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ProjectEntityImpl implements _ProjectEntity {
  const _$ProjectEntityImpl(
      {required this.id,
      required this.name,
      required this.description,
      final List<String> technologies = const <String>[],
      this.githubUrl,
      this.liveDemoUrl,
      final List<String> imageUrls = const <String>[]})
      : _technologies = technologies,
        _imageUrls = imageUrls;

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  final List<String> _technologies;
  @override
  @JsonKey()
  List<String> get technologies {
    if (_technologies is EqualUnmodifiableListView) return _technologies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_technologies);
  }

  @override
  final String? githubUrl;
  @override
  final String? liveDemoUrl;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  String toString() {
    return 'ProjectEntity(id: $id, name: $name, description: $description, technologies: $technologies, githubUrl: $githubUrl, liveDemoUrl: $liveDemoUrl, imageUrls: $imageUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._technologies, _technologies) &&
            (identical(other.githubUrl, githubUrl) ||
                other.githubUrl == githubUrl) &&
            (identical(other.liveDemoUrl, liveDemoUrl) ||
                other.liveDemoUrl == liveDemoUrl) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_technologies),
      githubUrl,
      liveDemoUrl,
      const DeepCollectionEquality().hash(_imageUrls));

  /// Create a copy of ProjectEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectEntityImplCopyWith<_$ProjectEntityImpl> get copyWith =>
      __$$ProjectEntityImplCopyWithImpl<_$ProjectEntityImpl>(this, _$identity);
}

abstract class _ProjectEntity implements ProjectEntity {
  const factory _ProjectEntity(
      {required final String id,
      required final String name,
      required final String description,
      final List<String> technologies,
      final String? githubUrl,
      final String? liveDemoUrl,
      final List<String> imageUrls}) = _$ProjectEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get technologies;
  @override
  String? get githubUrl;
  @override
  String? get liveDemoUrl;
  @override
  List<String> get imageUrls;

  /// Create a copy of ProjectEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectEntityImplCopyWith<_$ProjectEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StudentProfileEntity {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String get university => throw _privateConstructorUsedError;
  String get degree => throw _privateConstructorUsedError;
  String get yearOfStudy => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  String get careerInterests => throw _privateConstructorUsedError;
  String get personalStatement => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  String? get resumeUrl => throw _privateConstructorUsedError;
  String? get resumeFileName => throw _privateConstructorUsedError;
  DateTime? get resumeUploadedAt => throw _privateConstructorUsedError;
  String? get portfolioUrl => throw _privateConstructorUsedError;
  String? get githubUrl => throw _privateConstructorUsedError;
  String? get linkedinUrl => throw _privateConstructorUsedError;
  String? get behanceUrl => throw _privateConstructorUsedError;
  String? get dribbbleUrl => throw _privateConstructorUsedError;
  String? get mediumUrl => throw _privateConstructorUsedError;
  String? get personalWebsiteUrl => throw _privateConstructorUsedError;
  List<ProjectEntity> get projects => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of StudentProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentProfileEntityCopyWith<StudentProfileEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentProfileEntityCopyWith<$Res> {
  factory $StudentProfileEntityCopyWith(StudentProfileEntity value,
          $Res Function(StudentProfileEntity) then) =
      _$StudentProfileEntityCopyWithImpl<$Res, StudentProfileEntity>;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String? photoUrl,
      String university,
      String degree,
      String yearOfStudy,
      String location,
      String bio,
      String careerInterests,
      String personalStatement,
      List<String> skills,
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
      List<ProjectEntity> projects,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$StudentProfileEntityCopyWithImpl<$Res,
        $Val extends StudentProfileEntity>
    implements $StudentProfileEntityCopyWith<$Res> {
  _$StudentProfileEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? photoUrl = freezed,
    Object? university = null,
    Object? degree = null,
    Object? yearOfStudy = null,
    Object? location = null,
    Object? bio = null,
    Object? careerInterests = null,
    Object? personalStatement = null,
    Object? skills = null,
    Object? resumeUrl = freezed,
    Object? resumeFileName = freezed,
    Object? resumeUploadedAt = freezed,
    Object? portfolioUrl = freezed,
    Object? githubUrl = freezed,
    Object? linkedinUrl = freezed,
    Object? behanceUrl = freezed,
    Object? dribbbleUrl = freezed,
    Object? mediumUrl = freezed,
    Object? personalWebsiteUrl = freezed,
    Object? projects = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      university: null == university
          ? _value.university
          : university // ignore: cast_nullable_to_non_nullable
              as String,
      degree: null == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String,
      yearOfStudy: null == yearOfStudy
          ? _value.yearOfStudy
          : yearOfStudy // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      careerInterests: null == careerInterests
          ? _value.careerInterests
          : careerInterests // ignore: cast_nullable_to_non_nullable
              as String,
      personalStatement: null == personalStatement
          ? _value.personalStatement
          : personalStatement // ignore: cast_nullable_to_non_nullable
              as String,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      resumeUrl: freezed == resumeUrl
          ? _value.resumeUrl
          : resumeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      resumeFileName: freezed == resumeFileName
          ? _value.resumeFileName
          : resumeFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      resumeUploadedAt: freezed == resumeUploadedAt
          ? _value.resumeUploadedAt
          : resumeUploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      portfolioUrl: freezed == portfolioUrl
          ? _value.portfolioUrl
          : portfolioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      githubUrl: freezed == githubUrl
          ? _value.githubUrl
          : githubUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedinUrl: freezed == linkedinUrl
          ? _value.linkedinUrl
          : linkedinUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      behanceUrl: freezed == behanceUrl
          ? _value.behanceUrl
          : behanceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dribbbleUrl: freezed == dribbbleUrl
          ? _value.dribbbleUrl
          : dribbbleUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mediumUrl: freezed == mediumUrl
          ? _value.mediumUrl
          : mediumUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      personalWebsiteUrl: freezed == personalWebsiteUrl
          ? _value.personalWebsiteUrl
          : personalWebsiteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      projects: null == projects
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ProjectEntity>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StudentProfileEntityImplCopyWith<$Res>
    implements $StudentProfileEntityCopyWith<$Res> {
  factory _$$StudentProfileEntityImplCopyWith(_$StudentProfileEntityImpl value,
          $Res Function(_$StudentProfileEntityImpl) then) =
      __$$StudentProfileEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String? photoUrl,
      String university,
      String degree,
      String yearOfStudy,
      String location,
      String bio,
      String careerInterests,
      String personalStatement,
      List<String> skills,
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
      List<ProjectEntity> projects,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$StudentProfileEntityImplCopyWithImpl<$Res>
    extends _$StudentProfileEntityCopyWithImpl<$Res, _$StudentProfileEntityImpl>
    implements _$$StudentProfileEntityImplCopyWith<$Res> {
  __$$StudentProfileEntityImplCopyWithImpl(_$StudentProfileEntityImpl _value,
      $Res Function(_$StudentProfileEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of StudentProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? photoUrl = freezed,
    Object? university = null,
    Object? degree = null,
    Object? yearOfStudy = null,
    Object? location = null,
    Object? bio = null,
    Object? careerInterests = null,
    Object? personalStatement = null,
    Object? skills = null,
    Object? resumeUrl = freezed,
    Object? resumeFileName = freezed,
    Object? resumeUploadedAt = freezed,
    Object? portfolioUrl = freezed,
    Object? githubUrl = freezed,
    Object? linkedinUrl = freezed,
    Object? behanceUrl = freezed,
    Object? dribbbleUrl = freezed,
    Object? mediumUrl = freezed,
    Object? personalWebsiteUrl = freezed,
    Object? projects = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$StudentProfileEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      university: null == university
          ? _value.university
          : university // ignore: cast_nullable_to_non_nullable
              as String,
      degree: null == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String,
      yearOfStudy: null == yearOfStudy
          ? _value.yearOfStudy
          : yearOfStudy // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      careerInterests: null == careerInterests
          ? _value.careerInterests
          : careerInterests // ignore: cast_nullable_to_non_nullable
              as String,
      personalStatement: null == personalStatement
          ? _value.personalStatement
          : personalStatement // ignore: cast_nullable_to_non_nullable
              as String,
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      resumeUrl: freezed == resumeUrl
          ? _value.resumeUrl
          : resumeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      resumeFileName: freezed == resumeFileName
          ? _value.resumeFileName
          : resumeFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      resumeUploadedAt: freezed == resumeUploadedAt
          ? _value.resumeUploadedAt
          : resumeUploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      portfolioUrl: freezed == portfolioUrl
          ? _value.portfolioUrl
          : portfolioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      githubUrl: freezed == githubUrl
          ? _value.githubUrl
          : githubUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedinUrl: freezed == linkedinUrl
          ? _value.linkedinUrl
          : linkedinUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      behanceUrl: freezed == behanceUrl
          ? _value.behanceUrl
          : behanceUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dribbbleUrl: freezed == dribbbleUrl
          ? _value.dribbbleUrl
          : dribbbleUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mediumUrl: freezed == mediumUrl
          ? _value.mediumUrl
          : mediumUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      personalWebsiteUrl: freezed == personalWebsiteUrl
          ? _value.personalWebsiteUrl
          : personalWebsiteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      projects: null == projects
          ? _value._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ProjectEntity>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$StudentProfileEntityImpl extends _StudentProfileEntity {
  const _$StudentProfileEntityImpl(
      {required this.id,
      required this.ownerId,
      this.photoUrl,
      required this.university,
      required this.degree,
      required this.yearOfStudy,
      required this.location,
      required this.bio,
      this.careerInterests = '',
      this.personalStatement = '',
      final List<String> skills = const <String>[],
      this.resumeUrl,
      this.resumeFileName,
      this.resumeUploadedAt,
      this.portfolioUrl,
      this.githubUrl,
      this.linkedinUrl,
      this.behanceUrl,
      this.dribbbleUrl,
      this.mediumUrl,
      this.personalWebsiteUrl,
      final List<ProjectEntity> projects = const <ProjectEntity>[],
      required this.createdAt,
      required this.updatedAt})
      : _skills = skills,
        _projects = projects,
        super._();

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String? photoUrl;
  @override
  final String university;
  @override
  final String degree;
  @override
  final String yearOfStudy;
  @override
  final String location;
  @override
  final String bio;
  @override
  @JsonKey()
  final String careerInterests;
  @override
  @JsonKey()
  final String personalStatement;
  final List<String> _skills;
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  final String? resumeUrl;
  @override
  final String? resumeFileName;
  @override
  final DateTime? resumeUploadedAt;
  @override
  final String? portfolioUrl;
  @override
  final String? githubUrl;
  @override
  final String? linkedinUrl;
  @override
  final String? behanceUrl;
  @override
  final String? dribbbleUrl;
  @override
  final String? mediumUrl;
  @override
  final String? personalWebsiteUrl;
  final List<ProjectEntity> _projects;
  @override
  @JsonKey()
  List<ProjectEntity> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'StudentProfileEntity(id: $id, ownerId: $ownerId, photoUrl: $photoUrl, university: $university, degree: $degree, yearOfStudy: $yearOfStudy, location: $location, bio: $bio, careerInterests: $careerInterests, personalStatement: $personalStatement, skills: $skills, resumeUrl: $resumeUrl, resumeFileName: $resumeFileName, resumeUploadedAt: $resumeUploadedAt, portfolioUrl: $portfolioUrl, githubUrl: $githubUrl, linkedinUrl: $linkedinUrl, behanceUrl: $behanceUrl, dribbbleUrl: $dribbbleUrl, mediumUrl: $mediumUrl, personalWebsiteUrl: $personalWebsiteUrl, projects: $projects, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentProfileEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.university, university) ||
                other.university == university) &&
            (identical(other.degree, degree) || other.degree == degree) &&
            (identical(other.yearOfStudy, yearOfStudy) ||
                other.yearOfStudy == yearOfStudy) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.careerInterests, careerInterests) ||
                other.careerInterests == careerInterests) &&
            (identical(other.personalStatement, personalStatement) ||
                other.personalStatement == personalStatement) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            (identical(other.resumeUrl, resumeUrl) ||
                other.resumeUrl == resumeUrl) &&
            (identical(other.resumeFileName, resumeFileName) ||
                other.resumeFileName == resumeFileName) &&
            (identical(other.resumeUploadedAt, resumeUploadedAt) ||
                other.resumeUploadedAt == resumeUploadedAt) &&
            (identical(other.portfolioUrl, portfolioUrl) ||
                other.portfolioUrl == portfolioUrl) &&
            (identical(other.githubUrl, githubUrl) ||
                other.githubUrl == githubUrl) &&
            (identical(other.linkedinUrl, linkedinUrl) ||
                other.linkedinUrl == linkedinUrl) &&
            (identical(other.behanceUrl, behanceUrl) ||
                other.behanceUrl == behanceUrl) &&
            (identical(other.dribbbleUrl, dribbbleUrl) ||
                other.dribbbleUrl == dribbbleUrl) &&
            (identical(other.mediumUrl, mediumUrl) ||
                other.mediumUrl == mediumUrl) &&
            (identical(other.personalWebsiteUrl, personalWebsiteUrl) ||
                other.personalWebsiteUrl == personalWebsiteUrl) &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        ownerId,
        photoUrl,
        university,
        degree,
        yearOfStudy,
        location,
        bio,
        careerInterests,
        personalStatement,
        const DeepCollectionEquality().hash(_skills),
        resumeUrl,
        resumeFileName,
        resumeUploadedAt,
        portfolioUrl,
        githubUrl,
        linkedinUrl,
        behanceUrl,
        dribbbleUrl,
        mediumUrl,
        personalWebsiteUrl,
        const DeepCollectionEquality().hash(_projects),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of StudentProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentProfileEntityImplCopyWith<_$StudentProfileEntityImpl>
      get copyWith =>
          __$$StudentProfileEntityImplCopyWithImpl<_$StudentProfileEntityImpl>(
              this, _$identity);
}

abstract class _StudentProfileEntity extends StudentProfileEntity {
  const factory _StudentProfileEntity(
      {required final String id,
      required final String ownerId,
      final String? photoUrl,
      required final String university,
      required final String degree,
      required final String yearOfStudy,
      required final String location,
      required final String bio,
      final String careerInterests,
      final String personalStatement,
      final List<String> skills,
      final String? resumeUrl,
      final String? resumeFileName,
      final DateTime? resumeUploadedAt,
      final String? portfolioUrl,
      final String? githubUrl,
      final String? linkedinUrl,
      final String? behanceUrl,
      final String? dribbbleUrl,
      final String? mediumUrl,
      final String? personalWebsiteUrl,
      final List<ProjectEntity> projects,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$StudentProfileEntityImpl;
  const _StudentProfileEntity._() : super._();

  @override
  String get id;
  @override
  String get ownerId;
  @override
  String? get photoUrl;
  @override
  String get university;
  @override
  String get degree;
  @override
  String get yearOfStudy;
  @override
  String get location;
  @override
  String get bio;
  @override
  String get careerInterests;
  @override
  String get personalStatement;
  @override
  List<String> get skills;
  @override
  String? get resumeUrl;
  @override
  String? get resumeFileName;
  @override
  DateTime? get resumeUploadedAt;
  @override
  String? get portfolioUrl;
  @override
  String? get githubUrl;
  @override
  String? get linkedinUrl;
  @override
  String? get behanceUrl;
  @override
  String? get dribbbleUrl;
  @override
  String? get mediumUrl;
  @override
  String? get personalWebsiteUrl;
  @override
  List<ProjectEntity> get projects;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of StudentProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentProfileEntityImplCopyWith<_$StudentProfileEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
