// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lodging_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LodgingRoom {

@JsonKey(fromJson: _idFromJson) String get id; String? get lodgingId; String get name;@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? get price; String? get currency;@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? get capacity;@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? get quantity; String? get roomType; String? get bedType; List<String>? get features; String? get description; bool? get isAvailable;@JsonKey(fromJson: _mediaFromJson) List<LodgingRoomMedia>? get media;
/// Create a copy of LodgingRoom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LodgingRoomCopyWith<LodgingRoom> get copyWith => _$LodgingRoomCopyWithImpl<LodgingRoom>(this as LodgingRoom, _$identity);

  /// Serializes this LodgingRoom to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LodgingRoom&&(identical(other.id, id) || other.id == id)&&(identical(other.lodgingId, lodgingId) || other.lodgingId == lodgingId)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.bedType, bedType) || other.bedType == bedType)&&const DeepCollectionEquality().equals(other.features, features)&&(identical(other.description, description) || other.description == description)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&const DeepCollectionEquality().equals(other.media, media));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lodgingId,name,price,currency,capacity,quantity,roomType,bedType,const DeepCollectionEquality().hash(features),description,isAvailable,const DeepCollectionEquality().hash(media));

@override
String toString() {
  return 'LodgingRoom(id: $id, lodgingId: $lodgingId, name: $name, price: $price, currency: $currency, capacity: $capacity, quantity: $quantity, roomType: $roomType, bedType: $bedType, features: $features, description: $description, isAvailable: $isAvailable, media: $media)';
}


}

/// @nodoc
abstract mixin class $LodgingRoomCopyWith<$Res>  {
  factory $LodgingRoomCopyWith(LodgingRoom value, $Res Function(LodgingRoom) _then) = _$LodgingRoomCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id, String? lodgingId, String name,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? price, String? currency,@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? capacity,@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? quantity, String? roomType, String? bedType, List<String>? features, String? description, bool? isAvailable,@JsonKey(fromJson: _mediaFromJson) List<LodgingRoomMedia>? media
});




}
/// @nodoc
class _$LodgingRoomCopyWithImpl<$Res>
    implements $LodgingRoomCopyWith<$Res> {
  _$LodgingRoomCopyWithImpl(this._self, this._then);

  final LodgingRoom _self;
  final $Res Function(LodgingRoom) _then;

/// Create a copy of LodgingRoom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lodgingId = freezed,Object? name = null,Object? price = freezed,Object? currency = freezed,Object? capacity = freezed,Object? quantity = freezed,Object? roomType = freezed,Object? bedType = freezed,Object? features = freezed,Object? description = freezed,Object? isAvailable = freezed,Object? media = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lodgingId: freezed == lodgingId ? _self.lodgingId : lodgingId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,roomType: freezed == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as String?,bedType: freezed == bedType ? _self.bedType : bedType // ignore: cast_nullable_to_non_nullable
as String?,features: freezed == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<LodgingRoomMedia>?,
  ));
}

}


