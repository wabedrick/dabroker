// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lodging.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lodging {

@JsonKey(fromJson: _idFromJson) String get id; int? get hostId; String get title; String? get slug; String? get type; String? get status; bool? get isAvailable;@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? get pricePerNight; String? get currency;@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? get maxGuests;@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? get totalRooms; String? get description; String? get address; String? get city; String? get state; String? get country; String? get postalCode;@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? get latitude;@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? get longitude; List<String>? get amenities; List<String>? get rules; DateTime? get publishedAt; DateTime? get approvedAt; User? get host;@JsonKey(fromJson: _mediaFromJson) List<LodgingMedia>? get media; DateTime? get createdAt; DateTime? get updatedAt;@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? get distance;@JsonKey(defaultValue: 0.0, fromJson: _doubleFromJsonNonNull) double get averageRating;@JsonKey(defaultValue: 0) int get ratingsCount;
/// Create a copy of Lodging
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LodgingCopyWith<Lodging> get copyWith => _$LodgingCopyWithImpl<Lodging>(this as Lodging, _$identity);

  /// Serializes this Lodging to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lodging&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.pricePerNight, pricePerNight) || other.pricePerNight == pricePerNight)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.maxGuests, maxGuests) || other.maxGuests == maxGuests)&&(identical(other.totalRooms, totalRooms) || other.totalRooms == totalRooms)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&const DeepCollectionEquality().equals(other.rules, rules)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.host, host) || other.host == host)&&const DeepCollectionEquality().equals(other.media, media)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,hostId,title,slug,type,status,isAvailable,pricePerNight,currency,maxGuests,totalRooms,description,address,city,state,country,postalCode,latitude,longitude,const DeepCollectionEquality().hash(amenities),const DeepCollectionEquality().hash(rules),publishedAt,approvedAt,host,const DeepCollectionEquality().hash(media),createdAt,updatedAt,distance,averageRating,ratingsCount]);

@override
String toString() {
  return 'Lodging(id: $id, hostId: $hostId, title: $title, slug: $slug, type: $type, status: $status, isAvailable: $isAvailable, pricePerNight: $pricePerNight, currency: $currency, maxGuests: $maxGuests, totalRooms: $totalRooms, description: $description, address: $address, city: $city, state: $state, country: $country, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, amenities: $amenities, rules: $rules, publishedAt: $publishedAt, approvedAt: $approvedAt, host: $host, media: $media, createdAt: $createdAt, updatedAt: $updatedAt, distance: $distance, averageRating: $averageRating, ratingsCount: $ratingsCount)';
}


}

/// @nodoc
abstract mixin class $LodgingCopyWith<$Res>  {
  factory $LodgingCopyWith(Lodging value, $Res Function(Lodging) _then) = _$LodgingCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id, int? hostId, String title, String? slug, String? type, String? status, bool? isAvailable,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? pricePerNight, String? currency,@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? maxGuests,@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? totalRooms, String? description, String? address, String? city, String? state, String? country, String? postalCode,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? latitude,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? longitude, List<String>? amenities, List<String>? rules, DateTime? publishedAt, DateTime? approvedAt, User? host,@JsonKey(fromJson: _mediaFromJson) List<LodgingMedia>? media, DateTime? createdAt, DateTime? updatedAt,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? distance,@JsonKey(defaultValue: 0.0, fromJson: _doubleFromJsonNonNull) double averageRating,@JsonKey(defaultValue: 0) int ratingsCount
});


