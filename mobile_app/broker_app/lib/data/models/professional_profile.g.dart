// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalProfile _$ProfessionalProfileFromJson(Map<String, dynamic> json) =>
    ProfessionalProfile(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      licenseNumber: json['license_number'] as String?,
      specialties: (json['specialties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bio: json['bio'] as String?,
      hourlyRate: (json['hourly_rate'] as num?)?.toDouble(),
      experienceYears: (json['experience_years'] as num?)?.toInt(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      education: _parseListMap(json['education']),
      certifications: _parseListMap(json['certifications']),
      socialLinks: json['social_links'] as Map<String, dynamic>?,
      verificationStatus: json['verification_status'] as String,
      isAvailable: json['is_available'] as bool? ?? true,
      portfolios: (json['portfolios'] as List<dynamic>?)
          ?.map(
              (e) => ProfessionalPortfolio.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ProfessionalProfileToJson(
        ProfessionalProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'license_number': instance.licenseNumber,
      'specialties': instance.specialties,
      'bio': instance.bio,
      'hourly_rate': instance.hourlyRate,
      'experience_years': instance.experienceYears,
      'languages': instance.languages,
      'education': instance.education,
      'certifications': instance.certifications,
      'social_links': instance.socialLinks,
      'verification_status': instance.verificationStatus,
      'is_available': instance.isAvailable,
      'portfolios': instance.portfolios,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
