import 'package:json_annotation/json_annotation.dart';

part 'admin_dashboard_stats.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminDashboardStats {
  const AdminDashboardStats({
    required this.users,
    required this.properties,
    required this.lodgings,
  });

  final AdminUserStats users;
  final AdminPropertyStats properties;
  final AdminLodgingStats lodgings;

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardStatsFromJson(json);

  Map<String, dynamic> toJson() => _$AdminDashboardStatsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminUserStats {
  const AdminUserStats({
    required this.total,
    required this.newToday,
    required this.brokers,
  });

  final int total;
  final int newToday;
  final int brokers;

  factory AdminUserStats.fromJson(Map<String, dynamic> json) =>
      _$AdminUserStatsFromJson(json);

  Map<String, dynamic> toJson() => _$AdminUserStatsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminPropertyStats {
  const AdminPropertyStats({
    required this.total,
    required this.pending,
    required this.approved,
    required this.newToday,
  });

  final int total;
  final int pending;
  final int approved;
  final int newToday;

  factory AdminPropertyStats.fromJson(Map<String, dynamic> json) =>
      _$AdminPropertyStatsFromJson(json);

  Map<String, dynamic> toJson() => _$AdminPropertyStatsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminLodgingStats {
  const AdminLodgingStats({
    required this.total,
    required this.pending,
    required this.approved,
    required this.newToday,
  });

  final int total;
  final int pending;
  final int approved;
  final int newToday;

  factory AdminLodgingStats.fromJson(Map<String, dynamic> json) =>
      _$AdminLodgingStatsFromJson(json);

  Map<String, dynamic> toJson() => _$AdminLodgingStatsToJson(this);
}
