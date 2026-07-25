// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_price_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PropertyPriceHistory {

 int? get id;@JsonKey(fromJson: _doubleFromJson) double? get oldPrice;@JsonKey(fromJson: _doubleFromJson) double? get newPrice; DateTime? get changedAt;
/// Create a copy of PropertyPriceHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyPriceHistoryCopyWith<PropertyPriceHistory> get copyWith => _$PropertyPriceHistoryCopyWithImpl<PropertyPriceHistory>(this as PropertyPriceHistory, _$identity);

  /// Serializes this PropertyPriceHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyPriceHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.oldPrice, oldPrice) || other.oldPrice == oldPrice)&&(identical(other.newPrice, newPrice) || other.newPrice == newPrice)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,oldPrice,newPrice,changedAt);

@override
String toString() {
  return 'PropertyPriceHistory(id: $id, oldPrice: $oldPrice, newPrice: $newPrice, changedAt: $changedAt)';
}


}

/// @nodoc
abstract mixin class $PropertyPriceHistoryCopyWith<$Res>  {
  factory $PropertyPriceHistoryCopyWith(PropertyPriceHistory value, $Res Function(PropertyPriceHistory) _then) = _$PropertyPriceHistoryCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(fromJson: _doubleFromJson) double? oldPrice,@JsonKey(fromJson: _doubleFromJson) double? newPrice, DateTime? changedAt
});




}
/// @nodoc
class _$PropertyPriceHistoryCopyWithImpl<$Res>
    implements $PropertyPriceHistoryCopyWith<$Res> {
  _$PropertyPriceHistoryCopyWithImpl(this._self, this._then);

  final PropertyPriceHistory _self;
  final $Res Function(PropertyPriceHistory) _then;

/// Create a copy of PropertyPriceHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? oldPrice = freezed,Object? newPrice = freezed,Object? changedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,oldPrice: freezed == oldPrice ? _self.oldPrice : oldPrice // ignore: cast_nullable_to_non_nullable
as double?,newPrice: freezed == newPrice ? _self.newPrice : newPrice // ignore: cast_nullable_to_non_nullable
as double?,changedAt: freezed == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyPriceHistory].
extension PropertyPriceHistoryPatterns on PropertyPriceHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyPriceHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyPriceHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyPriceHistory value)  $default,){
final _that = this;
switch (_that) {
case _PropertyPriceHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyPriceHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyPriceHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(fromJson: _doubleFromJson)  double? oldPrice, @JsonKey(fromJson: _doubleFromJson)  double? newPrice,  DateTime? changedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyPriceHistory() when $default != null:
return $default(_that.id,_that.oldPrice,_that.newPrice,_that.changedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(fromJson: _doubleFromJson)  double? oldPrice, @JsonKey(fromJson: _doubleFromJson)  double? newPrice,  DateTime? changedAt)  $default,) {final _that = this;
switch (_that) {
case _PropertyPriceHistory():
return $default(_that.id,_that.oldPrice,_that.newPrice,_that.changedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(fromJson: _doubleFromJson)  double? oldPrice, @JsonKey(fromJson: _doubleFromJson)  double? newPrice,  DateTime? changedAt)?  $default,) {final _that = this;
switch (_that) {
case _PropertyPriceHistory() when $default != null:
return $default(_that.id,_that.oldPrice,_that.newPrice,_that.changedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _PropertyPriceHistory implements PropertyPriceHistory {
  const _PropertyPriceHistory({this.id, @JsonKey(fromJson: _doubleFromJson) this.oldPrice, @JsonKey(fromJson: _doubleFromJson) this.newPrice, this.changedAt});
  factory _PropertyPriceHistory.fromJson(Map<String, dynamic> json) => _$PropertyPriceHistoryFromJson(json);

@override final  int? id;
@override@JsonKey(fromJson: _doubleFromJson) final  double? oldPrice;
@override@JsonKey(fromJson: _doubleFromJson) final  double? newPrice;
@override final  DateTime? changedAt;

/// Create a copy of PropertyPriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyPriceHistoryCopyWith<_PropertyPriceHistory> get copyWith => __$PropertyPriceHistoryCopyWithImpl<_PropertyPriceHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyPriceHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyPriceHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.oldPrice, oldPrice) || other.oldPrice == oldPrice)&&(identical(other.newPrice, newPrice) || other.newPrice == newPrice)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,oldPrice,newPrice,changedAt);

@override
String toString() {
  return 'PropertyPriceHistory(id: $id, oldPrice: $oldPrice, newPrice: $newPrice, changedAt: $changedAt)';
}


}

/// @nodoc
abstract mixin class _$PropertyPriceHistoryCopyWith<$Res> implements $PropertyPriceHistoryCopyWith<$Res> {
  factory _$PropertyPriceHistoryCopyWith(_PropertyPriceHistory value, $Res Function(_PropertyPriceHistory) _then) = __$PropertyPriceHistoryCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(fromJson: _doubleFromJson) double? oldPrice,@JsonKey(fromJson: _doubleFromJson) double? newPrice, DateTime? changedAt
});




}
/// @nodoc
class __$PropertyPriceHistoryCopyWithImpl<$Res>
    implements _$PropertyPriceHistoryCopyWith<$Res> {
  __$PropertyPriceHistoryCopyWithImpl(this._self, this._then);

  final _PropertyPriceHistory _self;
  final $Res Function(_PropertyPriceHistory) _then;

/// Create a copy of PropertyPriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? oldPrice = freezed,Object? newPrice = freezed,Object? changedAt = freezed,}) {
  return _then(_PropertyPriceHistory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,oldPrice: freezed == oldPrice ? _self.oldPrice : oldPrice // ignore: cast_nullable_to_non_nullable
as double?,newPrice: freezed == newPrice ? _self.newPrice : newPrice // ignore: cast_nullable_to_non_nullable
as double?,changedAt: freezed == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
