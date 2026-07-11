// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opportunity_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OpportunityEntity {
  String get id => throw _privateConstructorUsedError;
  String get startupId => throw _privateConstructorUsedError;
  String get startupName => throw _privateConstructorUsedError;
  String? get startupLogoUrl => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  OpportunityType get type => throw _privateConstructorUsedError;
  OpportunityCategory get category => throw _privateConstructorUsedError;
  List<String> get requiredSkills => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  bool get isRemote => throw _privateConstructorUsedError;
  DateTime get deadline => throw _privateConstructorUsedError;
  String? get compensation => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Create a copy of OpportunityEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpportunityEntityCopyWith<OpportunityEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpportunityEntityCopyWith<$Res> {
  factory $OpportunityEntityCopyWith(
          OpportunityEntity value, $Res Function(OpportunityEntity) then) =
      _$OpportunityEntityCopyWithImpl<$Res, OpportunityEntity>;
  @useResult
  $Res call(
      {String id,
      String startupId,
      String startupName,
      String? startupLogoUrl,
      String title,
      String description,
      OpportunityType type,
      OpportunityCategory category,
      List<String> requiredSkills,
      String location,
      bool isRemote,
      DateTime deadline,
      String? compensation,
      DateTime createdAt,
      DateTime updatedAt,
      bool isActive});
}

/// @nodoc
class _$OpportunityEntityCopyWithImpl<$Res, $Val extends OpportunityEntity>
    implements $OpportunityEntityCopyWith<$Res> {
  _$OpportunityEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpportunityEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startupId = null,
    Object? startupName = null,
    Object? startupLogoUrl = freezed,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? category = null,
    Object? requiredSkills = null,
    Object? location = null,
    Object? isRemote = null,
    Object? deadline = null,
    Object? compensation = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startupId: null == startupId
          ? _value.startupId
          : startupId // ignore: cast_nullable_to_non_nullable
              as String,
      startupName: null == startupName
          ? _value.startupName
          : startupName // ignore: cast_nullable_to_non_nullable
              as String,
      startupLogoUrl: freezed == startupLogoUrl
          ? _value.startupLogoUrl
          : startupLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OpportunityType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as OpportunityCategory,
      requiredSkills: null == requiredSkills
          ? _value.requiredSkills
          : requiredSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      isRemote: null == isRemote
          ? _value.isRemote
          : isRemote // ignore: cast_nullable_to_non_nullable
              as bool,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      compensation: freezed == compensation
          ? _value.compensation
          : compensation // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpportunityEntityImplCopyWith<$Res>
    implements $OpportunityEntityCopyWith<$Res> {
  factory _$$OpportunityEntityImplCopyWith(_$OpportunityEntityImpl value,
          $Res Function(_$OpportunityEntityImpl) then) =
      __$$OpportunityEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String startupId,
      String startupName,
      String? startupLogoUrl,
      String title,
      String description,
      OpportunityType type,
      OpportunityCategory category,
      List<String> requiredSkills,
      String location,
      bool isRemote,
      DateTime deadline,
      String? compensation,
      DateTime createdAt,
      DateTime updatedAt,
      bool isActive});
}

