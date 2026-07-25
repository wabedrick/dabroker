// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Property {

 String get id; String get title; String? get slug; String? get type; String? get category; String? get status;@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? get price; String? get currency;@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? get size; String? get sizeUnit;@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? get houseAge; String? get address; String? get city; String? get state; String? get country; String? get postalCode;@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? get latitude;@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? get longitude; List<String>? get amenities;@JsonKey(fromJson: _metadataFromJson) Map<String, dynamic>? get metadata; String? get description; DateTime? get availableFrom; PropertyUserSummary? get owner; List<PropertyMedia>? get gallery; bool? get isFavorited; bool? get isAvailable; DateTime? get createdAt; DateTime? get updatedAt; String? get videoUrl; String? get virtualTourUrl; List<Map<String, dynamic>>? get nearbyPlaces; DateTime? get verifiedAt; List<PropertyPriceHistory>? get priceHistory; List<Property>? get similarProperties;@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? get distance;
/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyCopyWith<Property> get copyWith => _$PropertyCopyWithImpl<Property>(this as Property, _$identity);

  /// Serializes this Property to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Property&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.size, size) || other.size == size)&&(identical(other.sizeUnit, sizeUnit) || other.sizeUnit == sizeUnit)&&(identical(other.houseAge, houseAge) || other.houseAge == houseAge)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.description, description) || other.description == description)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.owner, owner) || other.owner == owner)&&const DeepCollectionEquality().equals(other.gallery, gallery)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.virtualTourUrl, virtualTourUrl) || other.virtualTourUrl == virtualTourUrl)&&const DeepCollectionEquality().equals(other.nearbyPlaces, nearbyPlaces)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&const DeepCollectionEquality().equals(other.priceHistory, priceHistory)&&const DeepCollectionEquality().equals(other.similarProperties, similarProperties)&&(identical(other.distance, distance) || other.distance == distance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,slug,type,category,status,price,currency,size,sizeUnit,houseAge,address,city,state,country,postalCode,latitude,longitude,const DeepCollectionEquality().hash(amenities),const DeepCollectionEquality().hash(metadata),description,availableFrom,owner,const DeepCollectionEquality().hash(gallery),isFavorited,isAvailable,createdAt,updatedAt,videoUrl,virtualTourUrl,const DeepCollectionEquality().hash(nearbyPlaces),verifiedAt,const DeepCollectionEquality().hash(priceHistory),const DeepCollectionEquality().hash(similarProperties),distance]);

@override
String toString() {
  return 'Property(id: $id, title: $title, slug: $slug, type: $type, category: $category, status: $status, price: $price, currency: $currency, size: $size, sizeUnit: $sizeUnit, houseAge: $houseAge, address: $address, city: $city, state: $state, country: $country, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, amenities: $amenities, metadata: $metadata, description: $description, availableFrom: $availableFrom, owner: $owner, gallery: $gallery, isFavorited: $isFavorited, isAvailable: $isAvailable, createdAt: $createdAt, updatedAt: $updatedAt, videoUrl: $videoUrl, virtualTourUrl: $virtualTourUrl, nearbyPlaces: $nearbyPlaces, verifiedAt: $verifiedAt, priceHistory: $priceHistory, similarProperties: $similarProperties, distance: $distance)';
}


}

/// @nodoc
abstract mixin class $PropertyCopyWith<$Res>  {
  factory $PropertyCopyWith(Property value, $Res Function(Property) _then) = _$PropertyCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? slug, String? type, String? category, String? status,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? price, String? currency,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? size, String? sizeUnit,@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? houseAge, String? address, String? city, String? state, String? country, String? postalCode,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? latitude,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? longitude, List<String>? amenities,@JsonKey(fromJson: _metadataFromJson) Map<String, dynamic>? metadata, String? description, DateTime? availableFrom, PropertyUserSummary? owner, List<PropertyMedia>? gallery, bool? isFavorited, bool? isAvailable, DateTime? createdAt, DateTime? updatedAt, String? videoUrl, String? virtualTourUrl, List<Map<String, dynamic>>? nearbyPlaces, DateTime? verifiedAt, List<PropertyPriceHistory>? priceHistory, List<Property>? similarProperties,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? distance
});


