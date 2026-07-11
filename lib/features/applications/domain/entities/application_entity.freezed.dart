// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ApplicationStatusEvent {
  ApplicationStatus get status => throw _privateConstructorUsedError;
  DateTime get changedAt => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationStatusEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationStatusEventCopyWith<ApplicationStatusEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationStatusEventCopyWith<$Res> {
  factory $ApplicationStatusEventCopyWith(ApplicationStatusEvent value,
          $Res Function(ApplicationStatusEvent) then) =
      _$ApplicationStatusEventCopyWithImpl<$Res, ApplicationStatusEvent>;
  @useResult
  $Res call({ApplicationStatus status, DateTime changedAt, String? note});
}

/// @nodoc
class _$ApplicationStatusEventCopyWithImpl<$Res,
        $Val extends ApplicationStatusEvent>
    implements $ApplicationStatusEventCopyWith<$Res> {
  _$ApplicationStatusEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationStatusEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? changedAt = null,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      changedAt: null == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApplicationStatusEventImplCopyWith<$Res>
    implements $ApplicationStatusEventCopyWith<$Res> {
  factory _$$ApplicationStatusEventImplCopyWith(
          _$ApplicationStatusEventImpl value,
          $Res Function(_$ApplicationStatusEventImpl) then) =
      __$$ApplicationStatusEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ApplicationStatus status, DateTime changedAt, String? note});
}

