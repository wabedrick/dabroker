// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminAnalytics _$AdminAnalyticsFromJson(Map<String, dynamic> json) =>
    AdminAnalytics(
      users: AnalyticsUsers.fromJson(json['users'] as Map<String, dynamic>),
      properties: AnalyticsProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      lodgings:
          AnalyticsLodgings.fromJson(json['lodgings'] as Map<String, dynamic>),
      moderation: AnalyticsModeration.fromJson(
          json['moderation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminAnalyticsToJson(AdminAnalytics instance) =>
    <String, dynamic>{
      'users': instance.users.toJson(),
      'properties': instance.properties.toJson(),
      'lodgings': instance.lodgings.toJson(),
      'moderation': instance.moderation.toJson(),
    };

AnalyticsUsers _$AnalyticsUsersFromJson(Map<String, dynamic> json) =>
    AnalyticsUsers(
      dailyNew: (json['daily_new'] as List<dynamic>)
          .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$AnalyticsUsersToJson(AnalyticsUsers instance) =>
    <String, dynamic>{
      'daily_new': instance.dailyNew.map((e) => e.toJson()).toList(),
      'total': instance.total,
    };

AnalyticsProperties _$AnalyticsPropertiesFromJson(Map<String, dynamic> json) =>
    AnalyticsProperties(
      dailyNew: (json['daily_new'] as List<dynamic>)
          .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyApproved: (json['daily_approved'] as List<dynamic>)
          .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      pending: (json['pending'] as num).toInt(),
    );

Map<String, dynamic> _$AnalyticsPropertiesToJson(
        AnalyticsProperties instance) =>
    <String, dynamic>{
      'daily_new': instance.dailyNew.map((e) => e.toJson()).toList(),
      'daily_approved': instance.dailyApproved.map((e) => e.toJson()).toList(),
      'pending': instance.pending,
    };

AnalyticsLodgings _$AnalyticsLodgingsFromJson(Map<String, dynamic> json) =>
    AnalyticsLodgings(
      dailyNew: (json['daily_new'] as List<dynamic>)
          .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyApproved: (json['daily_approved'] as List<dynamic>)
          .map((e) => TimeSeriesPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      pending: (json['pending'] as num).toInt(),
    );

Map<String, dynamic> _$AnalyticsLodgingsToJson(AnalyticsLodgings instance) =>
    <String, dynamic>{
      'daily_new': instance.dailyNew.map((e) => e.toJson()).toList(),
      'daily_approved': instance.dailyApproved.map((e) => e.toJson()).toList(),
      'pending': instance.pending,
    };

AnalyticsModeration _$AnalyticsModerationFromJson(Map<String, dynamic> json) =>
    AnalyticsModeration(
      topActions: (json['top_actions'] as List<dynamic>)
          .map((e) => TopModerationAction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnalyticsModerationToJson(
        AnalyticsModeration instance) =>
    <String, dynamic>{
      'top_actions': instance.topActions.map((e) => e.toJson()).toList(),
    };

TimeSeriesPoint _$TimeSeriesPointFromJson(Map<String, dynamic> json) =>
    TimeSeriesPoint(
      date: json['date'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$TimeSeriesPointToJson(TimeSeriesPoint instance) =>
    <String, dynamic>{
      'date': instance.date,
      'count': instance.count,
    };

TopModerationAction _$TopModerationActionFromJson(Map<String, dynamic> json) =>
    TopModerationAction(
      action: json['action'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$TopModerationActionToJson(
        TopModerationAction instance) =>
    <String, dynamic>{
      'action': instance.action,
      'count': instance.count,
    };