$PropertyUserSummaryCopyWith<$Res>? get owner;

}
/// @nodoc
class _$PropertyCopyWithImpl<$Res>
    implements $PropertyCopyWith<$Res> {
  _$PropertyCopyWithImpl(this._self, this._then);

  final Property _self;
  final $Res Function(Property) _then;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? slug = freezed,Object? type = freezed,Object? category = freezed,Object? status = freezed,Object? price = freezed,Object? currency = freezed,Object? size = freezed,Object? sizeUnit = freezed,Object? houseAge = freezed,Object? address = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,Object? postalCode = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? amenities = freezed,Object? metadata = freezed,Object? description = freezed,Object? availableFrom = freezed,Object? owner = freezed,Object? gallery = freezed,Object? isFavorited = freezed,Object? isAvailable = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? videoUrl = freezed,Object? virtualTourUrl = freezed,Object? nearbyPlaces = freezed,Object? verifiedAt = freezed,Object? priceHistory = freezed,Object? similarProperties = freezed,Object? distance = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double?,sizeUnit: freezed == sizeUnit ? _self.sizeUnit : sizeUnit // ignore: cast_nullable_to_non_nullable
as String?,houseAge: freezed == houseAge ? _self.houseAge : houseAge // ignore: cast_nullable_to_non_nullable
as int?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,amenities: freezed == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,availableFrom: freezed == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as PropertyUserSummary?,gallery: freezed == gallery ? _self.gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<PropertyMedia>?,isFavorited: freezed == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,virtualTourUrl: freezed == virtualTourUrl ? _self.virtualTourUrl : virtualTourUrl // ignore: cast_nullable_to_non_nullable
as String?,nearbyPlaces: freezed == nearbyPlaces ? _self.nearbyPlaces : nearbyPlaces // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,priceHistory: freezed == priceHistory ? _self.priceHistory : priceHistory // ignore: cast_nullable_to_non_nullable
as List<PropertyPriceHistory>?,similarProperties: freezed == similarProperties ? _self.similarProperties : similarProperties // ignore: cast_nullable_to_non_nullable
as List<Property>?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PropertyUserSummaryCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $PropertyUserSummaryCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// Adds pattern-matching-related methods to [Property].
extension PropertyPatterns on Property {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Property value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Property() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Property value)  $default,){
final _that = this;
switch (_that) {
case _Property():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Property value)?  $default,){
final _that = this;
switch (_that) {
case _Property() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? slug,  String? type,  String? category,  String? status, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? price,  String? currency, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? size,  String? sizeUnit, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? houseAge,  String? address,  String? city,  String? state,  String? country,  String? postalCode, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? latitude, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? longitude,  List<String>? amenities, @JsonKey(fromJson: _metadataFromJson)  Map<String, dynamic>? metadata,  String? description,  DateTime? availableFrom,  PropertyUserSummary? owner,  List<PropertyMedia>? gallery,  bool? isFavorited,  bool? isAvailable,  DateTime? createdAt,  DateTime? updatedAt,  String? videoUrl,  String? virtualTourUrl,  List<Map<String, dynamic>>? nearbyPlaces,  DateTime? verifiedAt,  List<PropertyPriceHistory>? priceHistory,  List<Property>? similarProperties, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? distance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.type,_that.category,_that.status,_that.price,_that.currency,_that.size,_that.sizeUnit,_that.houseAge,_that.address,_that.city,_that.state,_that.country,_that.postalCode,_that.latitude,_that.longitude,_that.amenities,_that.metadata,_that.description,_that.availableFrom,_that.owner,_that.gallery,_that.isFavorited,_that.isAvailable,_that.createdAt,_that.updatedAt,_that.videoUrl,_that.virtualTourUrl,_that.nearbyPlaces,_that.verifiedAt,_that.priceHistory,_that.similarProperties,_that.distance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? slug,  String? type,  String? category,  String? status, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? price,  String? currency, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? size,  String? sizeUnit, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? houseAge,  String? address,  String? city,  String? state,  String? country,  String? postalCode, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? latitude, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? longitude,  List<String>? amenities, @JsonKey(fromJson: _metadataFromJson)  Map<String, dynamic>? metadata,  String? description,  DateTime? availableFrom,  PropertyUserSummary? owner,  List<PropertyMedia>? gallery,  bool? isFavorited,  bool? isAvailable,  DateTime? createdAt,  DateTime? updatedAt,  String? videoUrl,  String? virtualTourUrl,  List<Map<String, dynamic>>? nearbyPlaces,  DateTime? verifiedAt,  List<PropertyPriceHistory>? priceHistory,  List<Property>? similarProperties, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? distance)  $default,) {final _that = this;
switch (_that) {
case _Property():
return $default(_that.id,_that.title,_that.slug,_that.type,_that.category,_that.status,_that.price,_that.currency,_that.size,_that.sizeUnit,_that.houseAge,_that.address,_that.city,_that.state,_that.country,_that.postalCode,_that.latitude,_that.longitude,_that.amenities,_that.metadata,_that.description,_that.availableFrom,_that.owner,_that.gallery,_that.isFavorited,_that.isAvailable,_that.createdAt,_that.updatedAt,_that.videoUrl,_that.virtualTourUrl,_that.nearbyPlaces,_that.verifiedAt,_that.priceHistory,_that.similarProperties,_that.distance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? slug,  String? type,  String? category,  String? status, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? price,  String? currency, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? size,  String? sizeUnit, @JsonKey(fromJson: _intFromJson, toJson: _intToJson)  int? houseAge,  String? address,  String? city,  String? state,  String? country,  String? postalCode, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? latitude, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? longitude,  List<String>? amenities, @JsonKey(fromJson: _metadataFromJson)  Map<String, dynamic>? metadata,  String? description,  DateTime? availableFrom,  PropertyUserSummary? owner,  List<PropertyMedia>? gallery,  bool? isFavorited,  bool? isAvailable,  DateTime? createdAt,  DateTime? updatedAt,  String? videoUrl,  String? virtualTourUrl,  List<Map<String, dynamic>>? nearbyPlaces,  DateTime? verifiedAt,  List<PropertyPriceHistory>? priceHistory,  List<Property>? similarProperties, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)  double? distance)?  $default,) {final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that.id,_that.title,_that.slug,_that.type,_that.category,_that.status,_that.price,_that.currency,_that.size,_that.sizeUnit,_that.houseAge,_that.address,_that.city,_that.state,_that.country,_that.postalCode,_that.latitude,_that.longitude,_that.amenities,_that.metadata,_that.description,_that.availableFrom,_that.owner,_that.gallery,_that.isFavorited,_that.isAvailable,_that.createdAt,_that.updatedAt,_that.videoUrl,_that.virtualTourUrl,_that.nearbyPlaces,_that.verifiedAt,_that.priceHistory,_that.similarProperties,_that.distance);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _Property implements Property {
  const _Property({required this.id, required this.title, this.slug, this.type, this.category, this.status, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) this.price, this.currency, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) this.size, this.sizeUnit, @JsonKey(fromJson: _intFromJson, toJson: _intToJson) this.houseAge, this.address, this.city, this.state, this.country, this.postalCode, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) this.latitude, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) this.longitude, final  List<String>? amenities, @JsonKey(fromJson: _metadataFromJson) final  Map<String, dynamic>? metadata, this.description, this.availableFrom, this.owner, final  List<PropertyMedia>? gallery, this.isFavorited, this.isAvailable, this.createdAt, this.updatedAt, this.videoUrl, this.virtualTourUrl, final  List<Map<String, dynamic>>? nearbyPlaces, this.verifiedAt, final  List<PropertyPriceHistory>? priceHistory, final  List<Property>? similarProperties, @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) this.distance}): _amenities = amenities,_metadata = metadata,_gallery = gallery,_nearbyPlaces = nearbyPlaces,_priceHistory = priceHistory,_similarProperties = similarProperties;
  factory _Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? slug;