$UserCopyWith<$Res>? get host;

}
/// @nodoc
class _$LodgingCopyWithImpl<$Res>
    implements $LodgingCopyWith<$Res> {
  _$LodgingCopyWithImpl(this._self, this._then);

  final Lodging _self;
  final $Res Function(Lodging) _then;

/// Create a copy of Lodging
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hostId = freezed,Object? title = null,Object? slug = freezed,Object? type = freezed,Object? status = freezed,Object? isAvailable = freezed,Object? pricePerNight = freezed,Object? currency = freezed,Object? maxGuests = freezed,Object? totalRooms = freezed,Object? description = freezed,Object? address = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,Object? postalCode = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? amenities = freezed,Object? rules = freezed,Object? publishedAt = freezed,Object? approvedAt = freezed,Object? host = freezed,Object? media = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? distance = freezed,Object? averageRating = null,Object? ratingsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: freezed == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,pricePerNight: freezed == pricePerNight ? _self.pricePerNight : pricePerNight // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,maxGuests: freezed == maxGuests ? _self.maxGuests : maxGuests // ignore: cast_nullable_to_non_nullable
as int?,totalRooms: freezed == totalRooms ? _self.totalRooms : totalRooms // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,amenities: freezed == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>?,rules: freezed == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<String>?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as User?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<LodgingMedia>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Lodging
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get host {
    if (_self.host == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.host!, (value) {
    return _then(_self.copyWith(host: value));
  });
}
}


/// Adds pattern-matching-related methods to [Lodging].
extension LodgingPatterns on Lodging {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lodging value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lodging() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lodging value)  $default,){
final _that = this;
switch (_that) {
case _Lodging():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lodging value)?  $default,){
final _that = this;
switch (_that) {
case _Lodging() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id,  int? hostId,  String title,  String? slug,  String? type,  String? status,  bool? isAvailable, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? pricePerNight,  String? currency, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? maxGuests, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? totalRooms,  String? description,  String? address,  String? city,  String? state,  String? country,  String? postalCode, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? latitude, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? longitude,  List<String>? amenities,  List<String>? rules,  DateTime? publishedAt,  DateTime? approvedAt,  User? host, @JsonKey(fromJson: _mediaFromJson)  List<LodgingMedia>? media,  DateTime? createdAt,  DateTime? updatedAt, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? distance, @JsonKey(defaultValue: 0.0, fromJson: _doubleFromJsonNonNull)  double averageRating, @JsonKey(defaultValue: 0)  int ratingsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lodging() when $default != null:
return $default(_that.id,_that.hostId,_that.title,_that.slug,_that.type,_that.status,_that.isAvailable,_that.pricePerNight,_that.currency,_that.maxGuests,_that.totalRooms,_that.description,_that.address,_that.city,_that.state,_that.country,_that.postalCode,_that.latitude,_that.longitude,_that.amenities,_that.rules,_that.publishedAt,_that.approvedAt,_that.host,_that.media,_that.createdAt,_that.updatedAt,_that.distance,_that.averageRating,_that.ratingsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id,  int? hostId,  String title,  String? slug,  String? type,  String? status,  bool? isAvailable, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? pricePerNight,  String? currency, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? maxGuests, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? totalRooms,  String? description,  String? address,  String? city,  String? state,  String? country,  String? postalCode, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? latitude, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? longitude,  List<String>? amenities,  List<String>? rules,  DateTime? publishedAt,  DateTime? approvedAt,  User? host, @JsonKey(fromJson: _mediaFromJson)  List<LodgingMedia>? media,  DateTime? createdAt,  DateTime? updatedAt, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? distance, @JsonKey(defaultValue: 0.0, fromJson: _doubleFromJsonNonNull)  double averageRating, @JsonKey(defaultValue: 0)  int ratingsCount)  $default,) {final _that = this;
switch (_that) {
case _Lodging():
return $default(_that.id,_that.hostId,_that.title,_that.slug,_that.type,_that.status,_that.isAvailable,_that.pricePerNight,_that.currency,_that.maxGuests,_that.totalRooms,_that.description,_that.address,_that.city,_that.state,_that.country,_that.postalCode,_that.latitude,_that.longitude,_that.amenities,_that.rules,_that.publishedAt,_that.approvedAt,_that.host,_that.media,_that.createdAt,_that.updatedAt,_that.distance,_that.averageRating,_that.ratingsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String id,  int? hostId,  String title,  String? slug,  String? type,  String? status,  bool? isAvailable, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? pricePerNight,  String? currency, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? maxGuests, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? totalRooms,  String? description,  String? address,  String? city,  String? state,  String? country,  String? postalCode, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? latitude, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? longitude,  List<String>? amenities,  List<String>? rules,  DateTime? publishedAt,  DateTime? approvedAt,  User? host, @JsonKey(fromJson: _mediaFromJson)  List<LodgingMedia>? media,  DateTime? createdAt,  DateTime? updatedAt, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? distance, @JsonKey(defaultValue: 0.0, fromJson: _doubleFromJsonNonNull)  double averageRating, @JsonKey(defaultValue: 0)  int ratingsCount)?  $default,) {final _that = this;
switch (_that) {
case _Lodging() when $default != null:
return $default(_that.id,_that.hostId,_that.title,_that.slug,_that.type,_that.status,_that.isAvailable,_that.pricePerNight,_that.currency,_that.maxGuests,_that.totalRooms,_that.description,_that.address,_that.city,_that.state,_that.country,_that.postalCode,_that.latitude,_that.longitude,_that.amenities,_that.rules,_that.publishedAt,_that.approvedAt,_that.host,_that.media,_that.createdAt,_that.updatedAt,_that.distance,_that.averageRating,_that.ratingsCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _Lodging extends Lodging {
  const _Lodging({@JsonKey(fromJson: _idFromJson) required this.id, this.hostId, required this.title, this.slug, this.type, this.status, this.isAvailable, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) this.pricePerNight, this.currency, @JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.maxGuests, @JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.totalRooms, this.description, this.address, this.city, this.state, this.country, this.postalCode, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) this.latitude, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) this.longitude, final  List<String>? amenities, final  List<String>? rules, this.publishedAt, this.approvedAt, this.host, @JsonKey(fromJson: _mediaFromJson) final  List<LodgingMedia>? media, this.createdAt, this.updatedAt, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) this.distance, @JsonKey(defaultValue: 0.0, fromJson: _doubleFromJsonNonNull) this.averageRating = 0.0, @JsonKey(defaultValue: 0) this.ratingsCount = 0}): _amenities = amenities,_rules = rules,_media = media,super._();
  factory _Lodging.fromJson(Map<String, dynamic> json) => _$LodgingFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String id;
@override final  int? hostId;
@override final  String title;
@override final  String? slug;
@override final  String? type;
@override final  String? status;
@override final  bool? isAvailable;
@override@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) final  double? pricePerNight;
@override final  String? currency;
@override@JsonKey(fromJson: _intFromJson, toJson: _intToJson) final  int? maxGuests;
@override@JsonKey(fromJson: _intFromJson, toJson: _intToJson) final  int? totalRooms;
@override final  String? description;
@override final  String? address;
@override final  String? city;
@override final  String? state;
@override final  String? country;
@override final  String? postalCode;
@override@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) final  double? latitude;
@override@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) final  double? longitude;
 final  List<String>? _amenities;