/// @nodoc
class __$$ApplicationStatusEventImplCopyWithImpl<$Res>
    extends _$ApplicationStatusEventCopyWithImpl<$Res,
        _$ApplicationStatusEventImpl>
    implements _$$ApplicationStatusEventImplCopyWith<$Res> {
  __$$ApplicationStatusEventImplCopyWithImpl(
      _$ApplicationStatusEventImpl _value,
      $Res Function(_$ApplicationStatusEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApplicationStatusEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? changedAt = null,
    Object? note = freezed,
  }) {
    return _then(_$ApplicationStatusEventImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      changedAt: null == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ApplicationStatusEventImpl implements _ApplicationStatusEvent {
  const _$ApplicationStatusEventImpl(
      {required this.status, required this.changedAt, this.note});

  @override
  final ApplicationStatus status;
  @override
  final DateTime changedAt;
  @override
  final String? note;

  @override
  String toString() {
    return 'ApplicationStatusEvent(status: $status, changedAt: $changedAt, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationStatusEventImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, changedAt, note);

  /// Create a copy of ApplicationStatusEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationStatusEventImplCopyWith<_$ApplicationStatusEventImpl>
      get copyWith => __$$ApplicationStatusEventImplCopyWithImpl<
          _$ApplicationStatusEventImpl>(this, _$identity);
}

abstract class _ApplicationStatusEvent implements ApplicationStatusEvent {
  const factory _ApplicationStatusEvent(
      {required final ApplicationStatus status,
      required final DateTime changedAt,
      final String? note}) = _$ApplicationStatusEventImpl;

  @override
  ApplicationStatus get status;
  @override
  DateTime get changedAt;
  @override
  String? get note;

  /// Create a copy of ApplicationStatusEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationStatusEventImplCopyWith<_$ApplicationStatusEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ApplicationEntity {
  String get id => throw _privateConstructorUsedError;
  String get opportunityId => throw _privateConstructorUsedError;
  String get opportunityTitle => throw _privateConstructorUsedError;
  String get startupId => throw _privateConstructorUsedError;
  String get startupName => throw _privateConstructorUsedError;
  String get applicantId => throw _privateConstructorUsedError;
  String get applicantName => throw _privateConstructorUsedError;
  String get coverLetter => throw _privateConstructorUsedError;
  ApplicationStatus get status => throw _privateConstructorUsedError;
  DateTime get appliedAt => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  String? get reviewNote => throw _privateConstructorUsedError;
  List<ApplicationStatusEvent> get statusHistory =>
      throw _privateConstructorUsedError;
  DateTime? get interviewScheduledAt => throw _privateConstructorUsedError;
  String? get interviewLocation => throw _privateConstructorUsedError;
  String? get interviewNotes => throw _privateConstructorUsedError;
  String? get offerNote => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationEntityCopyWith<ApplicationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationEntityCopyWith<$Res> {
  factory $ApplicationEntityCopyWith(
          ApplicationEntity value, $Res Function(ApplicationEntity) then) =
      _$ApplicationEntityCopyWithImpl<$Res, ApplicationEntity>;
  @useResult
  $Res call(
      {String id,
      String opportunityId,
      String opportunityTitle,
      String startupId,
      String startupName,
      String applicantId,
      String applicantName,
      String coverLetter,
      ApplicationStatus status,
      DateTime appliedAt,
      DateTime? reviewedAt,
      String? reviewNote,
      List<ApplicationStatusEvent> statusHistory,
      DateTime? interviewScheduledAt,
      String? interviewLocation,
      String? interviewNotes,
      String? offerNote});
}

/// @nodoc
class _$ApplicationEntityCopyWithImpl<$Res, $Val extends ApplicationEntity>
    implements $ApplicationEntityCopyWith<$Res> {
  _$ApplicationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? opportunityId = null,
    Object? opportunityTitle = null,
    Object? startupId = null,
    Object? startupName = null,
    Object? applicantId = null,
    Object? applicantName = null,
    Object? coverLetter = null,
    Object? status = null,
    Object? appliedAt = null,
    Object? reviewedAt = freezed,
    Object? reviewNote = freezed,
    Object? statusHistory = null,
    Object? interviewScheduledAt = freezed,
    Object? interviewLocation = freezed,
    Object? interviewNotes = freezed,
    Object? offerNote = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      opportunityId: null == opportunityId
          ? _value.opportunityId
          : opportunityId // ignore: cast_nullable_to_non_nullable
              as String,
      opportunityTitle: null == opportunityTitle
          ? _value.opportunityTitle
          : opportunityTitle // ignore: cast_nullable_to_non_nullable
              as String,
      startupId: null == startupId
          ? _value.startupId
          : startupId // ignore: cast_nullable_to_non_nullable
              as String,
      startupName: null == startupName
          ? _value.startupName
          : startupName // ignore: cast_nullable_to_non_nullable
              as String,
      applicantId: null == applicantId
          ? _value.applicantId
          : applicantId // ignore: cast_nullable_to_non_nullable
              as String,
      applicantName: null == applicantName
          ? _value.applicantName
          : applicantName // ignore: cast_nullable_to_non_nullable
              as String,
      coverLetter: null == coverLetter
          ? _value.coverLetter
          : coverLetter // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      appliedAt: null == appliedAt
          ? _value.appliedAt
          : appliedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewNote: freezed == reviewNote
          ? _value.reviewNote
          : reviewNote // ignore: cast_nullable_to_non_nullable
              as String?,
      statusHistory: null == statusHistory
          ? _value.statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<ApplicationStatusEvent>,
      interviewScheduledAt: freezed == interviewScheduledAt
          ? _value.interviewScheduledAt
          : interviewScheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      interviewLocation: freezed == interviewLocation
          ? _value.interviewLocation
          : interviewLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      interviewNotes: freezed == interviewNotes
          ? _value.interviewNotes
          : interviewNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      offerNote: freezed == offerNote
          ? _value.offerNote
          : offerNote // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApplicationEntityImplCopyWith<$Res>
    implements $ApplicationEntityCopyWith<$Res> {
  factory _$$ApplicationEntityImplCopyWith(_$ApplicationEntityImpl value,
          $Res Function(_$ApplicationEntityImpl) then) =
      __$$ApplicationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String opportunityId,
      String opportunityTitle,
      String startupId,
      String startupName,
      String applicantId,
      String applicantName,
      String coverLetter,
      ApplicationStatus status,
      DateTime appliedAt,
      DateTime? reviewedAt,
      String? reviewNote,
      List<ApplicationStatusEvent> statusHistory,
      DateTime? interviewScheduledAt,
      String? interviewLocation,
      String? interviewNotes,
      String? offerNote});
}

/// @nodoc
class __$$ApplicationEntityImplCopyWithImpl<$Res>
    extends _$ApplicationEntityCopyWithImpl<$Res, _$ApplicationEntityImpl>
    implements _$$ApplicationEntityImplCopyWith<$Res> {
  __$$ApplicationEntityImplCopyWithImpl(_$ApplicationEntityImpl _value,
      $Res Function(_$ApplicationEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApplicationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? opportunityId = null,
    Object? opportunityTitle = null,
    Object? startupId = null,
    Object? startupName = null,
    Object? applicantId = null,
    Object? applicantName = null,
    Object? coverLetter = null,
    Object? status = null,
    Object? appliedAt = null,
    Object? reviewedAt = freezed,
    Object? reviewNote = freezed,
    Object? statusHistory = null,
    Object? interviewScheduledAt = freezed,
    Object? interviewLocation = freezed,
    Object? interviewNotes = freezed,
    Object? offerNote = freezed,
  }) {
    return _then(_$ApplicationEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      opportunityId: null == opportunityId
          ? _value.opportunityId
          : opportunityId // ignore: cast_nullable_to_non_nullable
              as String,
      opportunityTitle: null == opportunityTitle
          ? _value.opportunityTitle
          : opportunityTitle // ignore: cast_nullable_to_non_nullable
              as String,
      startupId: null == startupId
          ? _value.startupId
          : startupId // ignore: cast_nullable_to_non_nullable
              as String,
      startupName: null == startupName
          ? _value.startupName
          : startupName // ignore: cast_nullable_to_non_nullable
              as String,
      applicantId: null == applicantId
          ? _value.applicantId
          : applicantId // ignore: cast_nullable_to_non_nullable
              as String,
      applicantName: null == applicantName
          ? _value.applicantName
          : applicantName // ignore: cast_nullable_to_non_nullable
              as String,
      coverLetter: null == coverLetter
          ? _value.coverLetter
          : coverLetter // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      appliedAt: null == appliedAt
          ? _value.appliedAt
          : appliedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewNote: freezed == reviewNote
          ? _value.reviewNote
          : reviewNote // ignore: cast_nullable_to_non_nullable
              as String?,
      statusHistory: null == statusHistory
          ? _value._statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<ApplicationStatusEvent>,
      interviewScheduledAt: freezed == interviewScheduledAt
          ? _value.interviewScheduledAt
          : interviewScheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      interviewLocation: freezed == interviewLocation
          ? _value.interviewLocation
          : interviewLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      interviewNotes: freezed == interviewNotes
          ? _value.interviewNotes
          : interviewNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      offerNote: freezed == offerNote
          ? _value.offerNote
          : offerNote // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ApplicationEntityImpl extends _ApplicationEntity {
  const _$ApplicationEntityImpl(
      {required this.id,
      required this.opportunityId,
      required this.opportunityTitle,
      required this.startupId,
      required this.startupName,
      required this.applicantId,
      required this.applicantName,
      required this.coverLetter,
      required this.status,
      required this.appliedAt,
      this.reviewedAt,
      this.reviewNote,
      final List<ApplicationStatusEvent> statusHistory =
          const <ApplicationStatusEvent>[],
      this.interviewScheduledAt,
      this.interviewLocation,
      this.interviewNotes,
      this.offerNote})
      : _statusHistory = statusHistory,
        super._();

  @override
  final String id;
  @override
  final String opportunityId;
  @override
  final String opportunityTitle;
  @override
  final String startupId;
  @override
  final String startupName;
  @override
  final String applicantId;
  @override
  final String applicantName;
  @override
  final String coverLetter;
  @override
  final ApplicationStatus status;
  @override
  final DateTime appliedAt;
  @override
  final DateTime? reviewedAt;
  @override
  final String? reviewNote;
  final List<ApplicationStatusEvent> _statusHistory;
  @override
  @JsonKey()
  List<ApplicationStatusEvent> get statusHistory {
    if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusHistory);
  }

  @override
  final DateTime? interviewScheduledAt;
  @override
  final String? interviewLocation;
  @override
  final String? interviewNotes;
  @override
  final String? offerNote;

  @override
  String toString() {
    return 'ApplicationEntity(id: $id, opportunityId: $opportunityId, opportunityTitle: $opportunityTitle, startupId: $startupId, startupName: $startupName, applicantId: $applicantId, applicantName: $applicantName, coverLetter: $coverLetter, status: $status, appliedAt: $appliedAt, reviewedAt: $reviewedAt, reviewNote: $reviewNote, statusHistory: $statusHistory, interviewScheduledAt: $interviewScheduledAt, interviewLocation: $interviewLocation, interviewNotes: $interviewNotes, offerNote: $offerNote)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.opportunityId, opportunityId) ||
                other.opportunityId == opportunityId) &&
            (identical(other.opportunityTitle, opportunityTitle) ||
                other.opportunityTitle == opportunityTitle) &&
            (identical(other.startupId, startupId) ||
                other.startupId == startupId) &&
            (identical(other.startupName, startupName) ||
                other.startupName == startupName) &&
            (identical(other.applicantId, applicantId) ||
                other.applicantId == applicantId) &&
            (identical(other.applicantName, applicantName) ||
                other.applicantName == applicantName) &&
            (identical(other.coverLetter, coverLetter) ||
                other.coverLetter == coverLetter) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.reviewNote, reviewNote) ||
                other.reviewNote == reviewNote) &&
            const DeepCollectionEquality()
                .equals(other._statusHistory, _statusHistory) &&
            (identical(other.interviewScheduledAt, interviewScheduledAt) ||
                other.interviewScheduledAt == interviewScheduledAt) &&
            (identical(other.interviewLocation, interviewLocation) ||
                other.interviewLocation == interviewLocation) &&
            (identical(other.interviewNotes, interviewNotes) ||
                other.interviewNotes == interviewNotes) &&
            (identical(other.offerNote, offerNote) ||
                other.offerNote == offerNote));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      opportunityId,
      opportunityTitle,
      startupId,
      startupName,
      applicantId,
      applicantName,
      coverLetter,
      status,
      appliedAt,
      reviewedAt,
      reviewNote,
      const DeepCollectionEquality().hash(_statusHistory),
      interviewScheduledAt,
      interviewLocation,
      interviewNotes,
      offerNote);

  /// Create a copy of ApplicationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationEntityImplCopyWith<_$ApplicationEntityImpl> get copyWith =>
      __$$ApplicationEntityImplCopyWithImpl<_$ApplicationEntityImpl>(
          this, _$identity);
}

abstract class _ApplicationEntity extends ApplicationEntity {
  const factory _ApplicationEntity(
      {required final String id,
      required final String opportunityId,
      required final String opportunityTitle,
      required final String startupId,
      required final String startupName,
      required final String applicantId,
      required final String applicantName,
      required final String coverLetter,
      required final ApplicationStatus status,
      required final DateTime appliedAt,
      final DateTime? reviewedAt,
      final String? reviewNote,
      final List<ApplicationStatusEvent> statusHistory,
      final DateTime? interviewScheduledAt,
      final String? interviewLocation,
      final String? interviewNotes,
      final String? offerNote}) = _$ApplicationEntityImpl;
  const _ApplicationEntity._() : super._();

  @override
  String get id;
  @override
  String get opportunityId;
  @override
  String get opportunityTitle;
  @override
  String get startupId;
  @override
  String get startupName;
  @override
  String get applicantId;
  @override
  String get applicantName;
  @override
  String get coverLetter;
  @override
  ApplicationStatus get status;
  @override
  DateTime get appliedAt;
  @override
  DateTime? get reviewedAt;
  @override
  String? get reviewNote;
  @override
  List<ApplicationStatusEvent> get statusHistory;
  @override
  DateTime? get interviewScheduledAt;
  @override
  String? get interviewLocation;
  @override
  String? get interviewNotes;
  @override
  String? get offerNote;

  /// Create a copy of ApplicationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationEntityImplCopyWith<_$ApplicationEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