@override final  String? type;
@override final  String? category;
@override final  String? status;
@override@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) final  double? price;
@override final  String? currency;
@override@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) final  double? size;
@override final  String? sizeUnit;
@override@JsonKey(fromJson: _intFromJson, toJson: _intToJson) final  int? houseAge;
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

 final  Map<String, dynamic>? _metadata;
@override@JsonKey(fromJson: _metadataFromJson) Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? description;
@override final  DateTime? availableFrom;
@override final  PropertyUserSummary? owner;
 final  List<PropertyMedia>? _gallery;
@override List<PropertyMedia>? get gallery {
  final value = _gallery;
  if (value == null) return null;
  if (_gallery is EqualUnmodifiableListView) return _gallery;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? isFavorited;
@override final  bool? isAvailable;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  String? videoUrl;
@override final  String? virtualTourUrl;
 final  List<Map<String, dynamic>>? _nearbyPlaces;
@override List<Map<String, dynamic>>? get nearbyPlaces {
  final value = _nearbyPlaces;
  if (value == null) return null;
  if (_nearbyPlaces is EqualUnmodifiableListView) return _nearbyPlaces;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? verifiedAt;
 final  List<PropertyPriceHistory>? _priceHistory;
@override List<PropertyPriceHistory>? get priceHistory {
  final value = _priceHistory;
  if (value == null) return null;
  if (_priceHistory is EqualUnmodifiableListView) return _priceHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Property>? _similarProperties;
@override List<Property>? get similarProperties {
  final value = _similarProperties;
  if (value == null) return null;
  if (_similarProperties is EqualUnmodifiableListView) return _similarProperties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) final  double? distance;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyCopyWith<_Property> get copyWith => __$PropertyCopyWithImpl<_Property>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Property&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.status, status) || other.status == status)&&(identical(other.price, price) || other.price == price)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.size, size) || other.size == size)&&(identical(other.sizeUnit, sizeUnit) || other.sizeUnit == sizeUnit)&&(identical(other.houseAge, houseAge) || other.houseAge == houseAge)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.description, description) || other.description == description)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.owner, owner) || other.owner == owner)&&const DeepCollectionEquality().equals(other._gallery, _gallery)&&(identical(other.isFavorited, isFavorited) || other.isFavorited == isFavorited)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.virtualTourUrl, virtualTourUrl) || other.virtualTourUrl == virtualTourUrl)&&const DeepCollectionEquality().equals(other._nearbyPlaces, _nearbyPlaces)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&const DeepCollectionEquality().equals(other._priceHistory, _priceHistory)&&const DeepCollectionEquality().equals(other._similarProperties, _similarProperties)&&(identical(other.distance, distance) || other.distance == distance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,slug,type,category,status,price,currency,size,sizeUnit,houseAge,address,city,state,country,postalCode,latitude,longitude,const DeepCollectionEquality().hash(_amenities),const DeepCollectionEquality().hash(_metadata),description,availableFrom,owner,const DeepCollectionEquality().hash(_gallery),isFavorited,isAvailable,createdAt,updatedAt,videoUrl,virtualTourUrl,const DeepCollectionEquality().hash(_nearbyPlaces),verifiedAt,const DeepCollectionEquality().hash(_priceHistory),const DeepCollectionEquality().hash(_similarProperties),distance]);

