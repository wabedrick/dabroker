// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Property _$PropertyFromJson(Map<String, dynamic> json) => _Property(
  id: _requiredStringFromJson(json['id']),
  title: _requiredStringFromJson(json['title']),
  slug: json['slug'] as String?,
  type: json['type'] as String?,
  category: json['category'] as String?,
  status: json['status'] as String?,
  price: _doubleFromJson(json['price']),
  currency: json['currency'] as String?,
  size: _doubleFromJson(json['size']),
  sizeUnit: json['size_unit'] as String?,
  houseAge: _intFromJson(json['house_age']),
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
  metadata: _metadataFromJson(json['metadata']),
  description: json['description'] as String?,
  availableFrom: json['available_from'] == null
      ? null
      : DateTime.parse(json['available_from'] as String),
  rooms: (json['rooms'] as List<dynamic>?)
      ?.map((e) => Room.fromJson(e as Map<String, dynamic>))
      .toList(),
  owner: json['owner'] == null
      ? null
      : PropertyUserSummary.fromJson(json['owner'] as Map<String, dynamic>),
  gallery: (json['gallery'] as List<dynamic>?)
      ?.map((e) => PropertyMedia.fromJson(e as Map<String, dynamic>))
      .toList(),
  isFavorited: json['is_favorited'] as bool?,
  isAvailable: json['is_available'] as bool?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  videoUrl: json['video_url'] as String?,
  virtualTourUrl: json['virtual_tour_url'] as String?,
  nearbyPlaces: (json['nearby_places'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  verifiedAt: json['verified_at'] == null
      ? null
      : DateTime.parse(json['verified_at'] as String),
  priceHistory: (json['price_history'] as List<dynamic>?)
      ?.map((e) => PropertyPriceHistory.fromJson(e as Map<String, dynamic>))
      .toList(),
  similarProperties: (json['similar_properties'] as List<dynamic>?)
      ?.map((e) => Property.fromJson(e as Map<String, dynamic>))
      .toList(),
  distance: _doubleFromJson(json['distance']),
);

Map<String, dynamic> _$PropertyToJson(_Property instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'slug': instance.slug,
  'type': instance.type,
  'category': instance.category,
  'status': instance.status,
  'price': _doubleToJson(instance.price),
  'currency': instance.currency,
  'size': _doubleToJson(instance.size),
  'size_unit': instance.sizeUnit,
  'house_age': _intToJson(instance.houseAge),
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'country': instance.country,
  'postal_code': instance.postalCode,
  'latitude': _doubleToJson(instance.latitude),
  'longitude': _doubleToJson(instance.longitude),
  'amenities': instance.amenities,
  'metadata': instance.metadata,
  'description': instance.description,
  'available_from': instance.availableFrom?.toIso8601String(),
  'rooms': instance.rooms?.map((e) => e.toJson()).toList(),
  'owner': instance.owner?.toJson(),
  'gallery': instance.gallery?.map((e) => e.toJson()).toList(),
  'is_favorited': instance.isFavorited,
  'is_available': instance.isAvailable,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'video_url': instance.videoUrl,
  'virtual_tour_url': instance.virtualTourUrl,
  'nearby_places': instance.nearbyPlaces,
  'verified_at': instance.verifiedAt?.toIso8601String(),
  'price_history': instance.priceHistory?.map((e) => e.toJson()).toList(),
  'similar_properties': instance.similarProperties
      ?.map((e) => e.toJson())
      .toList(),
  'distance': _doubleToJson(instance.distance),
};

_PropertyMedia _$PropertyMediaFromJson(Map<String, dynamic> json) =>
    _PropertyMedia(
      id: json['id'] as String?,
      name: json['name'] as String?,
      caption: json['caption'] as String?,
      url: json['url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      previewUrl: json['preview_url'] as String?,
    );

Map<String, dynamic> _$PropertyMediaToJson(_PropertyMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'caption': instance.caption,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
      'preview_url': instance.previewUrl,
    };

_PropertyUserSummary _$PropertyUserSummaryFromJson(Map<String, dynamic> json) =>
    _PropertyUserSummary(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      preferredRole: json['preferred_role'] as String?,
    );

Map<String, dynamic> _$PropertyUserSummaryToJson(
  _PropertyUserSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'preferred_role': instance.preferredRole,
};
