// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'startup_profile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FounderEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get linkedinUrl => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  /// Create a copy of FounderEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FounderEntityCopyWith<FounderEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FounderEntityCopyWith<$Res> {
  factory $FounderEntityCopyWith(
          FounderEntity value, $Res Function(FounderEntity) then) =
      _$FounderEntityCopyWithImpl<$Res, FounderEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String role,
      String? photoUrl,
      String? linkedinUrl,
      String? email});
}

/// @nodoc
class _$FounderEntityCopyWithImpl<$Res, $Val extends FounderEntity>
    implements $FounderEntityCopyWith<$Res> {
  _$FounderEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FounderEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? role = null,
    Object? photoUrl = freezed,
    Object? linkedinUrl = freezed,
    Object? email = freezed,
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
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedinUrl: freezed == linkedinUrl
          ? _value.linkedinUrl
          : linkedinUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FounderEntityImplCopyWith<$Res>
    implements $FounderEntityCopyWith<$Res> {
  factory _$$FounderEntityImplCopyWith(
          _$FounderEntityImpl value, $Res Function(_$FounderEntityImpl) then) =
      __$$FounderEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String role,
      String? photoUrl,
      String? linkedinUrl,
      String? email});
}

/// @nodoc
class __$$FounderEntityImplCopyWithImpl<$Res>
    extends _$FounderEntityCopyWithImpl<$Res, _$FounderEntityImpl>
    implements _$$FounderEntityImplCopyWith<$Res> {
  __$$FounderEntityImplCopyWithImpl(
      _$FounderEntityImpl _value, $Res Function(_$FounderEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of FounderEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? role = null,
    Object? photoUrl = freezed,
    Object? linkedinUrl = freezed,
    Object? email = freezed,
  }) {
    return _then(_$FounderEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedinUrl: freezed == linkedinUrl
          ? _value.linkedinUrl
          : linkedinUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FounderEntityImpl implements _FounderEntity {
  const _$FounderEntityImpl(
      {required this.id,
      required this.name,
      required this.role,
      this.photoUrl,
      this.linkedinUrl,
      this.email});

  @override
  final String id;
  @override
  final String name;
  @override
  final String role;
  @override
  final String? photoUrl;
  @override
  final String? linkedinUrl;
  @override
  final String? email;

  @override
  String toString() {
    return 'FounderEntity(id: $id, name: $name, role: $role, photoUrl: $photoUrl, linkedinUrl: $linkedinUrl, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FounderEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.linkedinUrl, linkedinUrl) ||
                other.linkedinUrl == linkedinUrl) &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, role, photoUrl, linkedinUrl, email);

  /// Create a copy of FounderEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FounderEntityImplCopyWith<_$FounderEntityImpl> get copyWith =>
      __$$FounderEntityImplCopyWithImpl<_$FounderEntityImpl>(this, _$identity);
}

abstract class _FounderEntity implements FounderEntity {
  const factory _FounderEntity(
      {required final String id,
      required final String name,
      required final String role,
      final String? photoUrl,
      final String? linkedinUrl,
      final String? email}) = _$FounderEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get role;
  @override
  String? get photoUrl;
  @override
  String? get linkedinUrl;
  @override
  String? get email;

  /// Create a copy of FounderEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FounderEntityImplCopyWith<_$FounderEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TeamMemberEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get department => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;

  /// Create a copy of TeamMemberEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamMemberEntityCopyWith<TeamMemberEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamMemberEntityCopyWith<$Res> {
  factory $TeamMemberEntityCopyWith(
          TeamMemberEntity value, $Res Function(TeamMemberEntity) then) =
      _$TeamMemberEntityCopyWithImpl<$Res, TeamMemberEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String role,
      String department,
      String? photoUrl});
}

/// @nodoc
class _$TeamMemberEntityCopyWithImpl<$Res, $Val extends TeamMemberEntity>
    implements $TeamMemberEntityCopyWith<$Res> {
  _$TeamMemberEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamMemberEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? role = null,
    Object? department = null,
    Object? photoUrl = freezed,
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
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamMemberEntityImplCopyWith<$Res>
    implements $TeamMemberEntityCopyWith<$Res> {
  factory _$$TeamMemberEntityImplCopyWith(_$TeamMemberEntityImpl value,
          $Res Function(_$TeamMemberEntityImpl) then) =
      __$$TeamMemberEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String role,
      String department,
      String? photoUrl});
}

