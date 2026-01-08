import 'package:broker_app/data/models/professional_profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? countryCode;
  final String preferredRole;
  final String status;
  final String? bio;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> roles;
  final List<String> permissions;
  final ProfessionalProfile? professionalProfile;
  final String? avatar;
  final double averageRating;
  final int ratingsCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.countryCode,
    required this.preferredRole,
    required this.status,
    this.bio,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.roles = const [],
    this.permissions = const [],
    this.professionalProfile,
    this.avatar,
    this.averageRating = 0.0,
    this.ratingsCount = 0,
  });

  String get formattedRole {
    return preferredRole
        .split('_')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AuthResponse {
  final String message;
  final String? token;
  final String? tokenType;
  final User data;

  AuthResponse({
    required this.message,
    this.token,
    this.tokenType,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Handle nested structure from login response where data contains user and token
    if (json['data'] is Map<String, dynamic> &&
        (json['data'] as Map<String, dynamic>).containsKey('user')) {
      final dataMap = json['data'] as Map<String, dynamic>;
      return AuthResponse(
        message: json['message'] as String,
        token: dataMap['token'] as String?,
        tokenType: dataMap['token_type'] as String?,
        data: User.fromJson(dataMap['user'] as Map<String, dynamic>),
      );
    }

    return _$AuthResponseFromJson(json);
  }
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