@override
String toString() {
  return 'Property(id: $id, title: $title, slug: $slug, type: $type, category: $category, status: $status, price: $price, currency: $currency, size: $size, sizeUnit: $sizeUnit, houseAge: $houseAge, address: $address, city: $city, state: $state, country: $country, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, amenities: $amenities, metadata: $metadata, description: $description, availableFrom: $availableFrom, owner: $owner, gallery: $gallery, isFavorited: $isFavorited, isAvailable: $isAvailable, createdAt: $createdAt, updatedAt: $updatedAt, videoUrl: $videoUrl, virtualTourUrl: $virtualTourUrl, nearbyPlaces: $nearbyPlaces, verifiedAt: $verifiedAt, priceHistory: $priceHistory, similarProperties: $similarProperties, distance: $distance)';
}


}

/// @nodoc
abstract mixin class _$PropertyCopyWith<$Res> implements $PropertyCopyWith<$Res> {
  factory _$PropertyCopyWith(_Property value, $Res Function(_Property) _then) = __$PropertyCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? slug, String? type, String? category, String? status,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? price, String? currency,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? size, String? sizeUnit,@JsonKey(fromJson: _intFromJson, toJson: _intToJson) int? houseAge, String? address, String? city, String? state, String? country, String? postalCode,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? latitude,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? longitude, List<String>? amenities,@JsonKey(fromJson: _metadataFromJson) Map<String, dynamic>? metadata, String? description, DateTime? availableFrom, PropertyUserSummary? owner, List<PropertyMedia>? gallery, bool? isFavorited, bool? isAvailable, DateTime? createdAt, DateTime? updatedAt, String? videoUrl, String? virtualTourUrl, List<Map<String, dynamic>>? nearbyPlaces, DateTime? verifiedAt, List<PropertyPriceHistory>? priceHistory, List<Property>? similarProperties,@JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson) double? distance
});


