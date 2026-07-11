// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConversationEntity {
  String get id => throw _privateConstructorUsedError;
  List<String> get participantIds => throw _privateConstructorUsedError;
  Map<String, String> get participantNames =>
      throw _privateConstructorUsedError;
  Map<String, String?> get participantPhotoUrls =>
      throw _privateConstructorUsedError;
  String? get contextOpportunityId => throw _privateConstructorUsedError;
  String? get contextOpportunityTitle => throw _privateConstructorUsedError;
  String? get lastMessageText => throw _privateConstructorUsedError;
  String? get lastMessageSenderId => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  Map<String, DateTime> get lastReadAt => throw _privateConstructorUsedError;
  List<String> get typingUserIds => throw _privateConstructorUsedError;
  Map<String, DateTime> get typingUpdatedAt =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of ConversationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationEntityCopyWith<ConversationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationEntityCopyWith<$Res> {
  factory $ConversationEntityCopyWith(
          ConversationEntity value, $Res Function(ConversationEntity) then) =
      _$ConversationEntityCopyWithImpl<$Res, ConversationEntity>;
  @useResult
  $Res call(
      {String id,
      List<String> participantIds,
      Map<String, String> participantNames,
      Map<String, String?> participantPhotoUrls,
      String? contextOpportunityId,
      String? contextOpportunityTitle,
      String? lastMessageText,
      String? lastMessageSenderId,
      DateTime? lastMessageAt,
      Map<String, DateTime> lastReadAt,
      List<String> typingUserIds,
      Map<String, DateTime> typingUpdatedAt,
      DateTime createdAt});
}

/// @nodoc
class _$ConversationEntityCopyWithImpl<$Res, $Val extends ConversationEntity>
    implements $ConversationEntityCopyWith<$Res> {
  _$ConversationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participantIds = null,
    Object? participantNames = null,
    Object? participantPhotoUrls = null,
    Object? contextOpportunityId = freezed,
    Object? contextOpportunityTitle = freezed,
    Object? lastMessageText = freezed,
    Object? lastMessageSenderId = freezed,
    Object? lastMessageAt = freezed,
    Object? lastReadAt = null,
    Object? typingUserIds = null,
    Object? typingUpdatedAt = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      participantIds: null == participantIds
          ? _value.participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      participantNames: null == participantNames
          ? _value.participantNames
          : participantNames // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      participantPhotoUrls: null == participantPhotoUrls
          ? _value.participantPhotoUrls
          : participantPhotoUrls // ignore: cast_nullable_to_non_nullable
              as Map<String, String?>,
      contextOpportunityId: freezed == contextOpportunityId
          ? _value.contextOpportunityId
          : contextOpportunityId // ignore: cast_nullable_to_non_nullable
              as String?,
      contextOpportunityTitle: freezed == contextOpportunityTitle
          ? _value.contextOpportunityTitle
          : contextOpportunityTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageText: freezed == lastMessageText
          ? _value.lastMessageText
          : lastMessageText // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderId: freezed == lastMessageSenderId
          ? _value.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReadAt: null == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as Map<String, DateTime>,
      typingUserIds: null == typingUserIds
          ? _value.typingUserIds
          : typingUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      typingUpdatedAt: null == typingUpdatedAt
          ? _value.typingUpdatedAt
          : typingUpdatedAt // ignore: cast_nullable_to_non_nullable
              as Map<String, DateTime>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationEntityImplCopyWith<$Res>
    implements $ConversationEntityCopyWith<$Res> {
  factory _$$ConversationEntityImplCopyWith(_$ConversationEntityImpl value,
          $Res Function(_$ConversationEntityImpl) then) =
      __$$ConversationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<String> participantIds,
      Map<String, String> participantNames,
      Map<String, String?> participantPhotoUrls,
      String? contextOpportunityId,
      String? contextOpportunityTitle,
      String? lastMessageText,
      String? lastMessageSenderId,
      DateTime? lastMessageAt,
      Map<String, DateTime> lastReadAt,
      List<String> typingUserIds,
      Map<String, DateTime> typingUpdatedAt,
      DateTime createdAt});
}

