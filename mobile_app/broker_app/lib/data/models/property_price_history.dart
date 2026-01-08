import 'package:json_annotation/json_annotation.dart';

part 'property_price_history.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PropertyPriceHistory {
  final int? id;
  @JsonKey(fromJson: _doubleFromJson)
  final double? oldPrice;
  @JsonKey(fromJson: _doubleFromJson)
  final double? newPrice;
  final DateTime? changedAt;

  const PropertyPriceHistory({
    this.id,
    this.oldPrice,
    this.newPrice,
    this.changedAt,
  });

  factory PropertyPriceHistory.fromJson(Map<String, dynamic> json) =>
      _$PropertyPriceHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyPriceHistoryToJson(this);
}

double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