@override $PropertyUserSummaryCopyWith<$Res>? get owner;

}
/// @nodoc
class __$PropertyCopyWithImpl<$Res>
    implements _$PropertyCopyWith<$Res> {
  __$PropertyCopyWithImpl(this._self, this._then);

  final _Property _self;
  final $Res Function(_Property) _then;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? slug = freezed,Object? type = freezed,Object? category = freezed,Object? status = freezed,Object? price = freezed,Object? currency = freezed,Object? size = freezed,Object? sizeUnit = freezed,Object? houseAge = freezed,Object? address = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,Object? postalCode = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? amenities = freezed,Object? metadata = freezed,Object? description = freezed,Object? availableFrom = freezed,Object? owner = freezed,Object? gallery = freezed,Object? isFavorited = freezed,Object? isAvailable = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? videoUrl = freezed,Object? virtualTourUrl = freezed,Object? nearbyPlaces = freezed,Object? verifiedAt = freezed,Object? priceHistory = freezed,Object? similarProperties = freezed,Object? distance = freezed,}) {
  return _then(_Property(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double?,sizeUnit: freezed == sizeUnit ? _self.sizeUnit : sizeUnit // ignore: cast_nullable_to_non_nullable
as String?,houseAge: freezed == houseAge ? _self.houseAge : houseAge // ignore: cast_nullable_to_non_nullable
as int?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,amenities: freezed == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,availableFrom: freezed == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as PropertyUserSummary?,gallery: freezed == gallery ? _self._gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<PropertyMedia>?,isFavorited: freezed == isFavorited ? _self.isFavorited : isFavorited // ignore: cast_nullable_to_non_nullable
as bool?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,virtualTourUrl: freezed == virtualTourUrl ? _self.virtualTourUrl : virtualTourUrl // ignore: cast_nullable_to_non_nullable
as String?,nearbyPlaces: freezed == nearbyPlaces ? _self._nearbyPlaces : nearbyPlaces // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,priceHistory: freezed == priceHistory ? _self._priceHistory : priceHistory // ignore: cast_nullable_to_non_nullable
as List<PropertyPriceHistory>?,similarProperties: freezed == similarProperties ? _self._similarProperties : similarProperties // ignore: cast_nullable_to_non_nullable
as List<Property>?,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PropertyUserSummaryCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $PropertyUserSummaryCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// @nodoc
mixin _$PropertyMedia {

 String? get id; String get name; String? get caption; String get url; String? get thumbnailUrl; String? get previewUrl;
/// Create a copy of PropertyMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyMediaCopyWith<PropertyMedia> get copyWith => _$PropertyMediaCopyWithImpl<PropertyMedia>(this as PropertyMedia, _$identity);

  /// Serializes this PropertyMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,caption,url,thumbnailUrl,previewUrl);

@override
String toString() {
  return 'PropertyMedia(id: $id, name: $name, caption: $caption, url: $url, thumbnailUrl: $thumbnailUrl, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class $PropertyMediaCopyWith<$Res>  {
  factory $PropertyMediaCopyWith(PropertyMedia value, $Res Function(PropertyMedia) _then) = _$PropertyMediaCopyWithImpl;
@useResult
$Res call({
 String? id, String name, String? caption, String url, String? thumbnailUrl, String? previewUrl
});




}
/// @nodoc
class _$PropertyMediaCopyWithImpl<$Res>
    implements $PropertyMediaCopyWith<$Res> {
  _$PropertyMediaCopyWithImpl(this._self, this._then);

  final PropertyMedia _self;
  final $Res Function(PropertyMedia) _then;

/// Create a copy of PropertyMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? caption = freezed,Object? url = null,Object? thumbnailUrl = freezed,Object? previewUrl = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyMedia].
extension PropertyMediaPatterns on PropertyMedia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyMedia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyMedia value)  $default,){
final _that = this;
switch (_that) {
case _PropertyMedia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyMedia value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyMedia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  String? caption,  String url,  String? thumbnailUrl,  String? previewUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyMedia() when $default != null:
return $default(_that.id,_that.name,_that.caption,_that.url,_that.thumbnailUrl,_that.previewUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  String? caption,  String url,  String? thumbnailUrl,  String? previewUrl)  $default,) {final _that = this;
switch (_that) {
case _PropertyMedia():
return $default(_that.id,_that.name,_that.caption,_that.url,_that.thumbnailUrl,_that.previewUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  String? caption,  String url,  String? thumbnailUrl,  String? previewUrl)?  $default,) {final _that = this;
switch (_that) {
case _PropertyMedia() when $default != null:
return $default(_that.id,_that.name,_that.caption,_that.url,_that.thumbnailUrl,_that.previewUrl);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _PropertyMedia implements PropertyMedia {
  const _PropertyMedia({this.id, required this.name, this.caption, required this.url, this.thumbnailUrl, this.previewUrl});
  factory _PropertyMedia.fromJson(Map<String, dynamic> json) => _$PropertyMediaFromJson(json);

@override final  String? id;
@override final  String name;
@override final  String? caption;
@override final  String url;
@override final  String? thumbnailUrl;
@override final  String? previewUrl;

/// Create a copy of PropertyMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyMediaCopyWith<_PropertyMedia> get copyWith => __$PropertyMediaCopyWithImpl<_PropertyMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,caption,url,thumbnailUrl,previewUrl);

@override
String toString() {
  return 'PropertyMedia(id: $id, name: $name, caption: $caption, url: $url, thumbnailUrl: $thumbnailUrl, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class _$PropertyMediaCopyWith<$Res> implements $PropertyMediaCopyWith<$Res> {
  factory _$PropertyMediaCopyWith(_PropertyMedia value, $Res Function(_PropertyMedia) _then) = __$PropertyMediaCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, String? caption, String url, String? thumbnailUrl, String? previewUrl
});




}
/// @nodoc
class __$PropertyMediaCopyWithImpl<$Res>
    implements _$PropertyMediaCopyWith<$Res> {
  __$PropertyMediaCopyWithImpl(this._self, this._then);

  final _PropertyMedia _self;
  final $Res Function(_PropertyMedia) _then;

/// Create a copy of PropertyMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? caption = freezed,Object? url = null,Object? thumbnailUrl = freezed,Object? previewUrl = freezed,}) {
  return _then(_PropertyMedia(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PropertyUserSummary {

 int get id; String get name; String? get preferredRole;
/// Create a copy of PropertyUserSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyUserSummaryCopyWith<PropertyUserSummary> get copyWith => _$PropertyUserSummaryCopyWithImpl<PropertyUserSummary>(this as PropertyUserSummary, _$identity);

  /// Serializes this PropertyUserSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyUserSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.preferredRole, preferredRole) || other.preferredRole == preferredRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,preferredRole);

@override
String toString() {
  return 'PropertyUserSummary(id: $id, name: $name, preferredRole: $preferredRole)';
}


}

/// @nodoc
abstract mixin class $PropertyUserSummaryCopyWith<$Res>  {
  factory $PropertyUserSummaryCopyWith(PropertyUserSummary value, $Res Function(PropertyUserSummary) _then) = _$PropertyUserSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? preferredRole
});




}
/// @nodoc
class _$PropertyUserSummaryCopyWithImpl<$Res>
    implements $PropertyUserSummaryCopyWith<$Res> {
  _$PropertyUserSummaryCopyWithImpl(this._self, this._then);

  final PropertyUserSummary _self;
  final $Res Function(PropertyUserSummary) _then;

/// Create a copy of PropertyUserSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? preferredRole = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,preferredRole: freezed == preferredRole ? _self.preferredRole : preferredRole // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyUserSummary].
extension PropertyUserSummaryPatterns on PropertyUserSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyUserSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyUserSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyUserSummary value)  $default,){
final _that = this;
switch (_that) {
case _PropertyUserSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyUserSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyUserSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? preferredRole)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyUserSummary() when $default != null:
return $default(_that.id,_that.name,_that.preferredRole);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? preferredRole)  $default,) {final _that = this;
switch (_that) {
case _PropertyUserSummary():
return $default(_that.id,_that.name,_that.preferredRole);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? preferredRole)?  $default,) {final _that = this;
switch (_that) {
case _PropertyUserSummary() when $default != null:
return $default(_that.id,_that.name,_that.preferredRole);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _PropertyUserSummary extends PropertyUserSummary {
  const _PropertyUserSummary({required this.id, required this.name, this.preferredRole}): super._();
  factory _PropertyUserSummary.fromJson(Map<String, dynamic> json) => _$PropertyUserSummaryFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? preferredRole;

/// Create a copy of PropertyUserSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyUserSummaryCopyWith<_PropertyUserSummary> get copyWith => __$PropertyUserSummaryCopyWithImpl<_PropertyUserSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyUserSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyUserSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.preferredRole, preferredRole) || other.preferredRole == preferredRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,preferredRole);

@override
String toString() {
  return 'PropertyUserSummary(id: $id, name: $name, preferredRole: $preferredRole)';
}


}

/// @nodoc
abstract mixin class _$PropertyUserSummaryCopyWith<$Res> implements $PropertyUserSummaryCopyWith<$Res> {
  factory _$PropertyUserSummaryCopyWith(_PropertyUserSummary value, $Res Function(_PropertyUserSummary) _then) = __$PropertyUserSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? preferredRole
});




}
/// @nodoc
class __$PropertyUserSummaryCopyWithImpl<$Res>
    implements _$PropertyUserSummaryCopyWith<$Res> {
  __$PropertyUserSummaryCopyWithImpl(this._self, this._then);

  final _PropertyUserSummary _self;
  final $Res Function(_PropertyUserSummary) _then;

/// Create a copy of PropertyUserSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? preferredRole = freezed,}) {
  return _then(_PropertyUserSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,preferredRole: freezed == preferredRole ? _self.preferredRole : preferredRole // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
