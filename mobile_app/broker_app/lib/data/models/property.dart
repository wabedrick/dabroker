import 'package:freezed_annotation/freezed_annotation.dart';
import 'property_price_history.dart';
import 'room.dart';

part 'property.freezed.dart';
part 'property.g.dart';

@freezed
abstract class Property with _$Property {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Property({
    @JsonKey(fromJson: _requiredStringFromJson) required String id,
    @JsonKey(fromJson: _requiredStringFromJson) required String title,
    String? slug,
    String? type,
    String? category,
    String? status,
    @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? price,
    String? currency,
    @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? size,
    String? sizeUnit,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? houseAge,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? latitude,
    @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? longitude,
    List<String>? amenities,
    @JsonKey(fromJson: _metadataFromJson) Map<String, dynamic>? metadata,
    String? description,
    DateTime? availableFrom,
    List<Room>? rooms,
    PropertyUserSummary? owner,
    List<PropertyMedia>? gallery,
    bool? isFavorited,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? videoUrl,
    String? virtualTourUrl,
    List<Map<String, dynamic>>? nearbyPlaces,
    DateTime? verifiedAt,
    List<PropertyPriceHistory>? priceHistory,
    List<Property>? similarProperties,
    @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? distance,
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
}

@freezed
abstract class PropertyMedia with _$PropertyMedia {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PropertyMedia({
    String? id,
    String? name,
    String? caption,
    String? url,
    String? thumbnailUrl,
    String? previewUrl,
  }) = _PropertyMedia;

  factory PropertyMedia.fromJson(Map<String, dynamic> json) =>
      _$PropertyMediaFromJson(json);
}

@freezed
abstract class PropertyUserSummary with _$PropertyUserSummary {
  const PropertyUserSummary._(); // Allows adding getters/methods

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PropertyUserSummary({
    required int id,
    String? name,
    String? preferredRole,
  }) = _PropertyUserSummary;

  String get formattedRole {
    if (preferredRole == null) return '';
    return preferredRole!
        .split('_')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  factory PropertyUserSummary.fromJson(Map<String, dynamic> json) =>
      _$PropertyUserSummaryFromJson(json);
}

double? _doubleFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

Object? _doubleToJson(double? value) => value;

int? _intFromJson(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

Object? _intToJson(int? value) => value;

Map<String, dynamic>? _metadataFromJson(Object? value) {
  if (value == null) return null;
  if (value is Map) return Map<String, dynamic>.from(value);
  if (value is List && value.isEmpty) return {};
  return null;
}

/// Safely converts a JSON value to String, returning an empty string if null.
String _requiredStringFromJson(Object? value) {
  if (value == null) return '';
  return value.toString();
}
