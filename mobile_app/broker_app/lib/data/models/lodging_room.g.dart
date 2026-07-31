// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lodging_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LodgingRoom _$LodgingRoomFromJson(Map<String, dynamic> json) => _LodgingRoom(
  id: _idFromJson(json['id']),
  lodgingId: json['lodging_id'] as String?,
  name: json['name'] as String,
  price: _doubleFromJson(json['price']),
  currency: json['currency'] as String?,
  capacity: _intFromJson(json['capacity']),
  quantity: _intFromJson(json['quantity']),
  roomType: json['room_type'] as String?,
  bedType: json['bed_type'] as String?,
  features: (json['features'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  description: json['description'] as String?,
  isAvailable: json['is_available'] as bool?,
  media: _mediaFromJson(json['media']),
);

Map<String, dynamic> _$LodgingRoomToJson(_LodgingRoom instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lodging_id': instance.lodgingId,
      'name': instance.name,
      'price': _doubleToJson(instance.price),
      'currency': instance.currency,
      'capacity': _intToJson(instance.capacity),
      'quantity': _intToJson(instance.quantity),
      'room_type': instance.roomType,
      'bed_type': instance.bedType,
      'features': instance.features,
      'description': instance.description,
      'is_available': instance.isAvailable,
      'media': instance.media?.map((e) => e.toJson()).toList(),
    };

_LodgingRoomMedia _$LodgingRoomMediaFromJson(Map<String, dynamic> json) =>
    _LodgingRoomMedia(
      id: json['id'] as String,
      url: json['url'] as String,
      thumbUrl: json['thumb_url'] as String?,
      previewUrl: json['preview_url'] as String?,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$LodgingRoomMediaToJson(_LodgingRoomMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'thumb_url': instance.thumbUrl,
      'preview_url': instance.previewUrl,
      'caption': instance.caption,
    };
