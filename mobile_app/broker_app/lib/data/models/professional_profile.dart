import 'package:json_annotation/json_annotation.dart';
import 'professional_portfolio.dart';

part 'professional_profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProfessionalProfile {
  final int id;
  final int userId;
  final String? licenseNumber;
  final List<String>? specialties;
  final String? bio;
  final double? hourlyRate;
  final int? experienceYears;
  final List<String>? languages;
  @JsonKey(fromJson: _parseListMap)
  final List<Map<String, dynamic>>? education;
  @JsonKey(fromJson: _parseListMap)
  final List<Map<String, dynamic>>? certifications;
  final Map<String, dynamic>? socialLinks;
  final String verificationStatus;
  final bool isAvailable;
  final List<ProfessionalPortfolio>? portfolios;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfessionalProfile({
    required this.id,
    required this.userId,
    this.licenseNumber,
    this.specialties,
    this.bio,
    this.hourlyRate,
    this.experienceYears,
    this.languages,
    this.education,
    this.certifications,
    this.socialLinks,
    required this.verificationStatus,
    this.isAvailable = true,
    this.portfolios,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfessionalProfile.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfessionalProfileToJson(this);
}

List<Map<String, dynamic>>? _parseListMap(Object? json) {
  if (json == null) return null;
  if (json is List) {
    return json.map((e) {
      if (e is Map) {
        return Map<String, dynamic>.from(e);
      }
      // Handle case where data is wrapped in a list [[{...}]]
      if (e is List && e.isNotEmpty && e.first is Map) {
        return Map<String, dynamic>.from(e.first);
      }
      return <String, dynamic>{};
    }).toList();
  }
  return null;
}
