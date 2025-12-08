// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalProfile _$ProfessionalProfileFromJson(Map<String, dynamic> json) =>
    ProfessionalProfile(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      licenseNumber: json['license_number'] as String,
      specialties: (json['specialties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bio: json['bio'] as String,
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      verificationStatus: json['verification_status'] as String,
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
      'verification_status': instance.verificationStatus,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
