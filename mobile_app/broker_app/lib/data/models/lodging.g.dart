// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lodging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lodging _$LodgingFromJson(Map<String, dynamic> json) => Lodging(
  id: json['id'] as String,
  hostId: (json['host_id'] as num?)?.toInt(),
  title: json['title'] as String,
  slug: json['slug'] as String?,
  type: json['type'] as String?,
  status: json['status'] as String?,
  isAvailable: json['is_available'] as bool?,
  pricePerNight: _doubleFromJson(json['price_per_night']),
  currency: json['currency'] as String?,
  maxGuests: _intFromJson(json['max_guests']),
  totalRooms: _intFromJson(json['total_rooms']),
  description: json['description'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  country: json['country'] as String?,
  postalCode: json['postal_code'] as String?,
  latitude: _doubleFromJson(json['latitude']),
  longitude: _doubleFromJson(json['longitude']),
  amenities: (json['amenities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  rules: (json['rules'] as List<dynamic>?)?.map((e) => e as String).toList(),
  publishedAt: json['published_at'] == null
      ? null
      : DateTime.parse(json['published_at'] as String),
  approvedAt: json['approved_at'] == null
      ? null
      : DateTime.parse(json['approved_at'] as String),
  host: json['host'] == null
      ? null
      : User.fromJson(json['host'] as Map<String, dynamic>),
  media: (json['media'] as List<dynamic>?)
      ?.map((e) => LodgingMedia.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  distance: _doubleFromJson(json['distance']),
);

Map<String, dynamic> _$LodgingToJson(Lodging instance) => <String, dynamic>{
  'id': instance.id,
  'host_id': instance.hostId,
  'title': instance.title,
  'slug': instance.slug,
  'type': instance.type,
  'status': instance.status,
  'is_available': instance.isAvailable,
  'price_per_night': _doubleToJson(instance.pricePerNight),
  'currency': instance.currency,
  'max_guests': _intToJson(instance.maxGuests),
  'total_rooms': _intToJson(instance.totalRooms),
  'description': instance.description,
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'country': instance.country,
  'postal_code': instance.postalCode,
  'latitude': _doubleToJson(instance.latitude),
  'longitude': _doubleToJson(instance.longitude),
  'amenities': instance.amenities,
  'rules': instance.rules,
  'published_at': instance.publishedAt?.toIso8601String(),
  'approved_at': instance.approvedAt?.toIso8601String(),
  'host': instance.host,
  'media': instance.media,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'distance': _doubleToJson(instance.distance),
};

LodgingMedia _$LodgingMediaFromJson(Map<String, dynamic> json) => LodgingMedia(
  id: (json['id'] as num).toInt(),
  url: json['url'] as String,
  thumbUrl: json['thumb_url'] as String?,
  previewUrl: json['preview_url'] as String?,
);

Map<String, dynamic> _$LodgingMediaToJson(LodgingMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'thumb_url': instance.thumbUrl,
      'preview_url': instance.previewUrl,
    };
