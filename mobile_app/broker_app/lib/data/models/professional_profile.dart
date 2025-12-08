import 'package:json_annotation/json_annotation.dart';

part 'professional_profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProfessionalProfile {
  final int id;
  final int userId;
  final String licenseNumber;
  final List<String>? specialties;
  final String bio;
  final double hourlyRate;
  final String verificationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfessionalProfile({
    required this.id,
    required this.userId,
    required this.licenseNumber,
    this.specialties,
    required this.bio,
    required this.hourlyRate,
    required this.verificationStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfessionalProfile.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfessionalProfileToJson(this);
}