@override List<String>? get amenities {
  final value = _amenities;
  if (value == null) return null;
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _rules;
@override List<String>? get rules {
  final value = _rules;
  if (value == null) return null;
  if (_rules is EqualUnmodifiableListView) return _rules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? publishedAt;
@override final  DateTime? approvedAt;
@override final  User? host;
 final  List<LodgingMedia>? _media;
@override@JsonKey(fromJson: _mediaFromJson) List<LodgingMedia>? get media {
  final value = _media;
  if (value == null) return null;
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) final  double? distance;
@override@JsonKey(defaultValue: 0.0, fromJson: _doubleFromJsonNonNull) final  double averageRating;
@override@JsonKey(defaultValue: 0) final  int ratingsCount;

/// Create a copy of Lodging
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LodgingCopyWith<_Lodging> get copyWith => __$LodgingCopyWithImpl<_Lodging>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LodgingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lodging&&(identical(other.id, id) || other.id == id)&&(identical(other.hostId, hostId) || other.hostId == hostId)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.pricePerNight, pricePerNight) || other.pricePerNight == pricePerNight)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.maxGuests, maxGuests) || other.maxGuests == maxGuests)&&(identical(other.totalRooms, totalRooms) || other.totalRooms == totalRooms)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&const DeepCollectionEquality().equals(other._rules, _rules)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.host, host) || other.host == host)&&const DeepCollectionEquality().equals(other._media, _media)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,hostId,title,slug,type,status,isAvailable,pricePerNight,currency,maxGuests,totalRooms,description,address,city,state,country,postalCode,latitude,longitude,const DeepCollectionEquality().hash(_amenities),const DeepCollectionEquality().hash(_rules),publishedAt,approvedAt,host,const DeepCollectionEquality().hash(_media),createdAt,updatedAt,distance,averageRating,ratingsCount]);

