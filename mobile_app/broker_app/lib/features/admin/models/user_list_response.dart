import 'package:broker_app/data/models/user.dart';
import 'package:broker_app/features/admin/models/moderation_log.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_list_response.g.dart';

@JsonSerializable(explicitToJson: true)
class UserListResponse {
  UserListResponse({required this.data, required this.meta});

  factory UserListResponse.fromJson(Map<String, dynamic> json) =>
      _$UserListResponseFromJson(json);

  final List<User> data;
  final ModerationLogMeta meta;

  Map<String, dynamic> toJson() => _$UserListResponseToJson(this);
}