/// @nodoc
class __$$OpportunityEntityImplCopyWithImpl<$Res>
    extends _$OpportunityEntityCopyWithImpl<$Res, _$OpportunityEntityImpl>
    implements _$$OpportunityEntityImplCopyWith<$Res> {
  __$$OpportunityEntityImplCopyWithImpl(_$OpportunityEntityImpl _value,
      $Res Function(_$OpportunityEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpportunityEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startupId = null,
    Object? startupName = null,
    Object? startupLogoUrl = freezed,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? category = null,
    Object? requiredSkills = null,
    Object? location = null,
    Object? isRemote = null,
    Object? deadline = null,
    Object? compensation = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isActive = null,
  }) {
    return _then(_$OpportunityEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startupId: null == startupId
          ? _value.startupId
          : startupId // ignore: cast_nullable_to_non_nullable
              as String,
      startupName: null == startupName
          ? _value.startupName
          : startupName // ignore: cast_nullable_to_non_nullable
              as String,
      startupLogoUrl: freezed == startupLogoUrl
          ? _value.startupLogoUrl
          : startupLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OpportunityType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as OpportunityCategory,
      requiredSkills: null == requiredSkills
          ? _value._requiredSkills
          : requiredSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      isRemote: null == isRemote
          ? _value.isRemote
          : isRemote // ignore: cast_nullable_to_non_nullable
              as bool,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      compensation: freezed == compensation
          ? _value.compensation
          : compensation // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$OpportunityEntityImpl extends _OpportunityEntity {
  const _$OpportunityEntityImpl(
      {required this.id,
      required this.startupId,
      required this.startupName,
      this.startupLogoUrl,
      required this.title,
      required this.description,
      required this.type,
      required this.category,
      required final List<String> requiredSkills,
      required this.location,
      this.isRemote = false,
      required this.deadline,
      this.compensation,
      required this.createdAt,
      required this.updatedAt,
      this.isActive = true})
      : _requiredSkills = requiredSkills,
        super._();

  @override
  final String id;
  @override
  final String startupId;
  @override
  final String startupName;
  @override
  final String? startupLogoUrl;
  @override
  final String title;
  @override
  final String description;
  @override
  final OpportunityType type;
  @override
  final OpportunityCategory category;
  final List<String> _requiredSkills;
  @override
  List<String> get requiredSkills {
    if (_requiredSkills is EqualUnmodifiableListView) return _requiredSkills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredSkills);
  }

  @override
  final String location;
  @override
  @JsonKey()
  final bool isRemote;
  @override
  final DateTime deadline;
  @override
  final String? compensation;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'OpportunityEntity(id: $id, startupId: $startupId, startupName: $startupName, startupLogoUrl: $startupLogoUrl, title: $title, description: $description, type: $type, category: $category, requiredSkills: $requiredSkills, location: $location, isRemote: $isRemote, deadline: $deadline, compensation: $compensation, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpportunityEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startupId, startupId) ||
                other.startupId == startupId) &&
            (identical(other.startupName, startupName) ||
                other.startupName == startupName) &&
            (identical(other.startupLogoUrl, startupLogoUrl) ||
                other.startupLogoUrl == startupLogoUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._requiredSkills, _requiredSkills) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.isRemote, isRemote) ||
                other.isRemote == isRemote) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.compensation, compensation) ||
                other.compensation == compensation) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      startupId,
      startupName,
      startupLogoUrl,
      title,
      description,
      type,
      category,
      const DeepCollectionEquality().hash(_requiredSkills),
      location,
      isRemote,
      deadline,
      compensation,
      createdAt,
      updatedAt,
      isActive);

  /// Create a copy of OpportunityEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpportunityEntityImplCopyWith<_$OpportunityEntityImpl> get copyWith =>
      __$$OpportunityEntityImplCopyWithImpl<_$OpportunityEntityImpl>(
          this, _$identity);
}

abstract class _OpportunityEntity extends OpportunityEntity {
  const factory _OpportunityEntity(
      {required final String id,
      required final String startupId,
      required final String startupName,
      final String? startupLogoUrl,
      required final String title,
      required final String description,
      required final OpportunityType type,
      required final OpportunityCategory category,
      required final List<String> requiredSkills,
      required final String location,
      final bool isRemote,
      required final DateTime deadline,
      final String? compensation,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final bool isActive}) = _$OpportunityEntityImpl;
  const _OpportunityEntity._() : super._();

  @override
  String get id;
  @override
  String get startupId;
  @override
  String get startupName;
  @override
  String? get startupLogoUrl;
  @override
  String get title;
  @override
  String get description;
  @override
  OpportunityType get type;
  @override
  OpportunityCategory get category;
  @override
  List<String> get requiredSkills;
  @override
  String get location;
  @override
  bool get isRemote;
  @override
  DateTime get deadline;
  @override
  String? get compensation;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isActive;