@override
String toString() {
  return 'Lodging(id: $id, hostId: $hostId, title: $title, slug: $slug, type: $type, status: $status, isAvailable: $isAvailable, pricePerNight: $pricePerNight, currency: $currency, maxGuests: $maxGuests, totalRooms: $totalRooms, description: $description, address: $address, city: $city, state: $state, country: $country, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, amenities: $amenities, rules: $rules, publishedAt: $publishedAt, approvedAt: $approvedAt, host: $host, media: $media, createdAt: $createdAt, updatedAt: $updatedAt, distance: $distance, averageRating: $averageRating, ratingsCount: $ratingsCount)';
}


}

/// @nodoc
abstract mixin class _$LodgingCopyWith<$Res> implements $LodgingCopyWith<$Res> {
  factory _$LodgingCopyWith(_Lodging value, $Res Function(_Lodging) _then) = __$LodgingCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id, int? hostId, String title, String? slug, String? type, String? status, bool? isAvailable,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? pricePerNight, String? currency,@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? maxGuests,@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? totalRooms, String? description, String? address, String? city, String? state, String? country, String? postalCode,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? latitude,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? longitude, List<String>? amenities, List<String>? rules, DateTime? publishedAt, DateTime? approvedAt, User? host,@JsonKey(fromJson: _mediaFromJson) List<LodgingMedia>? media, DateTime? createdAt, DateTime? updatedAt,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? distance,@JsonKey(defaultValue: 0.0, fromJson: _doubleFromJsonNonNull) double averageRating,@JsonKey(defaultValue: 0) int ratingsCount
});


