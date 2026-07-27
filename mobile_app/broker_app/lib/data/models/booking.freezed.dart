// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Booking {

@JsonKey(fromJson: _intFromJson) int get id; String get publicId;@JsonKey(fromJson: _intFromJson) int get userId;@JsonKey(fromJson: _intFromJson) int get lodgingId; DateTime get checkIn; DateTime get checkOut;@JsonKey(fromJson: _intFromJson) int get guestsCount;@JsonKey(fromJson: _nullableIntFromJson) int? get roomsCount;@JsonKey(fromJson: _doubleFromJson) double get totalPrice;@JsonKey(fromJson: _nullableIntFromJson) int? get availableRooms; String get status; String? get notes; Lodging? get lodging; User? get user; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lodgingId, lodgingId) || other.lodgingId == lodgingId)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.guestsCount, guestsCount) || other.guestsCount == guestsCount)&&(identical(other.roomsCount, roomsCount) || other.roomsCount == roomsCount)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.availableRooms, availableRooms) || other.availableRooms == availableRooms)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.lodging, lodging) || other.lodging == lodging)&&(identical(other.user, user) || other.user == user)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,publicId,userId,lodgingId,checkIn,checkOut,guestsCount,roomsCount,totalPrice,availableRooms,status,notes,lodging,user,createdAt,updatedAt);

@override
String toString() {
  return 'Booking(id: $id, publicId: $publicId, userId: $userId, lodgingId: $lodgingId, checkIn: $checkIn, checkOut: $checkOut, guestsCount: $guestsCount, roomsCount: $roomsCount, totalPrice: $totalPrice, availableRooms: $availableRooms, status: $status, notes: $notes, lodging: $lodging, user: $user, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id, String publicId,@JsonKey(fromJson: _intFromJson) int userId,@JsonKey(fromJson: _intFromJson) int lodgingId, DateTime checkIn, DateTime checkOut,@JsonKey(fromJson: _intFromJson) int guestsCount,@JsonKey(fromJson: _nullableIntFromJson) int? roomsCount,@JsonKey(fromJson: _doubleFromJson) double totalPrice,@JsonKey(fromJson: _nullableIntFromJson) int? availableRooms, String status, String? notes, Lodging? lodging, User? user, DateTime? createdAt, DateTime? updatedAt
});


