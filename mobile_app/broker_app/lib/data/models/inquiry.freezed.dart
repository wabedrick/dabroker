// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inquiry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InquiryProperty {

 String get id;@JsonKey(fromJson: _propertyTitleFromJson) String get title; String? get status;
/// Create a copy of InquiryProperty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InquiryPropertyCopyWith<InquiryProperty> get copyWith => _$InquiryPropertyCopyWithImpl<InquiryProperty>(this as InquiryProperty, _$identity);

  /// Serializes this InquiryProperty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InquiryProperty&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status);

@override
String toString() {
  return 'InquiryProperty(id: $id, title: $title, status: $status)';
}


}

/// @nodoc
abstract mixin class $InquiryPropertyCopyWith<$Res>  {
  factory $InquiryPropertyCopyWith(InquiryProperty value, $Res Function(InquiryProperty) _then) = _$InquiryPropertyCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(fromJson: _propertyTitleFromJson) String title, String? status
});




}
/// @nodoc
class _$InquiryPropertyCopyWithImpl<$Res>
    implements $InquiryPropertyCopyWith<$Res> {
  _$InquiryPropertyCopyWithImpl(this._self, this._then);

  final InquiryProperty _self;
  final $Res Function(InquiryProperty) _then;

/// Create a copy of InquiryProperty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InquiryProperty].
extension InquiryPropertyPatterns on InquiryProperty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InquiryProperty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InquiryProperty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InquiryProperty value)  $default,){
final _that = this;
switch (_that) {
case _InquiryProperty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InquiryProperty value)?  $default,){
final _that = this;
switch (_that) {
case _InquiryProperty() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _propertyTitleFromJson)  String title,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InquiryProperty() when $default != null:
return $default(_that.id,_that.title,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _propertyTitleFromJson)  String title,  String? status)  $default,) {final _that = this;
switch (_that) {
case _InquiryProperty():
return $default(_that.id,_that.title,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(fromJson: _propertyTitleFromJson)  String title,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _InquiryProperty() when $default != null:
return $default(_that.id,_that.title,_that.status);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _InquiryProperty implements InquiryProperty {
  const _InquiryProperty({this.id = '', @JsonKey(fromJson: _propertyTitleFromJson) this.title = 'Unknown Property', this.status});
  factory _InquiryProperty.fromJson(Map<String, dynamic> json) => _$InquiryPropertyFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey(fromJson: _propertyTitleFromJson) final  String title;
@override final  String? status;

/// Create a copy of InquiryProperty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InquiryPropertyCopyWith<_InquiryProperty> get copyWith => __$InquiryPropertyCopyWithImpl<_InquiryProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InquiryPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InquiryProperty&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,status);

@override
String toString() {
  return 'InquiryProperty(id: $id, title: $title, status: $status)';
}


}

/// @nodoc
abstract mixin class _$InquiryPropertyCopyWith<$Res> implements $InquiryPropertyCopyWith<$Res> {
  factory _$InquiryPropertyCopyWith(_InquiryProperty value, $Res Function(_InquiryProperty) _then) = __$InquiryPropertyCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(fromJson: _propertyTitleFromJson) String title, String? status
});




}
/// @nodoc
class __$InquiryPropertyCopyWithImpl<$Res>
    implements _$InquiryPropertyCopyWith<$Res> {
  __$InquiryPropertyCopyWithImpl(this._self, this._then);

  final _InquiryProperty _self;
  final $Res Function(_InquiryProperty) _then;

/// Create a copy of InquiryProperty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? status = freezed,}) {
  return _then(_InquiryProperty(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InquirySender {

 int get id;@JsonKey(fromJson: _senderNameFromJson) String get name; String? get preferredRole;
/// Create a copy of InquirySender
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InquirySenderCopyWith<InquirySender> get copyWith => _$InquirySenderCopyWithImpl<InquirySender>(this as InquirySender, _$identity);

  /// Serializes this InquirySender to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InquirySender&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.preferredRole, preferredRole) || other.preferredRole == preferredRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,preferredRole);

@override
String toString() {
  return 'InquirySender(id: $id, name: $name, preferredRole: $preferredRole)';
}


}

/// @nodoc
abstract mixin class $InquirySenderCopyWith<$Res>  {
  factory $InquirySenderCopyWith(InquirySender value, $Res Function(InquirySender) _then) = _$InquirySenderCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(fromJson: _senderNameFromJson) String name, String? preferredRole
});




}
/// @nodoc
class _$InquirySenderCopyWithImpl<$Res>
    implements $InquirySenderCopyWith<$Res> {
  _$InquirySenderCopyWithImpl(this._self, this._then);

  final InquirySender _self;
  final $Res Function(InquirySender) _then;

/// Create a copy of InquirySender
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


/// Adds pattern-matching-related methods to [InquirySender].
extension InquirySenderPatterns on InquirySender {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InquirySender value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InquirySender() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InquirySender value)  $default,){
final _that = this;
switch (_that) {
case _InquirySender():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InquirySender value)?  $default,){
final _that = this;
switch (_that) {
case _InquirySender() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(fromJson: _senderNameFromJson)  String name,  String? preferredRole)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InquirySender() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(fromJson: _senderNameFromJson)  String name,  String? preferredRole)  $default,) {final _that = this;
switch (_that) {
case _InquirySender():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(fromJson: _senderNameFromJson)  String name,  String? preferredRole)?  $default,) {final _that = this;
switch (_that) {
case _InquirySender() when $default != null:
return $default(_that.id,_that.name,_that.preferredRole);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _InquirySender extends InquirySender {
  const _InquirySender({this.id = 0, @JsonKey(fromJson: _senderNameFromJson) this.name = 'Unknown User', this.preferredRole}): super._();
  factory _InquirySender.fromJson(Map<String, dynamic> json) => _$InquirySenderFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey(fromJson: _senderNameFromJson) final  String name;
@override final  String? preferredRole;

/// Create a copy of InquirySender
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InquirySenderCopyWith<_InquirySender> get copyWith => __$InquirySenderCopyWithImpl<_InquirySender>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InquirySenderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InquirySender&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.preferredRole, preferredRole) || other.preferredRole == preferredRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,preferredRole);

@override
String toString() {
  return 'InquirySender(id: $id, name: $name, preferredRole: $preferredRole)';
}


}

/// @nodoc
abstract mixin class _$InquirySenderCopyWith<$Res> implements $InquirySenderCopyWith<$Res> {
  factory _$InquirySenderCopyWith(_InquirySender value, $Res Function(_InquirySender) _then) = __$InquirySenderCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(fromJson: _senderNameFromJson) String name, String? preferredRole
});




}
/// @nodoc
class __$InquirySenderCopyWithImpl<$Res>
    implements _$InquirySenderCopyWith<$Res> {
  __$InquirySenderCopyWithImpl(this._self, this._then);

  final _InquirySender _self;
  final $Res Function(_InquirySender) _then;

/// Create a copy of InquirySender
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? preferredRole = freezed,}) {
  return _then(_InquirySender(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,preferredRole: freezed == preferredRole ? _self.preferredRole : preferredRole // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Inquiry {

 String get publicId; String get status; List<InquiryMessage> get messages; InquiryProperty? get property; InquirySender? get sender; InquirySender? get owner;
/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InquiryCopyWith<Inquiry> get copyWith => _$InquiryCopyWithImpl<Inquiry>(this as Inquiry, _$identity);

  /// Serializes this Inquiry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Inquiry&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.property, property) || other.property == property)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.owner, owner) || other.owner == owner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,status,const DeepCollectionEquality().hash(messages),property,sender,owner);

@override
String toString() {
  return 'Inquiry(publicId: $publicId, status: $status, messages: $messages, property: $property, sender: $sender, owner: $owner)';
}


}

/// @nodoc
abstract mixin class $InquiryCopyWith<$Res>  {
  factory $InquiryCopyWith(Inquiry value, $Res Function(Inquiry) _then) = _$InquiryCopyWithImpl;
@useResult
$Res call({
 String publicId, String status, List<InquiryMessage> messages, InquiryProperty? property, InquirySender? sender, InquirySender? owner
});


$InquiryPropertyCopyWith<$Res>? get property;$InquirySenderCopyWith<$Res>? get sender;$InquirySenderCopyWith<$Res>? get owner;

}
/// @nodoc
class _$InquiryCopyWithImpl<$Res>
    implements $InquiryCopyWith<$Res> {
  _$InquiryCopyWithImpl(this._self, this._then);

  final Inquiry _self;
  final $Res Function(Inquiry) _then;

/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicId = null,Object? status = null,Object? messages = null,Object? property = freezed,Object? sender = freezed,Object? owner = freezed,}) {
  return _then(_self.copyWith(
publicId: null == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<InquiryMessage>,property: freezed == property ? _self.property : property // ignore: cast_nullable_to_non_nullable
as InquiryProperty?,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as InquirySender?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as InquirySender?,
  ));
}
/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InquiryPropertyCopyWith<$Res>? get property {
    if (_self.property == null) {
    return null;
  }

  return $InquiryPropertyCopyWith<$Res>(_self.property!, (value) {
    return _then(_self.copyWith(property: value));
  });
}/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InquirySenderCopyWith<$Res>? get sender {
    if (_self.sender == null) {
    return null;
  }

  return $InquirySenderCopyWith<$Res>(_self.sender!, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InquirySenderCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $InquirySenderCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// Adds pattern-matching-related methods to [Inquiry].
extension InquiryPatterns on Inquiry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Inquiry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Inquiry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Inquiry value)  $default,){
final _that = this;
switch (_that) {
case _Inquiry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Inquiry value)?  $default,){
final _that = this;
switch (_that) {
case _Inquiry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String publicId,  String status,  List<InquiryMessage> messages,  InquiryProperty? property,  InquirySender? sender,  InquirySender? owner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Inquiry() when $default != null:
return $default(_that.publicId,_that.status,_that.messages,_that.property,_that.sender,_that.owner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String publicId,  String status,  List<InquiryMessage> messages,  InquiryProperty? property,  InquirySender? sender,  InquirySender? owner)  $default,) {final _that = this;
switch (_that) {
case _Inquiry():
return $default(_that.publicId,_that.status,_that.messages,_that.property,_that.sender,_that.owner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String publicId,  String status,  List<InquiryMessage> messages,  InquiryProperty? property,  InquirySender? sender,  InquirySender? owner)?  $default,) {final _that = this;
switch (_that) {
case _Inquiry() when $default != null:
return $default(_that.publicId,_that.status,_that.messages,_that.property,_that.sender,_that.owner);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _Inquiry implements Inquiry {
  const _Inquiry({required this.publicId, required this.status, final  List<InquiryMessage> messages = const [], this.property, this.sender, this.owner}): _messages = messages;
  factory _Inquiry.fromJson(Map<String, dynamic> json) => _$InquiryFromJson(json);

@override final  String publicId;
@override final  String status;
 final  List<InquiryMessage> _messages;
@override@JsonKey() List<InquiryMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override final  InquiryProperty? property;
@override final  InquirySender? sender;
@override final  InquirySender? owner;

/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InquiryCopyWith<_Inquiry> get copyWith => __$InquiryCopyWithImpl<_Inquiry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InquiryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Inquiry&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.property, property) || other.property == property)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.owner, owner) || other.owner == owner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,status,const DeepCollectionEquality().hash(_messages),property,sender,owner);

@override
String toString() {
  return 'Inquiry(publicId: $publicId, status: $status, messages: $messages, property: $property, sender: $sender, owner: $owner)';
}


}

/// @nodoc
abstract mixin class _$InquiryCopyWith<$Res> implements $InquiryCopyWith<$Res> {
  factory _$InquiryCopyWith(_Inquiry value, $Res Function(_Inquiry) _then) = __$InquiryCopyWithImpl;
@override @useResult
$Res call({
 String publicId, String status, List<InquiryMessage> messages, InquiryProperty? property, InquirySender? sender, InquirySender? owner
});


@override $InquiryPropertyCopyWith<$Res>? get property;@override $InquirySenderCopyWith<$Res>? get sender;@override $InquirySenderCopyWith<$Res>? get owner;

}
/// @nodoc
class __$InquiryCopyWithImpl<$Res>
    implements _$InquiryCopyWith<$Res> {
  __$InquiryCopyWithImpl(this._self, this._then);

  final _Inquiry _self;
  final $Res Function(_Inquiry) _then;

/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicId = null,Object? status = null,Object? messages = null,Object? property = freezed,Object? sender = freezed,Object? owner = freezed,}) {
  return _then(_Inquiry(
publicId: null == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<InquiryMessage>,property: freezed == property ? _self.property : property // ignore: cast_nullable_to_non_nullable
as InquiryProperty?,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as InquirySender?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as InquirySender?,
  ));
}

/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InquiryPropertyCopyWith<$Res>? get property {
    if (_self.property == null) {
    return null;
  }

  return $InquiryPropertyCopyWith<$Res>(_self.property!, (value) {
    return _then(_self.copyWith(property: value));
  });
}/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InquirySenderCopyWith<$Res>? get sender {
    if (_self.sender == null) {
    return null;
  }

  return $InquirySenderCopyWith<$Res>(_self.sender!, (value) {
    return _then(_self.copyWith(sender: value));
  });
}/// Create a copy of Inquiry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InquirySenderCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $InquirySenderCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}

// dart format on
