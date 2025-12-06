// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationLogResponse _$ModerationLogResponseFromJson(
        Map<String, dynamic> json) =>
    ModerationLogResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ModerationLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ModerationLogMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ModerationLogResponseToJson(
        ModerationLogResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'meta': instance.meta.toJson(),
    };

ModerationLogMeta _$ModerationLogMetaFromJson(Map<String, dynamic> json) =>
    ModerationLogMeta(
      currentPage: (json['current_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$ModerationLogMetaToJson(ModerationLogMeta instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };

ModerationLog _$ModerationLogFromJson(Map<String, dynamic> json) =>
    ModerationLog(
      id: (json['id'] as num).toInt(),
      action: json['action'] as String,
      entity:
          ModerationLogEntity.fromJson(json['entity'] as Map<String, dynamic>),
      previousStatus: json['previous_status'] as String?,
      newStatus: json['new_status'] as String?,
      reason: json['reason'] as String?,
      oldValues: _mapFromJson(json['old_values']),
      newValues: _mapFromJson(json['new_values']),
      meta: _mapFromJson(json['meta']),
      performedBy: json['performed_by'] == null
          ? null
          : ModerationLogUser.fromJson(
              json['performed_by'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ModerationLogToJson(ModerationLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entity': instance.entity.toJson(),
      'action': instance.action,
      'previous_status': instance.previousStatus,
      'new_status': instance.newStatus,
      'reason': instance.reason,
      'old_values': instance.oldValues,
      'new_values': instance.newValues,
      'meta': instance.meta,
      'performed_by': instance.performedBy?.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
    };

ModerationLogEntity _$ModerationLogEntityFromJson(Map<String, dynamic> json) =>
    ModerationLogEntity(
      type: json['type'] as String,
      internalId: (json['internal_id'] as num?)?.toInt(),
      publicId: json['public_id'] as String?,
    );

Map<String, dynamic> _$ModerationLogEntityToJson(
        ModerationLogEntity instance) =>
    <String, dynamic>{
      'type': instance.type,
      'internal_id': instance.internalId,
      'public_id': instance.publicId,
    };

ModerationLogUser _$ModerationLogUserFromJson(Map<String, dynamic> json) =>
    ModerationLogUser(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      preferredRole: json['preferred_role'] as String?,
    );

Map<String, dynamic> _$ModerationLogUserToJson(ModerationLogUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'preferred_role': instance.preferredRole,
    };
