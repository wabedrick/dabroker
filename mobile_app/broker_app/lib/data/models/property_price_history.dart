import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_price_history.freezed.dart';
part 'property_price_history.g.dart';

@freezed
abstract class PropertyPriceHistory with _$PropertyPriceHistory {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PropertyPriceHistory({
    int? id,
    @JsonKey(fromJson: _doubleFromJson) double? oldPrice,
    @JsonKey(fromJson: _doubleFromJson) double? newPrice,
    DateTime? changedAt,
  }) = _PropertyPriceHistory;

  factory PropertyPriceHistory.fromJson(Map<String, dynamic> json) =>
      _$PropertyPriceHistoryFromJson(json);
}

double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
