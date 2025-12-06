import 'package:json_annotation/json_annotation.dart';

part 'property.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Property {
  final String id;
  final String title;
  final String? slug;
  final String? type;
  final String? category;
  final String? status;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double? price;
  final String? currency;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double? size;
  final String? sizeUnit;
  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final int? houseAge;
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
  @JsonKey(fromJson: _metadataFromJson)
  final Map<String, dynamic>? metadata;
  final String? description;
  final DateTime? availableFrom;
  final PropertyUserSummary? owner;
  final List<PropertyMedia>? gallery;
  final bool? isFavorited;
  final bool? isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Property({
    required this.id,
    required this.title,
    this.slug,
    this.type,
    this.category,
    this.status,
    this.price,
    this.currency,
    this.size,
    this.sizeUnit,
    this.houseAge,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.amenities,
    this.metadata,
    this.description,
    this.availableFrom,
    this.owner,
    this.gallery,
    this.isFavorited,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
  });

  Property copyWith({
    String? id,
    String? title,
    String? slug,
    String? type,
    String? category,
    String? status,
    double? price,
    String? currency,
    double? size,
    String? sizeUnit,
    int? houseAge,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    double? latitude,
    double? longitude,
    List<String>? amenities,
    Map<String, dynamic>? metadata,
    String? description,
    DateTime? availableFrom,
    PropertyUserSummary? owner,
    List<PropertyMedia>? gallery,
    bool? isFavorited,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      type: type ?? this.type,
      category: category ?? this.category,
      status: status ?? this.status,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      size: size ?? this.size,
      sizeUnit: sizeUnit ?? this.sizeUnit,
      houseAge: houseAge ?? this.houseAge,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      amenities: amenities ?? this.amenities,
      metadata: metadata ?? this.metadata,
      description: description ?? this.description,
      availableFrom: availableFrom ?? this.availableFrom,
      owner: owner ?? this.owner,
      gallery: gallery ?? this.gallery,
      isFavorited: isFavorited ?? this.isFavorited,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PropertyMedia {
  final String id;
  final String name;
  final String? caption;
  final String url;
  final String? thumbnailUrl;
  final String? previewUrl;

  const PropertyMedia({
    required this.id,
    required this.name,
    this.caption,
    required this.url,
    this.thumbnailUrl,
    this.previewUrl,
  });

  factory PropertyMedia.fromJson(Map<String, dynamic> json) =>
      _$PropertyMediaFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyMediaToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PropertyUserSummary {
  final int id;
  final String name;
  final String? preferredRole;

  const PropertyUserSummary({
    required this.id,
    required this.name,
    this.preferredRole,
  });

  factory PropertyUserSummary.fromJson(Map<String, dynamic> json) =>
      _$PropertyUserSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyUserSummaryToJson(this);
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