/// @nodoc
class __$$TeamMemberEntityImplCopyWithImpl<$Res>
    extends _$TeamMemberEntityCopyWithImpl<$Res, _$TeamMemberEntityImpl>
    implements _$$TeamMemberEntityImplCopyWith<$Res> {
  __$$TeamMemberEntityImplCopyWithImpl(_$TeamMemberEntityImpl _value,
      $Res Function(_$TeamMemberEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of TeamMemberEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? role = null,
    Object? department = null,
    Object? photoUrl = freezed,
  }) {
    return _then(_$TeamMemberEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TeamMemberEntityImpl implements _TeamMemberEntity {
  const _$TeamMemberEntityImpl(
      {required this.id,
      required this.name,
      required this.role,
      required this.department,
      this.photoUrl});

  @override
  final String id;
  @override
  final String name;
  @override
  final String role;
  @override
  final String department;
  @override
  final String? photoUrl;

  @override
  String toString() {
    return 'TeamMemberEntity(id: $id, name: $name, role: $role, department: $department, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamMemberEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, role, department, photoUrl);

  /// Create a copy of TeamMemberEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamMemberEntityImplCopyWith<_$TeamMemberEntityImpl> get copyWith =>
      __$$TeamMemberEntityImplCopyWithImpl<_$TeamMemberEntityImpl>(
          this, _$identity);
}

abstract class _TeamMemberEntity implements TeamMemberEntity {
  const factory _TeamMemberEntity(
      {required final String id,
      required final String name,
      required final String role,
      required final String department,
      final String? photoUrl}) = _$TeamMemberEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get role;
  @override
  String get department;
  @override
  String? get photoUrl;

  /// Create a copy of TeamMemberEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamMemberEntityImplCopyWith<_$TeamMemberEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GalleryImageEntity {
  String get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  GalleryCategory get category => throw _privateConstructorUsedError;
  DateTime get uploadedAt => throw _privateConstructorUsedError;

  /// Create a copy of GalleryImageEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GalleryImageEntityCopyWith<GalleryImageEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GalleryImageEntityCopyWith<$Res> {
  factory $GalleryImageEntityCopyWith(
          GalleryImageEntity value, $Res Function(GalleryImageEntity) then) =
      _$GalleryImageEntityCopyWithImpl<$Res, GalleryImageEntity>;
  @useResult
  $Res call(
      {String id, String url, GalleryCategory category, DateTime uploadedAt});
}

/// @nodoc
class _$GalleryImageEntityCopyWithImpl<$Res, $Val extends GalleryImageEntity>
    implements $GalleryImageEntityCopyWith<$Res> {
  _$GalleryImageEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GalleryImageEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? category = null,
    Object? uploadedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as GalleryCategory,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GalleryImageEntityImplCopyWith<$Res>
    implements $GalleryImageEntityCopyWith<$Res> {
  factory _$$GalleryImageEntityImplCopyWith(_$GalleryImageEntityImpl value,
          $Res Function(_$GalleryImageEntityImpl) then) =
      __$$GalleryImageEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String url, GalleryCategory category, DateTime uploadedAt});
}

/// @nodoc
class __$$GalleryImageEntityImplCopyWithImpl<$Res>
    extends _$GalleryImageEntityCopyWithImpl<$Res, _$GalleryImageEntityImpl>
    implements _$$GalleryImageEntityImplCopyWith<$Res> {
  __$$GalleryImageEntityImplCopyWithImpl(_$GalleryImageEntityImpl _value,
      $Res Function(_$GalleryImageEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of GalleryImageEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? category = null,
    Object? uploadedAt = null,
  }) {
    return _then(_$GalleryImageEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as GalleryCategory,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$GalleryImageEntityImpl implements _GalleryImageEntity {
  const _$GalleryImageEntityImpl(
      {required this.id,
      required this.url,
      required this.category,
      required this.uploadedAt});

  @override
  final String id;
  @override
  final String url;
  @override
  final GalleryCategory category;
  @override
  final DateTime uploadedAt;

  @override
  String toString() {
    return 'GalleryImageEntity(id: $id, url: $url, category: $category, uploadedAt: $uploadedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GalleryImageEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, url, category, uploadedAt);

  /// Create a copy of GalleryImageEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GalleryImageEntityImplCopyWith<_$GalleryImageEntityImpl> get copyWith =>
      __$$GalleryImageEntityImplCopyWithImpl<_$GalleryImageEntityImpl>(
          this, _$identity);
}

abstract class _GalleryImageEntity implements GalleryImageEntity {
  const factory _GalleryImageEntity(
      {required final String id,
      required final String url,
      required final GalleryCategory category,
      required final DateTime uploadedAt}) = _$GalleryImageEntityImpl;

  @override
  String get id;
  @override
  String get url;
  @override
  GalleryCategory get category;
  @override
  DateTime get uploadedAt;

  /// Create a copy of GalleryImageEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GalleryImageEntityImplCopyWith<_$GalleryImageEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$StartupProfileEntity {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String get tagline => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get industry => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  int? get founded => throw _privateConstructorUsedError;
  String get startupStage => throw _privateConstructorUsedError;
  String get companySize => throw _privateConstructorUsedError;
  String get mission => throw _privateConstructorUsedError;
  String get vision => throw _privateConstructorUsedError;
  String get culture => throw _privateConstructorUsedError;
  List<FounderEntity> get founders => throw _privateConstructorUsedError;
  List<TeamMemberEntity> get teamMembers => throw _privateConstructorUsedError;
  List<GalleryImageEntity> get galleryImages =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of StartupProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartupProfileEntityCopyWith<StartupProfileEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartupProfileEntityCopyWith<$Res> {
  factory $StartupProfileEntityCopyWith(StartupProfileEntity value,
          $Res Function(StartupProfileEntity) then) =
      _$StartupProfileEntityCopyWithImpl<$Res, StartupProfileEntity>;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String companyName,
      String tagline,
      String description,
      String industry,
      String location,
      String? website,
      String? logoUrl,
      bool isVerified,
      int? founded,
      String startupStage,
      String companySize,
      String mission,
      String vision,
      String culture,
      List<FounderEntity> founders,
      List<TeamMemberEntity> teamMembers,
      List<GalleryImageEntity> galleryImages,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$StartupProfileEntityCopyWithImpl<$Res,
        $Val extends StartupProfileEntity>
    implements $StartupProfileEntityCopyWith<$Res> {
  _$StartupProfileEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartupProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? companyName = null,
    Object? tagline = null,
    Object? description = null,
    Object? industry = null,
    Object? location = null,
    Object? website = freezed,
    Object? logoUrl = freezed,
    Object? isVerified = null,
    Object? founded = freezed,
    Object? startupStage = null,
    Object? companySize = null,
    Object? mission = null,
    Object? vision = null,
    Object? culture = null,
    Object? founders = null,
    Object? teamMembers = null,
    Object? galleryImages = null,
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
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      tagline: null == tagline
          ? _value.tagline
          : tagline // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      industry: null == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      founded: freezed == founded
          ? _value.founded
          : founded // ignore: cast_nullable_to_non_nullable
              as int?,
      startupStage: null == startupStage
          ? _value.startupStage
          : startupStage // ignore: cast_nullable_to_non_nullable
              as String,
      companySize: null == companySize
          ? _value.companySize
          : companySize // ignore: cast_nullable_to_non_nullable
              as String,
      mission: null == mission
          ? _value.mission
          : mission // ignore: cast_nullable_to_non_nullable
              as String,
      vision: null == vision
          ? _value.vision
          : vision // ignore: cast_nullable_to_non_nullable
              as String,
      culture: null == culture
          ? _value.culture
          : culture // ignore: cast_nullable_to_non_nullable
              as String,
      founders: null == founders
          ? _value.founders
          : founders // ignore: cast_nullable_to_non_nullable
              as List<FounderEntity>,
      teamMembers: null == teamMembers
          ? _value.teamMembers
          : teamMembers // ignore: cast_nullable_to_non_nullable
              as List<TeamMemberEntity>,
      galleryImages: null == galleryImages
          ? _value.galleryImages
          : galleryImages // ignore: cast_nullable_to_non_nullable
              as List<GalleryImageEntity>,
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
abstract class _$$StartupProfileEntityImplCopyWith<$Res>
    implements $StartupProfileEntityCopyWith<$Res> {
  factory _$$StartupProfileEntityImplCopyWith(_$StartupProfileEntityImpl value,
          $Res Function(_$StartupProfileEntityImpl) then) =
      __$$StartupProfileEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String companyName,
      String tagline,
      String description,
      String industry,
      String location,
      String? website,
      String? logoUrl,
      bool isVerified,
      int? founded,
      String startupStage,
      String companySize,
      String mission,
      String vision,
      String culture,
      List<FounderEntity> founders,
      List<TeamMemberEntity> teamMembers,
      List<GalleryImageEntity> galleryImages,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$StartupProfileEntityImplCopyWithImpl<$Res>
    extends _$StartupProfileEntityCopyWithImpl<$Res, _$StartupProfileEntityImpl>
    implements _$$StartupProfileEntityImplCopyWith<$Res> {
  __$$StartupProfileEntityImplCopyWithImpl(_$StartupProfileEntityImpl _value,
      $Res Function(_$StartupProfileEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of StartupProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? companyName = null,
    Object? tagline = null,
    Object? description = null,
    Object? industry = null,
    Object? location = null,
    Object? website = freezed,
    Object? logoUrl = freezed,
    Object? isVerified = null,
    Object? founded = freezed,
    Object? startupStage = null,
    Object? companySize = null,
    Object? mission = null,
    Object? vision = null,
    Object? culture = null,
    Object? founders = null,
    Object? teamMembers = null,
    Object? galleryImages = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$StartupProfileEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      tagline: null == tagline
          ? _value.tagline
          : tagline // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      industry: null == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      founded: freezed == founded
          ? _value.founded
          : founded // ignore: cast_nullable_to_non_nullable
              as int?,
      startupStage: null == startupStage
          ? _value.startupStage
          : startupStage // ignore: cast_nullable_to_non_nullable
              as String,
      companySize: null == companySize
          ? _value.companySize
          : companySize // ignore: cast_nullable_to_non_nullable
              as String,
      mission: null == mission
          ? _value.mission
          : mission // ignore: cast_nullable_to_non_nullable
              as String,
      vision: null == vision
          ? _value.vision
          : vision // ignore: cast_nullable_to_non_nullable
              as String,
      culture: null == culture
          ? _value.culture
          : culture // ignore: cast_nullable_to_non_nullable
              as String,
      founders: null == founders
          ? _value._founders
          : founders // ignore: cast_nullable_to_non_nullable
              as List<FounderEntity>,
      teamMembers: null == teamMembers
          ? _value._teamMembers
          : teamMembers // ignore: cast_nullable_to_non_nullable
              as List<TeamMemberEntity>,
      galleryImages: null == galleryImages
          ? _value._galleryImages
          : galleryImages // ignore: cast_nullable_to_non_nullable
              as List<GalleryImageEntity>,
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

class _$StartupProfileEntityImpl extends _StartupProfileEntity {
  const _$StartupProfileEntityImpl(
      {required this.id,
      required this.ownerId,
      required this.companyName,
      required this.tagline,
      required this.description,
      required this.industry,
      required this.location,
      this.website,
      this.logoUrl,
      this.isVerified = false,
      this.founded,
      this.startupStage = '',
      this.companySize = '',
      this.mission = '',
      this.vision = '',
      this.culture = '',
      final List<FounderEntity> founders = const <FounderEntity>[],
      final List<TeamMemberEntity> teamMembers = const <TeamMemberEntity>[],
      final List<GalleryImageEntity> galleryImages =
          const <GalleryImageEntity>[],
      required this.createdAt,
      required this.updatedAt})
      : _founders = founders,
        _teamMembers = teamMembers,
        _galleryImages = galleryImages,
        super._();

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String companyName;
  @override
  final String tagline;
  @override
  final String description;
  @override
  final String industry;
  @override
  final String location;
  @override
  final String? website;
  @override
  final String? logoUrl;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final int? founded;
  @override
  @JsonKey()
  final String startupStage;
  @override
  @JsonKey()
  final String companySize;
  @override
  @JsonKey()
  final String mission;
  @override
  @JsonKey()
  final String vision;
  @override
  @JsonKey()
  final String culture;
  final List<FounderEntity> _founders;
  @override
  @JsonKey()
  List<FounderEntity> get founders {
    if (_founders is EqualUnmodifiableListView) return _founders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_founders);
  }

  final List<TeamMemberEntity> _teamMembers;
  @override
  @JsonKey()
  List<TeamMemberEntity> get teamMembers {
    if (_teamMembers is EqualUnmodifiableListView) return _teamMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teamMembers);
  }

  final List<GalleryImageEntity> _galleryImages;
  @override
  @JsonKey()
  List<GalleryImageEntity> get galleryImages {
    if (_galleryImages is EqualUnmodifiableListView) return _galleryImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_galleryImages);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'StartupProfileEntity(id: $id, ownerId: $ownerId, companyName: $companyName, tagline: $tagline, description: $description, industry: $industry, location: $location, website: $website, logoUrl: $logoUrl, isVerified: $isVerified, founded: $founded, startupStage: $startupStage, companySize: $companySize, mission: $mission, vision: $vision, culture: $culture, founders: $founders, teamMembers: $teamMembers, galleryImages: $galleryImages, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartupProfileEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.tagline, tagline) || other.tagline == tagline) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.industry, industry) ||
                other.industry == industry) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.founded, founded) || other.founded == founded) &&
            (identical(other.startupStage, startupStage) ||
                other.startupStage == startupStage) &&
            (identical(other.companySize, companySize) ||
                other.companySize == companySize) &&
            (identical(other.mission, mission) || other.mission == mission) &&
            (identical(other.vision, vision) || other.vision == vision) &&
            (identical(other.culture, culture) || other.culture == culture) &&
            const DeepCollectionEquality().equals(other._founders, _founders) &&
            const DeepCollectionEquality()
                .equals(other._teamMembers, _teamMembers) &&
            const DeepCollectionEquality()
                .equals(other._galleryImages, _galleryImages) &&
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
        companyName,
        tagline,
        description,
        industry,
        location,
        website,
        logoUrl,
        isVerified,
        founded,
        startupStage,
        companySize,
        mission,
        vision,
        culture,
        const DeepCollectionEquality().hash(_founders),
        const DeepCollectionEquality().hash(_teamMembers),
        const DeepCollectionEquality().hash(_galleryImages),
        createdAt,
        updatedAt
      ]);

  /// Create a copy of StartupProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartupProfileEntityImplCopyWith<_$StartupProfileEntityImpl>
      get copyWith =>
          __$$StartupProfileEntityImplCopyWithImpl<_$StartupProfileEntityImpl>(
              this, _$identity);
}

abstract class _StartupProfileEntity extends StartupProfileEntity {
  const factory _StartupProfileEntity(
      {required final String id,
      required final String ownerId,
      required final String companyName,
      required final String tagline,
      required final String description,
      required final String industry,
      required final String location,
      final String? website,
      final String? logoUrl,
      final bool isVerified,
      final int? founded,
      final String startupStage,
      final String companySize,
      final String mission,
      final String vision,
      final String culture,
      final List<FounderEntity> founders,
      final List<TeamMemberEntity> teamMembers,
      final List<GalleryImageEntity> galleryImages,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$StartupProfileEntityImpl;
  const _StartupProfileEntity._() : super._();

  @override
  String get id;
  @override
  String get ownerId;
  @override
  String get companyName;
  @override
  String get tagline;
  @override
  String get description;
  @override
  String get industry;
  @override
  String get location;
  @override
  String? get website;
  @override
  String? get logoUrl;
  @override
  bool get isVerified;
  @override
  int? get founded;
  @override
  String get startupStage;
  @override
  String get companySize;
  @override
  String get mission;
  @override
  String get vision;
  @override
  String get culture;
  @override
  List<FounderEntity> get founders;
  @override
  List<TeamMemberEntity> get teamMembers;
  @override
  List<GalleryImageEntity> get galleryImages;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of StartupProfileEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartupProfileEntityImplCopyWith<_$StartupProfileEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
