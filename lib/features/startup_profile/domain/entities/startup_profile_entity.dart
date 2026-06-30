import 'package:equatable/equatable.dart';

class StartupProfileEntity extends Equatable {
  const StartupProfileEntity({
    required this.id,
    required this.ownerId,
    required this.companyName,
    required this.tagline,
    required this.description,
    required this.industry,
    required this.location,
    this.website,
    this.logoUrl,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String ownerId;
  final String companyName;
  final String tagline;
  final String description;
  final String industry;
  final String location;
  final String? website;
  final String? logoUrl;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
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
        createdAt,
        updatedAt,
      ];
}