/// @nodoc
class __$$ConversationEntityImplCopyWithImpl<$Res>
    extends _$ConversationEntityCopyWithImpl<$Res, _$ConversationEntityImpl>
    implements _$$ConversationEntityImplCopyWith<$Res> {
  __$$ConversationEntityImplCopyWithImpl(_$ConversationEntityImpl _value,
      $Res Function(_$ConversationEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participantIds = null,
    Object? participantNames = null,
    Object? participantPhotoUrls = null,
    Object? contextOpportunityId = freezed,
    Object? contextOpportunityTitle = freezed,
    Object? lastMessageText = freezed,
    Object? lastMessageSenderId = freezed,
    Object? lastMessageAt = freezed,
    Object? lastReadAt = null,
    Object? typingUserIds = null,
    Object? typingUpdatedAt = null,
    Object? createdAt = null,
  }) {
    return _then(_$ConversationEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      participantIds: null == participantIds
          ? _value._participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      participantNames: null == participantNames
          ? _value._participantNames
          : participantNames // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      participantPhotoUrls: null == participantPhotoUrls
          ? _value._participantPhotoUrls
          : participantPhotoUrls // ignore: cast_nullable_to_non_nullable
              as Map<String, String?>,
      contextOpportunityId: freezed == contextOpportunityId
          ? _value.contextOpportunityId
          : contextOpportunityId // ignore: cast_nullable_to_non_nullable
              as String?,
      contextOpportunityTitle: freezed == contextOpportunityTitle
          ? _value.contextOpportunityTitle
          : contextOpportunityTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageText: freezed == lastMessageText
          ? _value.lastMessageText
          : lastMessageText // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderId: freezed == lastMessageSenderId
          ? _value.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReadAt: null == lastReadAt
          ? _value._lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as Map<String, DateTime>,
      typingUserIds: null == typingUserIds
          ? _value._typingUserIds
          : typingUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      typingUpdatedAt: null == typingUpdatedAt
          ? _value._typingUpdatedAt
          : typingUpdatedAt // ignore: cast_nullable_to_non_nullable
              as Map<String, DateTime>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ConversationEntityImpl extends _ConversationEntity {
  const _$ConversationEntityImpl(
      {required this.id,
      required final List<String> participantIds,
      required final Map<String, String> participantNames,
      final Map<String, String?> participantPhotoUrls =
          const <String, String?>{},
      this.contextOpportunityId,
      this.contextOpportunityTitle,
      this.lastMessageText,
      this.lastMessageSenderId,
      this.lastMessageAt,
      final Map<String, DateTime> lastReadAt = const <String, DateTime>{},
      final List<String> typingUserIds = const <String>[],
      final Map<String, DateTime> typingUpdatedAt = const <String, DateTime>{},
      required this.createdAt})
      : _participantIds = participantIds,
        _participantNames = participantNames,
        _participantPhotoUrls = participantPhotoUrls,
        _lastReadAt = lastReadAt,
        _typingUserIds = typingUserIds,
        _typingUpdatedAt = typingUpdatedAt,
        super._();

  @override
  final String id;
  final List<String> _participantIds;
  @override
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  final Map<String, String> _participantNames;
  @override
  Map<String, String> get participantNames {
    if (_participantNames is EqualUnmodifiableMapView) return _participantNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_participantNames);
  }

  final Map<String, String?> _participantPhotoUrls;
  @override
  @JsonKey()
  Map<String, String?> get participantPhotoUrls {
    if (_participantPhotoUrls is EqualUnmodifiableMapView)
      return _participantPhotoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_participantPhotoUrls);
  }

  @override
  final String? contextOpportunityId;
  @override
  final String? contextOpportunityTitle;
  @override
  final String? lastMessageText;
  @override
  final String? lastMessageSenderId;
  @override
  final DateTime? lastMessageAt;
  final Map<String, DateTime> _lastReadAt;
  @override
  @JsonKey()
  Map<String, DateTime> get lastReadAt {
    if (_lastReadAt is EqualUnmodifiableMapView) return _lastReadAt;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_lastReadAt);
  }

  final List<String> _typingUserIds;
  @override
  @JsonKey()
  List<String> get typingUserIds {
    if (_typingUserIds is EqualUnmodifiableListView) return _typingUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_typingUserIds);
  }

  final Map<String, DateTime> _typingUpdatedAt;
  @override
  @JsonKey()
  Map<String, DateTime> get typingUpdatedAt {
    if (_typingUpdatedAt is EqualUnmodifiableMapView) return _typingUpdatedAt;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_typingUpdatedAt);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ConversationEntity(id: $id, participantIds: $participantIds, participantNames: $participantNames, participantPhotoUrls: $participantPhotoUrls, contextOpportunityId: $contextOpportunityId, contextOpportunityTitle: $contextOpportunityTitle, lastMessageText: $lastMessageText, lastMessageSenderId: $lastMessageSenderId, lastMessageAt: $lastMessageAt, lastReadAt: $lastReadAt, typingUserIds: $typingUserIds, typingUpdatedAt: $typingUpdatedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._participantIds, _participantIds) &&
            const DeepCollectionEquality()
                .equals(other._participantNames, _participantNames) &&
            const DeepCollectionEquality()
                .equals(other._participantPhotoUrls, _participantPhotoUrls) &&
            (identical(other.contextOpportunityId, contextOpportunityId) ||
                other.contextOpportunityId == contextOpportunityId) &&
            (identical(
                    other.contextOpportunityTitle, contextOpportunityTitle) ||
                other.contextOpportunityTitle == contextOpportunityTitle) &&
            (identical(other.lastMessageText, lastMessageText) ||
                other.lastMessageText == lastMessageText) &&
            (identical(other.lastMessageSenderId, lastMessageSenderId) ||
                other.lastMessageSenderId == lastMessageSenderId) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            const DeepCollectionEquality()
                .equals(other._lastReadAt, _lastReadAt) &&
            const DeepCollectionEquality()
                .equals(other._typingUserIds, _typingUserIds) &&
            const DeepCollectionEquality()
                .equals(other._typingUpdatedAt, _typingUpdatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_participantIds),
      const DeepCollectionEquality().hash(_participantNames),
      const DeepCollectionEquality().hash(_participantPhotoUrls),
      contextOpportunityId,
      contextOpportunityTitle,
      lastMessageText,
      lastMessageSenderId,
      lastMessageAt,
      const DeepCollectionEquality().hash(_lastReadAt),
      const DeepCollectionEquality().hash(_typingUserIds),
      const DeepCollectionEquality().hash(_typingUpdatedAt),
      createdAt);

  /// Create a copy of ConversationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationEntityImplCopyWith<_$ConversationEntityImpl> get copyWith =>
      __$$ConversationEntityImplCopyWithImpl<_$ConversationEntityImpl>(
          this, _$identity);
}

