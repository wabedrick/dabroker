import 'package:json_annotation/json_annotation.dart';

part 'moderation_log.g.dart';

@JsonSerializable(explicitToJson: true)
class ModerationLogResponse {
  ModerationLogResponse({required this.data, required this.meta});

  factory ModerationLogResponse.fromJson(Map<String, dynamic> json) =>
      _$ModerationLogResponseFromJson(json);

  final List<ModerationLog> data;
  final ModerationLogMeta meta;

  Map<String, dynamic> toJson() => _$ModerationLogResponseToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ModerationLogMeta {
  ModerationLogMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ModerationLogMeta.fromJson(Map<String, dynamic> json) =>
      _$ModerationLogMetaFromJson(json);

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  bool get hasMore => currentPage < lastPage;

  Map<String, dynamic> toJson() => _$ModerationLogMetaToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ModerationLog {
  ModerationLog({
    required this.id,
    required this.action,
    required this.entity,
    required this.previousStatus,
    required this.newStatus,
    required this.reason,
    required this.oldValues,
    required this.newValues,
    required this.meta,
    required this.performedBy,
    required this.createdAt,
  });

  factory ModerationLog.fromJson(Map<String, dynamic> json) =>
      _$ModerationLogFromJson(json);

  final int id;
  final ModerationLogEntity entity;
  final String action;
  final String? previousStatus;
  final String? newStatus;
  final String? reason;
  @JsonKey(fromJson: _mapFromJson)
  final Map<String, dynamic> oldValues;
  @JsonKey(fromJson: _mapFromJson)
  final Map<String, dynamic> newValues;
  @JsonKey(fromJson: _mapFromJson)
  final Map<String, dynamic> meta;
  final ModerationLogUser? performedBy;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$ModerationLogToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ModerationLogEntity {
  ModerationLogEntity({
    required this.type,
    required this.internalId,
    required this.publicId,
  });

  factory ModerationLogEntity.fromJson(Map<String, dynamic> json) =>
      _$ModerationLogEntityFromJson(json);

  final String type;
  final int? internalId;
  final String? publicId;

  Map<String, dynamic> toJson() => _$ModerationLogEntityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ModerationLogUser {
  ModerationLogUser({this.id, this.name, this.preferredRole});

  factory ModerationLogUser.fromJson(Map<String, dynamic> json) =>
      _$ModerationLogUserFromJson(json);

  final int? id;
  final String? name;
  final String? preferredRole;

  Map<String, dynamic> toJson() => _$ModerationLogUserToJson(this);
}

Map<String, dynamic> _mapFromJson(Object? json) {
  if (json is Map<String, dynamic>) {
    return json;
  }
  return {};
}
