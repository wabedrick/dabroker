import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:broker_app/data/models/user.dart';

part 'lodging.freezed.dart';
part 'lodging.g.dart';

String _idFromJson(dynamic json) => json.toString();

List<LodgingMedia>? _mediaFromJson(dynamic json) {
  if (json is List) {
    return json.map((m) {
      if (m is Map<String, dynamic>) {
        final mm = Map<String, dynamic>.from(m);
        if (mm['id'] != null && mm['id'] is String) {
          final parsed = int.tryParse(mm['id']);
          if (parsed != null) mm['id'] = parsed;
        }
        return LodgingMedia.fromJson(mm);
      }
      // If it's already a LodgingMedia somehow
      if (m is LodgingMedia) return m;
      throw FormatException('Expected Map or LodgingMedia, got $m');
    }).toList();
  }
  return null;
}

@freezed
abstract class Lodging with _$Lodging {
  const Lodging._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Lodging({
    @JsonKey(fromJson: _idFromJson) required String id,
    int? hostId,
    required String title,
    String? slug,
    String? type,
    String? status,
    bool? isAvailable,
    @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? pricePerNight,
    String? currency,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? maxGuests,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? totalRooms,
    String? description,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? latitude,
    @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? longitude,
    List<String>? amenities,
    List<String>? rules,
    DateTime? publishedAt,
    DateTime? approvedAt,
    User? host,
    @JsonKey(fromJson: _mediaFromJson) List<LodgingMedia>? media,
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? distance,
    @JsonKey(defaultValue: 0.0, fromJson: _doubleFromJsonNonNull) @Default(0.0) double averageRating,
    @JsonKey(defaultValue: 0) @Default(0) int ratingsCount,
  }) = _Lodging;

  factory Lodging.fromJson(Map<String, dynamic> json) =>
      _$LodgingFromJson(json);
}

@freezed
abstract class LodgingMedia with _$LodgingMedia {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LodgingMedia({
    int? id,
    required String url,
    String? thumbUrl,
    String? previewUrl,
  }) = _LodgingMedia;

  factory LodgingMedia.fromJson(Map<String, dynamic> json) =>
      _$LodgingMediaFromJson(json);
}

double? _doubleFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

double _doubleFromJsonNonNull(Object? value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

Object? _doubleToJson(double? value) => value;

int? _intFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

Object? _intToJson(int? value) => value;