/// Adds pattern-matching-related methods to [LodgingRoom].
extension LodgingRoomPatterns on LodgingRoom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LodgingRoom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LodgingRoom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LodgingRoom value)  $default,){
final _that = this;
switch (_that) {
case _LodgingRoom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LodgingRoom value)?  $default,){
final _that = this;
switch (_that) {
case _LodgingRoom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id,  String? lodgingId,  String name, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? price,  String? currency, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? capacity, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? quantity,  String? roomType,  String? bedType,  List<String>? features,  String? description,  bool? isAvailable, @JsonKey(fromJson: _mediaFromJson)  List<LodgingRoomMedia>? media)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LodgingRoom() when $default != null:
return $default(_that.id,_that.lodgingId,_that.name,_that.price,_that.currency,_that.capacity,_that.quantity,_that.roomType,_that.bedType,_that.features,_that.description,_that.isAvailable,_that.media);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id,  String? lodgingId,  String name, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? price,  String? currency, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? capacity, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? quantity,  String? roomType,  String? bedType,  List<String>? features,  String? description,  bool? isAvailable, @JsonKey(fromJson: _mediaFromJson)  List<LodgingRoomMedia>? media)  $default,) {final _that = this;
switch (_that) {
case _LodgingRoom():
return $default(_that.id,_that.lodgingId,_that.name,_that.price,_that.currency,_that.capacity,_that.quantity,_that.roomType,_that.bedType,_that.features,_that.description,_that.isAvailable,_that.media);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String id,  String? lodgingId,  String name, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? price,  String? currency, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? capacity, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? quantity,  String? roomType,  String? bedType,  List<String>? features,  String? description,  bool? isAvailable, @JsonKey(fromJson: _mediaFromJson)  List<LodgingRoomMedia>? media)?  $default,) {final _that = this;
switch (_that) {
case _LodgingRoom() when $default != null:
return $default(_that.id,_that.lodgingId,_that.name,_that.price,_that.currency,_that.capacity,_that.quantity,_that.roomType,_that.bedType,_that.features,_that.description,_that.isAvailable,_that.media);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _LodgingRoom extends LodgingRoom {
  const _LodgingRoom({@JsonKey(fromJson: _idFromJson) required this.id, this.lodgingId, required this.name, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) this.price, this.currency, @JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.capacity, @JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.quantity, this.roomType, this.bedType, final  List<String>? features, this.description, this.isAvailable, @JsonKey(fromJson: _mediaFromJson) final  List<LodgingRoomMedia>? media}): _features = features,_media = media,super._();
  factory _LodgingRoom.fromJson(Map<String, dynamic> json) => _$LodgingRoomFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String id;
@override final  String? lodgingId;
@override final  String name;
@override@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) final  double? price;
@override final  String? currency;
@override@JsonKey(fromJson: _intFromJson, toJson: _intToJson) final  int? capacity;
@override@JsonKey(fromJson: _intFromJson, toJson: _intToJson) final  int? quantity;
@override final  String? roomType;
@override final  String? bedType;
 final  List<String>? _features;
@override List<String>? get features {
  final value = _features;
  if (value == null) return null;
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? description;
@override final  bool? isAvailable;
 final  List<LodgingRoomMedia>? _media;
@override@JsonKey(fromJson: _mediaFromJson) List<LodgingRoomMedia>? get media {
  final value = _media;
  if (value == null) return null;
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LodgingRoom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LodgingRoomCopyWith<_LodgingRoom> get copyWith => __$LodgingRoomCopyWithImpl<_LodgingRoom>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LodgingRoomToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LodgingRoom&&(identical(other.id, id) || other.id == id)&&(identical(other.lodgingId, lodgingId) || other.lodgingId == lodgingId)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.bedType, bedType) || other.bedType == bedType)&&const DeepCollectionEquality().equals(other._features, _features)&&(identical(other.description, description) || other.description == description)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&const DeepCollectionEquality().equals(other._media, _media));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lodgingId,name,price,currency,capacity,quantity,roomType,bedType,const DeepCollectionEquality().hash(_features),description,isAvailable,const DeepCollectionEquality().hash(_media));

@override
String toString() {
  return 'LodgingRoom(id: $id, lodgingId: $lodgingId, name: $name, price: $price, currency: $currency, capacity: $capacity, quantity: $quantity, roomType: $roomType, bedType: $bedType, features: $features, description: $description, isAvailable: $isAvailable, media: $media)';
}


}

/// @nodoc
abstract mixin class _$LodgingRoomCopyWith<$Res> implements $LodgingRoomCopyWith<$Res> {
  factory _$LodgingRoomCopyWith(_LodgingRoom value, $Res Function(_LodgingRoom) _then) = __$LodgingRoomCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id, String? lodgingId, String name,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? price, String? currency,@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? capacity,@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? quantity, String? roomType, String? bedType, List<String>? features, String? description, bool? isAvailable,@JsonKey(fromJson: _mediaFromJson) List<LodgingRoomMedia>? media
});




}
/// @nodoc
class __$LodgingRoomCopyWithImpl<$Res>
    implements _$LodgingRoomCopyWith<$Res> {
  __$LodgingRoomCopyWithImpl(this._self, this._then);

  final _LodgingRoom _self;
  final $Res Function(_LodgingRoom) _then;

/// Create a copy of LodgingRoom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lodgingId = freezed,Object? name = null,Object? price = freezed,Object? currency = freezed,Object? capacity = freezed,Object? quantity = freezed,Object? roomType = freezed,Object? bedType = freezed,Object? features = freezed,Object? description = freezed,Object? isAvailable = freezed,Object? media = freezed,}) {
  return _then(_LodgingRoom(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lodgingId: freezed == lodgingId ? _self.lodgingId : lodgingId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,roomType: freezed == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as String?,bedType: freezed == bedType ? _self.bedType : bedType // ignore: cast_nullable_to_non_nullable
as String?,features: freezed == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,media: freezed == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<LodgingRoomMedia>?,
  ));
}


}


