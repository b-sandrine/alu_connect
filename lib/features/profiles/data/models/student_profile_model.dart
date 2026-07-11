import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/student_profile_entity.dart';

class StudentProfileModel {
  const StudentProfileModel({
    required this.id,
    required this.ownerId,
    this.photoUrl,
    required this.university,
    required this.degree,
    required this.yearOfStudy,
    required this.location,
    required this.bio,
    this.careerInterests = '',
    this.personalStatement = '',
    this.skills = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String ownerId;
  final String? photoUrl;
  final String university;
  final String degree;
  final String yearOfStudy;
  final String location;
  final String bio;
  final String careerInterests;
  final String personalStatement;
  final List<String> skills;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory StudentProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentProfileModel(
      id: doc.id,
      ownerId: data['ownerId'] as String,
      photoUrl: data['photoUrl'] as String?,
      university: data['university'] as String,
      degree: data['degree'] as String,
      yearOfStudy: data['yearOfStudy'] as String,
      location: data['location'] as String,
      bio: data['bio'] as String,
      careerInterests: data['careerInterests'] as String? ?? '',
      personalStatement: data['personalStatement'] as String? ?? '',
      skills: List<String>.from(data['skills'] as List? ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory StudentProfileModel.fromEntity(StudentProfileEntity e) {
    return StudentProfileModel(
      id: e.id,
      ownerId: e.ownerId,
      photoUrl: e.photoUrl,
      university: e.university,
      degree: e.degree,
      yearOfStudy: e.yearOfStudy,
      location: e.location,
      bio: e.bio,
      careerInterests: e.careerInterests,
      personalStatement: e.personalStatement,
      skills: e.skills,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'photoUrl': photoUrl,
      'university': university,
      'degree': degree,
      'yearOfStudy': yearOfStudy,
      'location': location,
      'bio': bio,
      'careerInterests': careerInterests,
      'personalStatement': personalStatement,
      'skills': skills,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  StudentProfileEntity toEntity() {
    return StudentProfileEntity(
      id: id,
      ownerId: ownerId,
      photoUrl: photoUrl,
      university: university,
      degree: degree,
      yearOfStudy: yearOfStudy,
      location: location,
      bio: bio,
      careerInterests: careerInterests,
      personalStatement: personalStatement,
      skills: skills,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
