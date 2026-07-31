// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PropertyListResponse {

 List<Property> get data; PaginationMeta get meta; PaginationLinks get links;
/// Create a copy of PropertyListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyListResponseCopyWith<PropertyListResponse> get copyWith => _$PropertyListResponseCopyWithImpl<PropertyListResponse>(this as PropertyListResponse, _$identity);

  /// Serializes this PropertyListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyListResponse&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.links, links) || other.links == links));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),meta,links);

@override
String toString() {
  return 'PropertyListResponse(data: $data, meta: $meta, links: $links)';
}


}

/// @nodoc
abstract mixin class $PropertyListResponseCopyWith<$Res>  {
  factory $PropertyListResponseCopyWith(PropertyListResponse value, $Res Function(PropertyListResponse) _then) = _$PropertyListResponseCopyWithImpl;
@useResult
$Res call({
 List<Property> data, PaginationMeta meta, PaginationLinks links
});




}
/// @nodoc
class _$PropertyListResponseCopyWithImpl<$Res>
    implements $PropertyListResponseCopyWith<$Res> {
  _$PropertyListResponseCopyWithImpl(this._self, this._then);

  final PropertyListResponse _self;
  final $Res Function(PropertyListResponse) _then;

/// Create a copy of PropertyListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? meta = null,Object? links = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Property>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as PaginationLinks,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyListResponse].
extension PropertyListResponsePatterns on PropertyListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyListResponse value)  $default,){
final _that = this;
switch (_that) {
case _PropertyListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Property> data,  PaginationMeta meta,  PaginationLinks links)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyListResponse() when $default != null:
return $default(_that.data,_that.meta,_that.links);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Property> data,  PaginationMeta meta,  PaginationLinks links)  $default,) {final _that = this;
switch (_that) {
case _PropertyListResponse():
return $default(_that.data,_that.meta,_that.links);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Property> data,  PaginationMeta meta,  PaginationLinks links)?  $default,) {final _that = this;
switch (_that) {
case _PropertyListResponse() when $default != null:
return $default(_that.data,_that.meta,_that.links);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PropertyListResponse implements PropertyListResponse {
  const _PropertyListResponse({final  List<Property> data = const [], required this.meta, required this.links}): _data = data;
  factory _PropertyListResponse.fromJson(Map<String, dynamic> json) => _$PropertyListResponseFromJson(json);

 final  List<Property> _data;
@override@JsonKey() List<Property> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  PaginationMeta meta;
@override final  PaginationLinks links;

/// Create a copy of PropertyListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyListResponseCopyWith<_PropertyListResponse> get copyWith => __$PropertyListResponseCopyWithImpl<_PropertyListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyListResponse&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.links, links) || other.links == links));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),meta,links);

@override
String toString() {
  return 'PropertyListResponse(data: $data, meta: $meta, links: $links)';
}


}

/// @nodoc
abstract mixin class _$PropertyListResponseCopyWith<$Res> implements $PropertyListResponseCopyWith<$Res> {
  factory _$PropertyListResponseCopyWith(_PropertyListResponse value, $Res Function(_PropertyListResponse) _then) = __$PropertyListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Property> data, PaginationMeta meta, PaginationLinks links
});




}
/// @nodoc
class __$PropertyListResponseCopyWithImpl<$Res>
    implements _$PropertyListResponseCopyWith<$Res> {
  __$PropertyListResponseCopyWithImpl(this._self, this._then);

  final _PropertyListResponse _self;
  final $Res Function(_PropertyListResponse) _then;

/// Create a copy of PropertyListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? meta = null,Object? links = null,}) {
  return _then(_PropertyListResponse(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Property>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as PaginationLinks,
  ));
}


}

// dart format on