/// @nodoc
mixin _$LodgingRoomMedia {

 String get id; String get url; String? get thumbUrl; String? get previewUrl; String? get caption;
/// Create a copy of LodgingRoomMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LodgingRoomMediaCopyWith<LodgingRoomMedia> get copyWith => _$LodgingRoomMediaCopyWithImpl<LodgingRoomMedia>(this as LodgingRoomMedia, _$identity);

  /// Serializes this LodgingRoomMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LodgingRoomMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl)&&(identical(other.caption, caption) || other.caption == caption));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,thumbUrl,previewUrl,caption);

@override
String toString() {
  return 'LodgingRoomMedia(id: $id, url: $url, thumbUrl: $thumbUrl, previewUrl: $previewUrl, caption: $caption)';
}


}

/// @nodoc
abstract mixin class $LodgingRoomMediaCopyWith<$Res>  {
  factory $LodgingRoomMediaCopyWith(LodgingRoomMedia value, $Res Function(LodgingRoomMedia) _then) = _$LodgingRoomMediaCopyWithImpl;
@useResult
$Res call({
 String id, String url, String? thumbUrl, String? previewUrl, String? caption
});




}
/// @nodoc
class _$LodgingRoomMediaCopyWithImpl<$Res>
    implements $LodgingRoomMediaCopyWith<$Res> {
  _$LodgingRoomMediaCopyWithImpl(this._self, this._then);

  final LodgingRoomMedia _self;
  final $Res Function(LodgingRoomMedia) _then;

/// Create a copy of LodgingRoomMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? thumbUrl = freezed,Object? previewUrl = freezed,Object? caption = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LodgingRoomMedia].
extension LodgingRoomMediaPatterns on LodgingRoomMedia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LodgingRoomMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LodgingRoomMedia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LodgingRoomMedia value)  $default,){
final _that = this;
switch (_that) {
case _LodgingRoomMedia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LodgingRoomMedia value)?  $default,){
final _that = this;
switch (_that) {
case _LodgingRoomMedia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String url,  String? thumbUrl,  String? previewUrl,  String? caption)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LodgingRoomMedia() when $default != null:
return $default(_that.id,_that.url,_that.thumbUrl,_that.previewUrl,_that.caption);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String url,  String? thumbUrl,  String? previewUrl,  String? caption)  $default,) {final _that = this;
switch (_that) {
case _LodgingRoomMedia():
return $default(_that.id,_that.url,_that.thumbUrl,_that.previewUrl,_that.caption);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String url,  String? thumbUrl,  String? previewUrl,  String? caption)?  $default,) {final _that = this;
switch (_that) {
case _LodgingRoomMedia() when $default != null:
return $default(_that.id,_that.url,_that.thumbUrl,_that.previewUrl,_that.caption);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _LodgingRoomMedia implements LodgingRoomMedia {
  const _LodgingRoomMedia({required this.id, required this.url, this.thumbUrl, this.previewUrl, this.caption});
  factory _LodgingRoomMedia.fromJson(Map<String, dynamic> json) => _$LodgingRoomMediaFromJson(json);

@override final  String id;
@override final  String url;
@override final  String? thumbUrl;
@override final  String? previewUrl;
@override final  String? caption;

/// Create a copy of LodgingRoomMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LodgingRoomMediaCopyWith<_LodgingRoomMedia> get copyWith => __$LodgingRoomMediaCopyWithImpl<_LodgingRoomMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LodgingRoomMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LodgingRoomMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl)&&(identical(other.caption, caption) || other.caption == caption));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,thumbUrl,previewUrl,caption);

@override
String toString() {
  return 'LodgingRoomMedia(id: $id, url: $url, thumbUrl: $thumbUrl, previewUrl: $previewUrl, caption: $caption)';
}


}

/// @nodoc
abstract mixin class _$LodgingRoomMediaCopyWith<$Res> implements $LodgingRoomMediaCopyWith<$Res> {
  factory _$LodgingRoomMediaCopyWith(_LodgingRoomMedia value, $Res Function(_LodgingRoomMedia) _then) = __$LodgingRoomMediaCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, String? thumbUrl, String? previewUrl, String? caption
});




}
/// @nodoc
class __$LodgingRoomMediaCopyWithImpl<$Res>
    implements _$LodgingRoomMediaCopyWith<$Res> {
  __$LodgingRoomMediaCopyWithImpl(this._self, this._then);

  final _LodgingRoomMedia _self;
  final $Res Function(_LodgingRoomMedia) _then;

/// Create a copy of LodgingRoomMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? thumbUrl = freezed,Object? previewUrl = freezed,Object? caption = freezed,}) {
  return _then(_LodgingRoomMedia(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
