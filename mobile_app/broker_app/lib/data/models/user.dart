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
  });

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

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
