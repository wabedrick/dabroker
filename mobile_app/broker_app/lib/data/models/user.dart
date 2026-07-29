import 'package:freezed_annotation/freezed_annotation.dart';


part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const User._(); 

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory User({
    required int id,
    required String name,
    String? email,
    String? phone,
    String? countryCode,
    required String preferredRole,
    required String status,
    String? bio,
    DateTime? emailVerifiedAt,
    DateTime? phoneVerifiedAt,
    DateTime? lastLoginAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<String> roles,
    @Default([]) List<String> permissions,

    String? avatar,
    @Default(0.0) double averageRating,
    @Default(0) int ratingsCount,
  }) = _User;

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
