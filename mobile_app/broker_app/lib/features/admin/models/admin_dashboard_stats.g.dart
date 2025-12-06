// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminDashboardStats _$AdminDashboardStatsFromJson(Map<String, dynamic> json) =>
    AdminDashboardStats(
      users: AdminUserStats.fromJson(json['users'] as Map<String, dynamic>),
      properties: AdminPropertyStats.fromJson(
          json['properties'] as Map<String, dynamic>),
      lodgings:
          AdminLodgingStats.fromJson(json['lodgings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminDashboardStatsToJson(
        AdminDashboardStats instance) =>
    <String, dynamic>{
      'users': instance.users,
      'properties': instance.properties,
      'lodgings': instance.lodgings,
    };

AdminUserStats _$AdminUserStatsFromJson(Map<String, dynamic> json) =>
    AdminUserStats(
      total: (json['total'] as num).toInt(),
      newToday: (json['new_today'] as num).toInt(),
      brokers: (json['brokers'] as num).toInt(),
    );

Map<String, dynamic> _$AdminUserStatsToJson(AdminUserStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'new_today': instance.newToday,
      'brokers': instance.brokers,
    };

AdminPropertyStats _$AdminPropertyStatsFromJson(Map<String, dynamic> json) =>
    AdminPropertyStats(
      total: (json['total'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
      approved: (json['approved'] as num).toInt(),
      newToday: (json['new_today'] as num).toInt(),
    );

Map<String, dynamic> _$AdminPropertyStatsToJson(AdminPropertyStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'pending': instance.pending,
      'approved': instance.approved,
      'new_today': instance.newToday,
    };

AdminLodgingStats _$AdminLodgingStatsFromJson(Map<String, dynamic> json) =>
    AdminLodgingStats(
      total: (json['total'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
      approved: (json['approved'] as num).toInt(),
      newToday: (json['new_today'] as num).toInt(),
    );

Map<String, dynamic> _$AdminLodgingStatsToJson(AdminLodgingStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'pending': instance.pending,
      'approved': instance.approved,
      'new_today': instance.newToday,
    };
