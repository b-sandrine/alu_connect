import 'package:freezed_annotation/freezed_annotation.dart';

part 'opportunity_entity.freezed.dart';

enum OpportunityType { internship, partTime, fullTime, contract, volunteer }

enum OpportunityCategory { engineering, design, marketing, business, research, other }

@freezed
abstract class OpportunityEntity with _$OpportunityEntity {
  const OpportunityEntity._();

  const factory OpportunityEntity({
    required String id,
    required String startupId,
    required String startupName,
    String? startupLogoUrl,
    required String title,
    required String description,
    required OpportunityType type,
    required OpportunityCategory category,
    required List<String> requiredSkills,
    required String location,
    @Default(false) bool isRemote,
    required DateTime deadline,
    String? compensation,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isActive,
    @Default(0) int viewCount,
  }) = _OpportunityEntity;

  bool get isExpired => deadline.isBefore(DateTime.now());
}

@freezed
abstract class OpportunityFilter with _$OpportunityFilter {
  const OpportunityFilter._();

  const factory OpportunityFilter({
    String? query,
    OpportunityType? type,
    OpportunityCategory? category,
    bool? isRemote,
  }) = _OpportunityFilter;

  bool get hasActiveFilters =>
      query != null || type != null || category != null || isRemote != null;

  OpportunityFilter clear() => const OpportunityFilter();
}
