// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Consultation _$ConsultationFromJson(Map<String, dynamic> json) => Consultation(
      id: (json['id'] as num).toInt(),
      publicId: json['public_id'] as String,
      userId: (json['user_id'] as num).toInt(),
      professionalId: (json['professional_id'] as num).toInt(),
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      professional: json['professional'] == null
          ? null
          : User.fromJson(json['professional'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ConsultationToJson(Consultation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'public_id': instance.publicId,
      'user_id': instance.userId,
      'professional_id': instance.professionalId,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
      'status': instance.status,
      'notes': instance.notes,
      'user': instance.user,
      'professional': instance.professional,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