$LodgingCopyWith<$Res>? get lodging;$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? publicId = null,Object? userId = null,Object? lodgingId = null,Object? checkIn = null,Object? checkOut = null,Object? guestsCount = null,Object? roomsCount = freezed,Object? totalPrice = null,Object? availableRooms = freezed,Object? status = null,Object? notes = freezed,Object? lodging = freezed,Object? user = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,publicId: null == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,lodgingId: null == lodgingId ? _self.lodgingId : lodgingId // ignore: cast_nullable_to_non_nullable
as int,checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as DateTime,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as DateTime,guestsCount: null == guestsCount ? _self.guestsCount : guestsCount // ignore: cast_nullable_to_non_nullable
as int,roomsCount: freezed == roomsCount ? _self.roomsCount : roomsCount // ignore: cast_nullable_to_non_nullable
as int?,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,availableRooms: freezed == availableRooms ? _self.availableRooms : availableRooms // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lodging: freezed == lodging ? _self.lodging : lodging // ignore: cast_nullable_to_non_nullable
as Lodging?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LodgingCopyWith<$Res>? get lodging {
    if (_self.lodging == null) {
    return null;
  }

  return $LodgingCopyWith<$Res>(_self.lodging!, (value) {
    return _then(_self.copyWith(lodging: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id,  String publicId, @JsonKey(fromJson: _intFromJson)  int userId, @JsonKey(fromJson: _intFromJson)  int lodgingId,  DateTime checkIn,  DateTime checkOut, @JsonKey(fromJson: _intFromJson)  int guestsCount, @JsonKey(fromJson: _nullableIntFromJson)  int? roomsCount, @JsonKey(fromJson: _doubleFromJson)  double totalPrice, @JsonKey(fromJson: _nullableIntFromJson)  int? availableRooms,  String status,  String? notes,  Lodging? lodging,  User? user,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.publicId,_that.userId,_that.lodgingId,_that.checkIn,_that.checkOut,_that.guestsCount,_that.roomsCount,_that.totalPrice,_that.availableRooms,_that.status,_that.notes,_that.lodging,_that.user,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id,  String publicId, @JsonKey(fromJson: _intFromJson)  int userId, @JsonKey(fromJson: _intFromJson)  int lodgingId,  DateTime checkIn,  DateTime checkOut, @JsonKey(fromJson: _intFromJson)  int guestsCount, @JsonKey(fromJson: _nullableIntFromJson)  int? roomsCount, @JsonKey(fromJson: _doubleFromJson)  double totalPrice, @JsonKey(fromJson: _nullableIntFromJson)  int? availableRooms,  String status,  String? notes,  Lodging? lodging,  User? user,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.publicId,_that.userId,_that.lodgingId,_that.checkIn,_that.checkOut,_that.guestsCount,_that.roomsCount,_that.totalPrice,_that.availableRooms,_that.status,_that.notes,_that.lodging,_that.user,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id,  String publicId, @JsonKey(fromJson: _intFromJson)  int userId, @JsonKey(fromJson: _intFromJson)  int lodgingId,  DateTime checkIn,  DateTime checkOut, @JsonKey(fromJson: _intFromJson)  int guestsCount, @JsonKey(fromJson: _nullableIntFromJson)  int? roomsCount, @JsonKey(fromJson: _doubleFromJson)  double totalPrice, @JsonKey(fromJson: _nullableIntFromJson)  int? availableRooms,  String status,  String? notes,  Lodging? lodging,  User? user,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.publicId,_that.userId,_that.lodgingId,_that.checkIn,_that.checkOut,_that.guestsCount,_that.roomsCount,_that.totalPrice,_that.availableRooms,_that.status,_that.notes,_that.lodging,_that.user,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _Booking implements Booking {
  const _Booking({@JsonKey(fromJson: _intFromJson) required this.id, required this.publicId, @JsonKey(fromJson: _intFromJson) required this.userId, @JsonKey(fromJson: _intFromJson) required this.lodgingId, required this.checkIn, required this.checkOut, @JsonKey(fromJson: _intFromJson) required this.guestsCount, @JsonKey(fromJson: _nullableIntFromJson) this.roomsCount, @JsonKey(fromJson: _doubleFromJson) required this.totalPrice, @JsonKey(fromJson: _nullableIntFromJson) this.availableRooms, required this.status, this.notes, this.lodging, this.user, this.createdAt, this.updatedAt});
  factory _Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override final  String publicId;
@override@JsonKey(fromJson: _intFromJson) final  int userId;
@override@JsonKey(fromJson: _intFromJson) final  int lodgingId;
@override final  DateTime checkIn;
@override final  DateTime checkOut;
@override@JsonKey(fromJson: _intFromJson) final  int guestsCount;
@override@JsonKey(fromJson: _nullableIntFromJson) final  int? roomsCount;
@override@JsonKey(fromJson: _doubleFromJson) final  double totalPrice;
@override@JsonKey(fromJson: _nullableIntFromJson) final  int? availableRooms;
@override final  String status;
@override final  String? notes;
@override final  Lodging? lodging;
@override final  User? user;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.lodgingId, lodgingId) || other.lodgingId == lodgingId)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.guestsCount, guestsCount) || other.guestsCount == guestsCount)&&(identical(other.roomsCount, roomsCount) || other.roomsCount == roomsCount)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.availableRooms, availableRooms) || other.availableRooms == availableRooms)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.lodging, lodging) || other.lodging == lodging)&&(identical(other.user, user) || other.user == user)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,publicId,userId,lodgingId,checkIn,checkOut,guestsCount,roomsCount,totalPrice,availableRooms,status,notes,lodging,user,createdAt,updatedAt);

@override
String toString() {
  return 'Booking(id: $id, publicId: $publicId, userId: $userId, lodgingId: $lodgingId, checkIn: $checkIn, checkOut: $checkOut, guestsCount: $guestsCount, roomsCount: $roomsCount, totalPrice: $totalPrice, availableRooms: $availableRooms, status: $status, notes: $notes, lodging: $lodging, user: $user, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id, String publicId,@JsonKey(fromJson: _intFromJson) int userId,@JsonKey(fromJson: _intFromJson) int lodgingId, DateTime checkIn, DateTime checkOut,@JsonKey(fromJson: _intFromJson) int guestsCount,@JsonKey(fromJson: _nullableIntFromJson) int? roomsCount,@JsonKey(fromJson: _doubleFromJson) double totalPrice,@JsonKey(fromJson: _nullableIntFromJson) int? availableRooms, String status, String? notes, Lodging? lodging, User? user, DateTime? createdAt, DateTime? updatedAt
});


@override $LodgingCopyWith<$Res>? get lodging;@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? publicId = null,Object? userId = null,Object? lodgingId = null,Object? checkIn = null,Object? checkOut = null,Object? guestsCount = null,Object? roomsCount = freezed,Object? totalPrice = null,Object? availableRooms = freezed,Object? status = null,Object? notes = freezed,Object? lodging = freezed,Object? user = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,publicId: null == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,lodgingId: null == lodgingId ? _self.lodgingId : lodgingId // ignore: cast_nullable_to_non_nullable
as int,checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as DateTime,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as DateTime,guestsCount: null == guestsCount ? _self.guestsCount : guestsCount // ignore: cast_nullable_to_non_nullable
as int,roomsCount: freezed == roomsCount ? _self.roomsCount : roomsCount // ignore: cast_nullable_to_non_nullable
as int?,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,availableRooms: freezed == availableRooms ? _self.availableRooms : availableRooms // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,lodging: freezed == lodging ? _self.lodging : lodging // ignore: cast_nullable_to_non_nullable
as Lodging?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LodgingCopyWith<$Res>? get lodging {
    if (_self.lodging == null) {
    return null;
  }

  return $LodgingCopyWith<$Res>(_self.lodging!, (value) {
    return _then(_self.copyWith(lodging: value));
  });
}/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
