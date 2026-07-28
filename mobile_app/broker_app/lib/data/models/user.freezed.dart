// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 int get id; String get name; String get email; String? get phone; String? get countryCode; String get preferredRole; String get status; String? get bio; DateTime? get emailVerifiedAt; DateTime? get phoneVerifiedAt; DateTime? get lastLoginAt; DateTime get createdAt; DateTime get updatedAt; List<String> get roles; List<String> get permissions; String? get avatar; double get averageRating; int get ratingsCount;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.preferredRole, preferredRole) || other.preferredRole == preferredRole)&&(identical(other.status, status) || other.status == status)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.emailVerifiedAt, emailVerifiedAt) || other.emailVerifiedAt == emailVerifiedAt)&&(identical(other.phoneVerifiedAt, phoneVerifiedAt) || other.phoneVerifiedAt == phoneVerifiedAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.roles, roles)&&const DeepCollectionEquality().equals(other.permissions, permissions)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,countryCode,preferredRole,status,bio,emailVerifiedAt,phoneVerifiedAt,lastLoginAt,createdAt,updatedAt,const DeepCollectionEquality().hash(roles),const DeepCollectionEquality().hash(permissions),avatar,averageRating,ratingsCount);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, phone: $phone, countryCode: $countryCode, preferredRole: $preferredRole, status: $status, bio: $bio, emailVerifiedAt: $emailVerifiedAt, phoneVerifiedAt: $phoneVerifiedAt, lastLoginAt: $lastLoginAt, createdAt: $createdAt, updatedAt: $updatedAt, roles: $roles, permissions: $permissions, avatar: $avatar, averageRating: $averageRating, ratingsCount: $ratingsCount)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 int id, String name, String email, String? phone, String? countryCode, String preferredRole, String status, String? bio, DateTime? emailVerifiedAt, DateTime? phoneVerifiedAt, DateTime? lastLoginAt, DateTime createdAt, DateTime updatedAt, List<String> roles, List<String> permissions, String? avatar, double averageRating, int ratingsCount
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = freezed,Object? countryCode = freezed,Object? preferredRole = null,Object? status = null,Object? bio = freezed,Object? emailVerifiedAt = freezed,Object? phoneVerifiedAt = freezed,Object? lastLoginAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? roles = null,Object? permissions = null,Object? avatar = freezed,Object? averageRating = null,Object? ratingsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,preferredRole: null == preferredRole ? _self.preferredRole : preferredRole // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneVerifiedAt: freezed == phoneVerifiedAt ? _self.phoneVerifiedAt : phoneVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String email,  String? phone,  String? countryCode,  String preferredRole,  String status,  String? bio,  DateTime? emailVerifiedAt,  DateTime? phoneVerifiedAt,  DateTime? lastLoginAt,  DateTime createdAt,  DateTime updatedAt,  List<String> roles,  List<String> permissions,  String? avatar,  double averageRating,  int ratingsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.countryCode,_that.preferredRole,_that.status,_that.bio,_that.emailVerifiedAt,_that.phoneVerifiedAt,_that.lastLoginAt,_that.createdAt,_that.updatedAt,_that.roles,_that.permissions,_that.avatar,_that.averageRating,_that.ratingsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String email,  String? phone,  String? countryCode,  String preferredRole,  String status,  String? bio,  DateTime? emailVerifiedAt,  DateTime? phoneVerifiedAt,  DateTime? lastLoginAt,  DateTime createdAt,  DateTime updatedAt,  List<String> roles,  List<String> permissions,  String? avatar,  double averageRating,  int ratingsCount)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.countryCode,_that.preferredRole,_that.status,_that.bio,_that.emailVerifiedAt,_that.phoneVerifiedAt,_that.lastLoginAt,_that.createdAt,_that.updatedAt,_that.roles,_that.permissions,_that.avatar,_that.averageRating,_that.ratingsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String email,  String? phone,  String? countryCode,  String preferredRole,  String status,  String? bio,  DateTime? emailVerifiedAt,  DateTime? phoneVerifiedAt,  DateTime? lastLoginAt,  DateTime createdAt,  DateTime updatedAt,  List<String> roles,  List<String> permissions,  String? avatar,  double averageRating,  int ratingsCount)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.countryCode,_that.preferredRole,_that.status,_that.bio,_that.emailVerifiedAt,_that.phoneVerifiedAt,_that.lastLoginAt,_that.createdAt,_that.updatedAt,_that.roles,_that.permissions,_that.avatar,_that.averageRating,_that.ratingsCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _User extends User {
  const _User({required this.id, required this.name, required this.email, this.phone, this.countryCode, required this.preferredRole, required this.status, this.bio, this.emailVerifiedAt, this.phoneVerifiedAt, this.lastLoginAt, required this.createdAt, required this.updatedAt, final  List<String> roles = const [], final  List<String> permissions = const [], this.avatar, this.averageRating = 0.0, this.ratingsCount = 0}): _roles = roles,_permissions = permissions,super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  int id;
