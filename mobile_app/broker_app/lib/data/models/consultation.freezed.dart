// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Consultation {

 int get id; String get publicId; int get userId; int get professionalId; DateTime get scheduledAt; String get status; String? get notes; User? get user; User? get professional; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Consultation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsultationCopyWith<Consultation> get copyWith => _$ConsultationCopyWithImpl<Consultation>(this as Consultation, _$identity);

  /// Serializes this Consultation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Consultation&&(identical(other.id, id) || other.id == id)&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.professionalId, professionalId) || other.professionalId == professionalId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.user, user) || other.user == user)&&(identical(other.professional, professional) || other.professional == professional)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,publicId,userId,professionalId,scheduledAt,status,notes,user,professional,createdAt,updatedAt);

@override
String toString() {
  return 'Consultation(id: $id, publicId: $publicId, userId: $userId, professionalId: $professionalId, scheduledAt: $scheduledAt, status: $status, notes: $notes, user: $user, professional: $professional, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ConsultationCopyWith<$Res>  {
  factory $ConsultationCopyWith(Consultation value, $Res Function(Consultation) _then) = _$ConsultationCopyWithImpl;
@useResult
$Res call({
 int id, String publicId, int userId, int professionalId, DateTime scheduledAt, String status, String? notes, User? user, User? professional, DateTime createdAt, DateTime updatedAt
});


$UserCopyWith<$Res>? get user;$UserCopyWith<$Res>? get professional;

}
/// @nodoc
class _$ConsultationCopyWithImpl<$Res>
    implements $ConsultationCopyWith<$Res> {
  _$ConsultationCopyWithImpl(this._self, this._then);

  final Consultation _self;
  final $Res Function(Consultation) _then;

/// Create a copy of Consultation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? publicId = null,Object? userId = null,Object? professionalId = null,Object? scheduledAt = null,Object? status = null,Object? notes = freezed,Object? user = freezed,Object? professional = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,publicId: null == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,professionalId: null == professionalId ? _self.professionalId : professionalId // ignore: cast_nullable_to_non_nullable
as int,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,professional: freezed == professional ? _self.professional : professional // ignore: cast_nullable_to_non_nullable
as User?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Consultation
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
}/// Create a copy of Consultation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get professional {
    if (_self.professional == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.professional!, (value) {
    return _then(_self.copyWith(professional: value));
  });
}
}


/// Adds pattern-matching-related methods to [Consultation].
extension ConsultationPatterns on Consultation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Consultation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Consultation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Consultation value)  $default,){
final _that = this;
switch (_that) {
case _Consultation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Consultation value)?  $default,){
final _that = this;
switch (_that) {
case _Consultation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String publicId,  int userId,  int professionalId,  DateTime scheduledAt,  String status,  String? notes,  User? user,  User? professional,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Consultation() when $default != null:
return $default(_that.id,_that.publicId,_that.userId,_that.professionalId,_that.scheduledAt,_that.status,_that.notes,_that.user,_that.professional,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String publicId,  int userId,  int professionalId,  DateTime scheduledAt,  String status,  String? notes,  User? user,  User? professional,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Consultation():
return $default(_that.id,_that.publicId,_that.userId,_that.professionalId,_that.scheduledAt,_that.status,_that.notes,_that.user,_that.professional,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String publicId,  int userId,  int professionalId,  DateTime scheduledAt,  String status,  String? notes,  User? user,  User? professional,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Consultation() when $default != null:
return $default(_that.id,_that.publicId,_that.userId,_that.professionalId,_that.scheduledAt,_that.status,_that.notes,_that.user,_that.professional,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _Consultation implements Consultation {
  const _Consultation({required this.id, required this.publicId, required this.userId, required this.professionalId, required this.scheduledAt, required this.status, this.notes, this.user, this.professional, required this.createdAt, required this.updatedAt});
  factory _Consultation.fromJson(Map<String, dynamic> json) => _$ConsultationFromJson(json);

@override final  int id;
@override final  String publicId;
@override final  int userId;
@override final  int professionalId;
@override final  DateTime scheduledAt;
@override final  String status;
@override final  String? notes;
@override final  User? user;
@override final  User? professional;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Consultation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsultationCopyWith<_Consultation> get copyWith => __$ConsultationCopyWithImpl<_Consultation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsultationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Consultation&&(identical(other.id, id) || other.id == id)&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.professionalId, professionalId) || other.professionalId == professionalId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.user, user) || other.user == user)&&(identical(other.professional, professional) || other.professional == professional)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,publicId,userId,professionalId,scheduledAt,status,notes,user,professional,createdAt,updatedAt);

@override
String toString() {
  return 'Consultation(id: $id, publicId: $publicId, userId: $userId, professionalId: $professionalId, scheduledAt: $scheduledAt, status: $status, notes: $notes, user: $user, professional: $professional, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ConsultationCopyWith<$Res> implements $ConsultationCopyWith<$Res> {
  factory _$ConsultationCopyWith(_Consultation value, $Res Function(_Consultation) _then) = __$ConsultationCopyWithImpl;
@override @useResult
$Res call({
 int id, String publicId, int userId, int professionalId, DateTime scheduledAt, String status, String? notes, User? user, User? professional, DateTime createdAt, DateTime updatedAt
});


@override $UserCopyWith<$Res>? get user;@override $UserCopyWith<$Res>? get professional;

}
/// @nodoc
class __$ConsultationCopyWithImpl<$Res>
    implements _$ConsultationCopyWith<$Res> {
  __$ConsultationCopyWithImpl(this._self, this._then);

  final _Consultation _self;
  final $Res Function(_Consultation) _then;

/// Create a copy of Consultation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? publicId = null,Object? userId = null,Object? professionalId = null,Object? scheduledAt = null,Object? status = null,Object? notes = freezed,Object? user = freezed,Object? professional = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Consultation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,publicId: null == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,professionalId: null == professionalId ? _self.professionalId : professionalId // ignore: cast_nullable_to_non_nullable
as int,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,professional: freezed == professional ? _self.professional : professional // ignore: cast_nullable_to_non_nullable
as User?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Consultation
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
}/// Create a copy of Consultation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get professional {
    if (_self.professional == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.professional!, (value) {
    return _then(_self.copyWith(professional: value));
  });
}
}

// dart format on
