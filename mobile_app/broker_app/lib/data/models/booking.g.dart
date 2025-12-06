// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
      id: _intFromJson(json['id']),
      publicId: json['public_id'] as String,
      userId: _intFromJson(json['user_id']),
      lodgingId: _intFromJson(json['lodging_id']),
      checkIn: DateTime.parse(json['check_in'] as String),
      checkOut: DateTime.parse(json['check_out'] as String),
      guestsCount: _intFromJson(json['guests_count']),
      roomsCount: _nullableIntFromJson(json['rooms_count']),
      totalPrice: _doubleFromJson(json['total_price']),
      availableRooms: _nullableIntFromJson(json['available_rooms']),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      lodging: json['lodging'] == null
          ? null
          : Lodging.fromJson(json['lodging'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'id': instance.id,
      'public_id': instance.publicId,
      'user_id': instance.userId,
      'lodging_id': instance.lodgingId,
      'check_in': instance.checkIn.toIso8601String(),
      'check_out': instance.checkOut.toIso8601String(),
      'guests_count': instance.guestsCount,
      'rooms_count': instance.roomsCount,
      'total_price': instance.totalPrice,
      'available_rooms': instance.availableRooms,
      'status': instance.status,
      'notes': instance.notes,
      'lodging': instance.lodging,
      'user': instance.user,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