abstract class _ConversationEntity extends ConversationEntity {
  const factory _ConversationEntity(
      {required final String id,
      required final List<String> participantIds,
      required final Map<String, String> participantNames,
      final Map<String, String?> participantPhotoUrls,
      final String? contextOpportunityId,
      final String? contextOpportunityTitle,
      final String? lastMessageText,
      final String? lastMessageSenderId,
      final DateTime? lastMessageAt,
      final Map<String, DateTime> lastReadAt,
      final List<String> typingUserIds,
      final Map<String, DateTime> typingUpdatedAt,
      required final DateTime createdAt}) = _$ConversationEntityImpl;
  const _ConversationEntity._() : super._();

  @override
  String get id;
  @override
  List<String> get participantIds;
  @override
  Map<String, String> get participantNames;
  @override
  Map<String, String?> get participantPhotoUrls;
  @override
  String? get contextOpportunityId;
  @override
  String? get contextOpportunityTitle;
  @override
  String? get lastMessageText;
  @override
  String? get lastMessageSenderId;
  @override
  DateTime? get lastMessageAt;
  @override
  Map<String, DateTime> get lastReadAt;
  @override
  List<String> get typingUserIds;
  @override
  Map<String, DateTime> get typingUpdatedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of ConversationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationEntityImplCopyWith<_$ConversationEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
