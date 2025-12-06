import 'package:json_annotation/json_annotation.dart';

part 'admin_analytics.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class AdminAnalytics {
  AdminAnalytics({
    required this.users,
    required this.properties,
    required this.lodgings,
    required this.moderation,
  });

  factory AdminAnalytics.fromJson(Map<String, dynamic> json) =>
      _$AdminAnalyticsFromJson(json);

  final AnalyticsUsers users;
  final AnalyticsProperties properties;
  final AnalyticsLodgings lodgings;
  final AnalyticsModeration moderation;

  Map<String, dynamic> toJson() => _$AdminAnalyticsToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class AnalyticsUsers {
  AnalyticsUsers({required this.dailyNew, required this.total});

  factory AnalyticsUsers.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsUsersFromJson(json);

  final List<TimeSeriesPoint> dailyNew;
  final int total;

  Map<String, dynamic> toJson() => _$AnalyticsUsersToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class AnalyticsProperties {
  AnalyticsProperties({
    required this.dailyNew,
    required this.dailyApproved,
    required this.pending,
  });

  factory AnalyticsProperties.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsPropertiesFromJson(json);

  final List<TimeSeriesPoint> dailyNew;
  final List<TimeSeriesPoint> dailyApproved;
  final int pending;

  Map<String, dynamic> toJson() => _$AnalyticsPropertiesToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class AnalyticsLodgings {
  AnalyticsLodgings({
    required this.dailyNew,
    required this.dailyApproved,
    required this.pending,
  });

  factory AnalyticsLodgings.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsLodgingsFromJson(json);

  final List<TimeSeriesPoint> dailyNew;
  final List<TimeSeriesPoint> dailyApproved;
  final int pending;

  Map<String, dynamic> toJson() => _$AnalyticsLodgingsToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class AnalyticsModeration {
  AnalyticsModeration({required this.topActions});

  factory AnalyticsModeration.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsModerationFromJson(json);

  final List<TopModerationAction> topActions;

  Map<String, dynamic> toJson() => _$AnalyticsModerationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TimeSeriesPoint {
  TimeSeriesPoint({required this.date, required this.count});

  factory TimeSeriesPoint.fromJson(Map<String, dynamic> json) =>
      _$TimeSeriesPointFromJson(json);

  final String date;
  final int count;

  Map<String, dynamic> toJson() => _$TimeSeriesPointToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TopModerationAction {
  TopModerationAction({required this.action, required this.count});

  factory TopModerationAction.fromJson(Map<String, dynamic> json) =>
      _$TopModerationActionFromJson(json);

  final String action;
  final int count;

  Map<String, dynamic> toJson() => _$TopModerationActionToJson(this);
}