@override final  String name;
@override final  String email;
@override final  String? phone;
@override final  String? countryCode;
@override final  String preferredRole;
@override final  String status;
@override final  String? bio;
@override final  DateTime? emailVerifiedAt;
@override final  DateTime? phoneVerifiedAt;
@override final  DateTime? lastLoginAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
 final  List<String> _roles;
@override@JsonKey() List<String> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

 final  List<String> _permissions;
@override@JsonKey() List<String> get permissions {
  if (_permissions is EqualUnmodifiableListView) return _permissions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permissions);
}

@override final  String? avatar;
@override@JsonKey() final  double averageRating;
@override@JsonKey() final  int ratingsCount;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.preferredRole, preferredRole) || other.preferredRole == preferredRole)&&(identical(other.status, status) || other.status == status)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.emailVerifiedAt, emailVerifiedAt) || other.emailVerifiedAt == emailVerifiedAt)&&(identical(other.phoneVerifiedAt, phoneVerifiedAt) || other.phoneVerifiedAt == phoneVerifiedAt)&&(identical(other.lastLoginAt, lastLoginAt) || other.lastLoginAt == lastLoginAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._roles, _roles)&&const DeepCollectionEquality().equals(other._permissions, _permissions)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,countryCode,preferredRole,status,bio,emailVerifiedAt,phoneVerifiedAt,lastLoginAt,createdAt,updatedAt,const DeepCollectionEquality().hash(_roles),const DeepCollectionEquality().hash(_permissions),avatar,averageRating,ratingsCount);

@override
String toString() {
  return 'User(id: $id, name: $name, email: $email, phone: $phone, countryCode: $countryCode, preferredRole: $preferredRole, status: $status, bio: $bio, emailVerifiedAt: $emailVerifiedAt, phoneVerifiedAt: $phoneVerifiedAt, lastLoginAt: $lastLoginAt, createdAt: $createdAt, updatedAt: $updatedAt, roles: $roles, permissions: $permissions, avatar: $avatar, averageRating: $averageRating, ratingsCount: $ratingsCount)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String email, String? phone, String? countryCode, String preferredRole, String status, String? bio, DateTime? emailVerifiedAt, DateTime? phoneVerifiedAt, DateTime? lastLoginAt, DateTime createdAt, DateTime updatedAt, List<String> roles, List<String> permissions, String? avatar, double averageRating, int ratingsCount
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? phone = freezed,Object? countryCode = freezed,Object? preferredRole = null,Object? status = null,Object? bio = freezed,Object? emailVerifiedAt = freezed,Object? phoneVerifiedAt = freezed,Object? lastLoginAt = freezed,Object? createdAt = null,Object? updatedAt = null,Object? roles = null,Object? permissions = null,Object? avatar = freezed,Object? averageRating = null,Object? ratingsCount = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,preferredRole: null == preferredRole ? _self.preferredRole : preferredRole // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneVerifiedAt: freezed == phoneVerifiedAt ? _self.phoneVerifiedAt : phoneVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLoginAt: freezed == lastLoginAt ? _self.lastLoginAt : lastLoginAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>,permissions: null == permissions ? _self._permissions : permissions // ignore: cast_nullable_to_non_nullable
as List<String>,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
