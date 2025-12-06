import 'package:json_annotation/json_annotation.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/data/models/user.dart';

part 'booking.g.dart';

// Helpers that safely convert JSON values that may be numbers or numeric strings
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

@JsonSerializable(fieldRename: FieldRename.snake)
class Booking {
  @JsonKey(fromJson: _intFromJson)
  final int id;
  final String publicId;
  @JsonKey(fromJson: _intFromJson)
  final int userId;
  @JsonKey(fromJson: _intFromJson)
  final int lodgingId;
  final DateTime checkIn;
  final DateTime checkOut;
  @JsonKey(fromJson: _intFromJson)
  final int guestsCount;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? roomsCount;
  @JsonKey(fromJson: _doubleFromJson)
  final double totalPrice;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? availableRooms;
  final String status;
  final String? notes;
  final Lodging? lodging;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Booking({
    required this.id,
    required this.publicId,
    required this.userId,
    required this.lodgingId,
    required this.checkIn,
    required this.checkOut,
    required this.guestsCount,
    this.roomsCount,
    required this.totalPrice,
    this.availableRooms,
    required this.status,
    this.notes,
    this.lodging,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
