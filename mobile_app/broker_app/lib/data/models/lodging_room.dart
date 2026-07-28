import 'package:freezed_annotation/freezed_annotation.dart';

part 'lodging_room.freezed.dart';
part 'lodging_room.g.dart';

String _idFromJson(dynamic json) => json.toString();

List<LodgingRoomMedia>? _mediaFromJson(dynamic json) {
  if (json is List) {
    return json.map((m) {
      if (m is Map<String, dynamic>) {
        return LodgingRoomMedia.fromJson(m);
      }
      if (m is LodgingRoomMedia) return m;
      throw FormatException('Expected Map or LodgingRoomMedia, got $m');
    }).toList();
  }
  return null;
}

@freezed
abstract class LodgingRoom with _$LodgingRoom {
  const LodgingRoom._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LodgingRoom({
    @JsonKey(fromJson: _idFromJson) required String id,
    String? lodgingId,
    required String name,
    @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? price,
    String? currency,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? capacity,
    @JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? quantity,
    String? roomType,
    String? bedType,
    List<String>? features,
    String? description,
    bool? isAvailable,
    @JsonKey(fromJson: _mediaFromJson) List<LodgingRoomMedia>? media,
  }) = _LodgingRoom;

  factory LodgingRoom.fromJson(Map<String, dynamic> json) =>
      _$LodgingRoomFromJson(json);
}

@freezed
abstract class LodgingRoomMedia with _$LodgingRoomMedia {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory LodgingRoomMedia({
    required String id,
    required String url,
    String? thumbUrl,
    String? previewUrl,
    String? caption,
  }) = _LodgingRoomMedia;

  factory LodgingRoomMedia.fromJson(Map<String, dynamic> json) =>
      _$LodgingRoomMediaFromJson(json);
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
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

Object? _intToJson(int? value) => value;
