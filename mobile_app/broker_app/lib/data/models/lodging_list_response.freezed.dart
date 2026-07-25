// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lodging_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LodgingListResponse {

 List<Lodging> get data; PaginationMeta get meta;
/// Create a copy of LodgingListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LodgingListResponseCopyWith<LodgingListResponse> get copyWith => _$LodgingListResponseCopyWithImpl<LodgingListResponse>(this as LodgingListResponse, _$identity);

  /// Serializes this LodgingListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LodgingListResponse&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),meta);

@override
String toString() {
  return 'LodgingListResponse(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $LodgingListResponseCopyWith<$Res>  {
  factory $LodgingListResponseCopyWith(LodgingListResponse value, $Res Function(LodgingListResponse) _then) = _$LodgingListResponseCopyWithImpl;
@useResult
$Res call({
 List<Lodging> data, PaginationMeta meta
});




}
/// @nodoc
class _$LodgingListResponseCopyWithImpl<$Res>
    implements $LodgingListResponseCopyWith<$Res> {
  _$LodgingListResponseCopyWithImpl(this._self, this._then);

  final LodgingListResponse _self;
  final $Res Function(LodgingListResponse) _then;

/// Create a copy of LodgingListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? meta = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Lodging>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}

}


/// Adds pattern-matching-related methods to [LodgingListResponse].
extension LodgingListResponsePatterns on LodgingListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LodgingListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LodgingListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LodgingListResponse value)  $default,){
final _that = this;
switch (_that) {
case _LodgingListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LodgingListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LodgingListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Lodging> data,  PaginationMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LodgingListResponse() when $default != null:
return $default(_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Lodging> data,  PaginationMeta meta)  $default,) {final _that = this;
switch (_that) {
case _LodgingListResponse():
return $default(_that.data,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Lodging> data,  PaginationMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _LodgingListResponse() when $default != null:
return $default(_that.data,_that.meta);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _LodgingListResponse implements LodgingListResponse {
  const _LodgingListResponse({final  List<Lodging> data = const [], required this.meta}): _data = data;
  factory _LodgingListResponse.fromJson(Map<String, dynamic> json) => _$LodgingListResponseFromJson(json);

 final  List<Lodging> _data;
@override@JsonKey() List<Lodging> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  PaginationMeta meta;

/// Create a copy of LodgingListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LodgingListResponseCopyWith<_LodgingListResponse> get copyWith => __$LodgingListResponseCopyWithImpl<_LodgingListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LodgingListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LodgingListResponse&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),meta);

@override
String toString() {
  return 'LodgingListResponse(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$LodgingListResponseCopyWith<$Res> implements $LodgingListResponseCopyWith<$Res> {
  factory _$LodgingListResponseCopyWith(_LodgingListResponse value, $Res Function(_LodgingListResponse) _then) = __$LodgingListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Lodging> data, PaginationMeta meta
});




}
/// @nodoc
class __$LodgingListResponseCopyWithImpl<$Res>
    implements _$LodgingListResponseCopyWith<$Res> {
  __$LodgingListResponseCopyWithImpl(this._self, this._then);

  final _LodgingListResponse _self;
  final $Res Function(_LodgingListResponse) _then;

/// Create a copy of LodgingListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? meta = null,}) {
  return _then(_LodgingListResponse(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Lodging>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as PaginationMeta,
  ));
}


}

// dart format on
