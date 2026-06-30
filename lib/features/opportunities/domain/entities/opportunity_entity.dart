import 'package:equatable/equatable.dart';

enum OpportunityType { internship, partTime, fullTime, contract, volunteer }

enum OpportunityCategory { engineering, design, marketing, business, research, other }

class OpportunityEntity extends Equatable {
  const OpportunityEntity({
    required this.id,
    required this.startupId,
    required this.startupName,
    this.startupLogoUrl,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.requiredSkills,
    required this.location,
    this.isRemote = false,
    required this.deadline,
    this.compensation,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  final String id;
  final String startupId;
  final String startupName;
  final String? startupLogoUrl;
  final String title;
  final String description;
  final OpportunityType type;
  final OpportunityCategory category;
  final List<String> requiredSkills;
  final String location;
  final bool isRemote;
  final DateTime deadline;
  final String? compensation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  bool get isExpired => deadline.isBefore(DateTime.now());

  @override
  List<Object?> get props => [
        id, startupId, startupName, startupLogoUrl, title, description,
        type, category, requiredSkills, location, isRemote, deadline,
        compensation, createdAt, updatedAt, isActive,
      ];
}

class OpportunityFilter {
  const OpportunityFilter({
    this.query,
    this.type,
    this.category,
    this.isRemote,
  });

  final String? query;
  final OpportunityType? type;
  final OpportunityCategory? category;
  final bool? isRemote;

  bool get hasActiveFilters =>
      query != null || type != null || category != null || isRemote != null;

  OpportunityFilter copyWith({
    String? query,
    OpportunityType? type,
    OpportunityCategory? category,
    bool? isRemote,
  }) {
    return OpportunityFilter(
      query: query ?? this.query,
      type: type ?? this.type,
      category: category ?? this.category,
      isRemote: isRemote ?? this.isRemote,
    );
  }

  OpportunityFilter clear() => const OpportunityFilter();
}
