import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/data/models/user.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

int _intFromJson(dynamic json) {
  if (json == null) throw FormatException('Expected int, got null');
  if (json is int) return json;
  if (json is double) return json.toInt();
  if (json is String) {
    final v = int.tryParse(json);
    if (v != null) return v;
    final dv = double.tryParse(json);
    if (dv != null) return dv.toInt();
  }
  if (json is num) return json.toInt();
  throw FormatException('Cannot parse int from: $json');
}

int? _nullableIntFromJson(dynamic json) {
  if (json == null) return null;
  return _intFromJson(json);
}

double _doubleFromJson(dynamic json) {
  if (json == null) throw FormatException('Expected double, got null');
  if (json is double) return json;
  if (json is int) return json.toDouble();
  if (json is String) {
    final d = double.tryParse(json);
    if (d != null) return d;
  }
  if (json is num) return json.toDouble();
  throw FormatException('Cannot parse double from: $json');
}

@freezed
abstract class Booking with _$Booking {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Booking({
    @JsonKey(fromJson: _intFromJson) required int id,
    required String publicId,
    @JsonKey(fromJson: _intFromJson) required int userId,
    @JsonKey(fromJson: _intFromJson) required int lodgingId,
    required DateTime checkIn,
    required DateTime checkOut,
    @JsonKey(fromJson: _intFromJson) required int guestsCount,
    @JsonKey(fromJson: _nullableIntFromJson) int? roomsCount,
    @JsonKey(fromJson: _doubleFromJson) required double totalPrice,
    @JsonKey(fromJson: _nullableIntFromJson) int? availableRooms,
    required String status,
    String? notes,
    Lodging? lodging,
    User? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}
