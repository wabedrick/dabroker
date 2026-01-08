// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      countryCode: json['country_code'] as String?,
      preferredRole: json['preferred_role'] as String,
      status: json['status'] as String,
      bio: json['bio'] as String?,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      phoneVerifiedAt: json['phone_verified_at'] == null
          ? null
          : DateTime.parse(json['phone_verified_at'] as String),
      lastLoginAt: json['last_login_at'] == null
          ? null
          : DateTime.parse(json['last_login_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      professionalProfile: json['professional_profile'] == null
          ? null
          : ProfessionalProfile.fromJson(
              json['professional_profile'] as Map<String, dynamic>),
      avatar: json['avatar'] as String?,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      ratingsCount: (json['ratings_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'country_code': instance.countryCode,
      'preferred_role': instance.preferredRole,
      'status': instance.status,
      'bio': instance.bio,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'phone_verified_at': instance.phoneVerifiedAt?.toIso8601String(),
      'last_login_at': instance.lastLoginAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'roles': instance.roles,
      'permissions': instance.permissions,
      'professional_profile': instance.professionalProfile,
      'avatar': instance.avatar,
      'average_rating': instance.averageRating,
      'ratings_count': instance.ratingsCount,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      message: json['message'] as String,
      token: json['token'] as String?,
      tokenType: json['token_type'] as String?,
      data: User.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'token': instance.token,
      'token_type': instance.tokenType,
      'data': instance.data.toJson(),
    };