@override $UserCopyWith<$Res>? get host;

}
/// @nodoc
class __$LodgingCopyWithImpl<$Res>
    implements _$LodgingCopyWith<$Res> {
  __$LodgingCopyWithImpl(this._self, this._then);

  final _Lodging _self;
  final $Res Function(_Lodging) _then;

/// Create a copy of Lodging
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hostId = freezed,Object? title = null,Object? slug = freezed,Object? type = freezed,Object? status = freezed,Object? isAvailable = freezed,Object? pricePerNight = freezed,Object? currency = freezed,Object? maxGuests = freezed,Object? totalRooms = freezed,Object? description = freezed,Object? address = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,Object? postalCode = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? amenities = freezed,Object? rules = freezed,Object? publishedAt = freezed,Object? approvedAt = freezed,Object? host = freezed,Object? media = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? distance = freezed,Object? averageRating = null,Object? ratingsCount = null,}) {
  return _then(_Lodging(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hostId: freezed == hostId ? _self.hostId : hostId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,pricePerNight: freezed == pricePerNight ? _self.pricePerNight : pricePerNight // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,maxGuests: freezed == maxGuests ? _self.maxGuests : maxGuests // ignore: cast_nullable_to_non_nullable
as int?,totalRooms: freezed == totalRooms ? _self.totalRooms : totalRooms // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,amenities: freezed == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>?,rules: freezed == rules ? _self._rules : rules // ignore: cast_nullable_to_non_nullable
as List<String>?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as User?,media: freezed == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<LodgingMedia>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Lodging
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get host {
    if (_self.host == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.host!, (value) {
    return _then(_self.copyWith(host: value));
  });
}
}


/// @nodoc
mixin _$LodgingMedia {

 int? get id; String get url; String? get thumbUrl; String? get previewUrl;
/// Create a copy of LodgingMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LodgingMediaCopyWith<LodgingMedia> get copyWith => _$LodgingMediaCopyWithImpl<LodgingMedia>(this as LodgingMedia, _$identity);

  /// Serializes this LodgingMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LodgingMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,thumbUrl,previewUrl);

@override
String toString() {
  return 'LodgingMedia(id: $id, url: $url, thumbUrl: $thumbUrl, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class $LodgingMediaCopyWith<$Res>  {
  factory $LodgingMediaCopyWith(LodgingMedia value, $Res Function(LodgingMedia) _then) = _$LodgingMediaCopyWithImpl;
@useResult
$Res call({
 int? id, String url, String? thumbUrl, String? previewUrl
});




}
/// @nodoc
class _$LodgingMediaCopyWithImpl<$Res>
    implements $LodgingMediaCopyWith<$Res> {
  _$LodgingMediaCopyWithImpl(this._self, this._then);

  final LodgingMedia _self;
  final $Res Function(LodgingMedia) _then;

/// Create a copy of LodgingMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? url = null,Object? thumbUrl = freezed,Object? previewUrl = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LodgingMedia].
extension LodgingMediaPatterns on LodgingMedia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LodgingMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LodgingMedia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LodgingMedia value)  $default,){
final _that = this;
switch (_that) {
case _LodgingMedia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LodgingMedia value)?  $default,){
final _that = this;
switch (_that) {
case _LodgingMedia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String url,  String? thumbUrl,  String? previewUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LodgingMedia() when $default != null:
return $default(_that.id,_that.url,_that.thumbUrl,_that.previewUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String url,  String? thumbUrl,  String? previewUrl)  $default,) {final _that = this;
switch (_that) {
case _LodgingMedia():
return $default(_that.id,_that.url,_that.thumbUrl,_that.previewUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String url,  String? thumbUrl,  String? previewUrl)?  $default,) {final _that = this;
switch (_that) {
case _LodgingMedia() when $default != null:
return $default(_that.id,_that.url,_that.thumbUrl,_that.previewUrl);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _LodgingMedia implements LodgingMedia {
  const _LodgingMedia({this.id, required this.url, this.thumbUrl, this.previewUrl});
  factory _LodgingMedia.fromJson(Map<String, dynamic> json) => _$LodgingMediaFromJson(json);

@override final  int? id;
@override final  String url;
@override final  String? thumbUrl;
@override final  String? previewUrl;

/// Create a copy of LodgingMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LodgingMediaCopyWith<_LodgingMedia> get copyWith => __$LodgingMediaCopyWithImpl<_LodgingMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LodgingMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LodgingMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,thumbUrl,previewUrl);

@override
String toString() {
  return 'LodgingMedia(id: $id, url: $url, thumbUrl: $thumbUrl, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class _$LodgingMediaCopyWith<$Res> implements $LodgingMediaCopyWith<$Res> {
  factory _$LodgingMediaCopyWith(_LodgingMedia value, $Res Function(_LodgingMedia) _then) = __$LodgingMediaCopyWithImpl;
@override @useResult
$Res call({
 int? id, String url, String? thumbUrl, String? previewUrl
});




}
/// @nodoc
class __$LodgingMediaCopyWithImpl<$Res>
    implements _$LodgingMediaCopyWith<$Res> {
  __$LodgingMediaCopyWithImpl(this._self, this._then);

  final _LodgingMedia _self;
  final $Res Function(_LodgingMedia) _then;

/// Create a copy of LodgingMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? url = null,Object? thumbUrl = freezed,Object? previewUrl = freezed,}) {
  return _then(_LodgingMedia(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