  /// Create a copy of OpportunityEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpportunityEntityImplCopyWith<_$OpportunityEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OpportunityFilter {
  String? get query => throw _privateConstructorUsedError;
  OpportunityType? get type => throw _privateConstructorUsedError;
  OpportunityCategory? get category => throw _privateConstructorUsedError;
  bool? get isRemote => throw _privateConstructorUsedError;

  /// Create a copy of OpportunityFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpportunityFilterCopyWith<OpportunityFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpportunityFilterCopyWith<$Res> {
  factory $OpportunityFilterCopyWith(
          OpportunityFilter value, $Res Function(OpportunityFilter) then) =
      _$OpportunityFilterCopyWithImpl<$Res, OpportunityFilter>;
  @useResult
  $Res call(
      {String? query,
      OpportunityType? type,
      OpportunityCategory? category,
      bool? isRemote});
}

/// @nodoc
class _$OpportunityFilterCopyWithImpl<$Res, $Val extends OpportunityFilter>
    implements $OpportunityFilterCopyWith<$Res> {
  _$OpportunityFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpportunityFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? type = freezed,
    Object? category = freezed,
    Object? isRemote = freezed,
  }) {
    return _then(_value.copyWith(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OpportunityType?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as OpportunityCategory?,
      isRemote: freezed == isRemote
          ? _value.isRemote
          : isRemote // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpportunityFilterImplCopyWith<$Res>
    implements $OpportunityFilterCopyWith<$Res> {
  factory _$$OpportunityFilterImplCopyWith(_$OpportunityFilterImpl value,
          $Res Function(_$OpportunityFilterImpl) then) =
      __$$OpportunityFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? query,
      OpportunityType? type,
      OpportunityCategory? category,
      bool? isRemote});
}

/// @nodoc
class __$$OpportunityFilterImplCopyWithImpl<$Res>
    extends _$OpportunityFilterCopyWithImpl<$Res, _$OpportunityFilterImpl>
    implements _$$OpportunityFilterImplCopyWith<$Res> {
  __$$OpportunityFilterImplCopyWithImpl(_$OpportunityFilterImpl _value,
      $Res Function(_$OpportunityFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpportunityFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? type = freezed,
    Object? category = freezed,
    Object? isRemote = freezed,
  }) {
    return _then(_$OpportunityFilterImpl(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OpportunityType?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as OpportunityCategory?,
      isRemote: freezed == isRemote
          ? _value.isRemote
          : isRemote // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$OpportunityFilterImpl extends _OpportunityFilter {
  const _$OpportunityFilterImpl(
      {this.query, this.type, this.category, this.isRemote})
      : super._();

  @override
  final String? query;
  @override
  final OpportunityType? type;
  @override
  final OpportunityCategory? category;
  @override
  final bool? isRemote;

  @override
  String toString() {
    return 'OpportunityFilter(query: $query, type: $type, category: $category, isRemote: $isRemote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpportunityFilterImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isRemote, isRemote) ||
                other.isRemote == isRemote));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query, type, category, isRemote);

  /// Create a copy of OpportunityFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpportunityFilterImplCopyWith<_$OpportunityFilterImpl> get copyWith =>
      __$$OpportunityFilterImplCopyWithImpl<_$OpportunityFilterImpl>(
          this, _$identity);
}

abstract class _OpportunityFilter extends OpportunityFilter {
  const factory _OpportunityFilter(
      {final String? query,
      final OpportunityType? type,
      final OpportunityCategory? category,
      final bool? isRemote}) = _$OpportunityFilterImpl;
  const _OpportunityFilter._() : super._();

  @override
  String? get query;
  @override
  OpportunityType? get type;
  @override
  OpportunityCategory? get category;
  @override
  bool? get isRemote;

  /// Create a copy of OpportunityFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpportunityFilterImplCopyWith<_$OpportunityFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
