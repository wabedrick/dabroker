import 'package:json_annotation/json_annotation.dart';
import 'package:broker_app/data/models/user.dart';

part 'lodging.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Lodging {
  final String id;
  final int? hostId;
  final String title;
  final String? slug;
  final String? type;
  final String? status;
  final bool? isAvailable;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double? pricePerNight;
  final String? currency;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? maxGuests;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? totalRooms;
  final String? description;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double? latitude;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double? longitude;
  final List<String>? amenities;
  final List<String>? rules;
  final DateTime? publishedAt;
  final DateTime? approvedAt;
  final User? host;
  final List<LodgingMedia>? media;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double? distance;
  @JsonKey(defaultValue: 0.0, fromJson: _doubleFromJsonNonNull)
  final double averageRating;
  @JsonKey(defaultValue: 0)
  final int ratingsCount;

  const Lodging({
    required this.id,
    this.hostId,
    required this.title,
    this.slug,
    this.type,
    this.status,
    this.isAvailable,
    this.pricePerNight,
    this.currency,
    this.maxGuests,
    this.totalRooms,
    this.description,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.amenities,
    this.rules,
    this.publishedAt,
    this.approvedAt,
    this.host,
    this.media,
    this.createdAt,
    this.updatedAt,
    this.distance,
    this.averageRating = 0.0,
    this.ratingsCount = 0,
  });

  Lodging copyWith({
    String? id,
    String? title,
    String? slug,
    String? type,
    String? status,
    bool? isAvailable,
    double? pricePerNight,
    String? currency,
    int? maxGuests,
    String? description,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    double? latitude,
    double? longitude,
    List<String>? amenities,
    List<String>? rules,
    DateTime? publishedAt,
    DateTime? approvedAt,
    User? host,
    List<LodgingMedia>? media,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? distance,
  }) {
    return Lodging(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      type: type ?? this.type,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      currency: currency ?? this.currency,
      maxGuests: maxGuests ?? this.maxGuests,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      amenities: amenities ?? this.amenities,
      rules: rules ?? this.rules,
      publishedAt: publishedAt ?? this.publishedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      host: host ?? this.host,
      media: media ?? this.media,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      distance: distance ?? this.distance,
    );
  }

  factory Lodging.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> normalized = Map<String, dynamic>.from(json);

    // Normalize id to String (some APIs return numeric ids)
    if (normalized['id'] != null && normalized['id'] is! String) {
      normalized['id'] = normalized['id'].toString();
    }

    // Ensure media ids are numeric when possible (generated code expects num)
    if (normalized['media'] is List) {
      normalized['media'] = (normalized['media'] as List).map((m) {
        if (m is Map<String, dynamic>) {
          final mm = Map<String, dynamic>.from(m);
          if (mm['id'] != null && mm['id'] is String) {
            final parsed = int.tryParse(mm['id']);
            if (parsed != null) mm['id'] = parsed;
          }
          return mm;
        }
        return m;
      }).toList();
    }

    return _$LodgingFromJson(normalized);
  }
  Map<String, dynamic> toJson() => _$LodgingToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LodgingMedia {
  final int id;
  final String url;
  final String? thumbUrl;
  final String? previewUrl;

  const LodgingMedia({
    required this.id,
    required this.url,
    this.thumbUrl,
    this.previewUrl,
  });

  factory LodgingMedia.fromJson(Map<String, dynamic> json) =>
      _$LodgingMediaFromJson(json);
  Map<String, dynamic> toJson() => _$LodgingMediaToJson(this);
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
