// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inquiry_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InquiryMessage {

@JsonKey(readValue: _readPublicId, fromJson: _publicIdFromJson) String get publicId;@JsonKey(fromJson: _senderIdFromJson) int get senderId; String get message;@JsonKey(fromJson: _createdAtFromJson) DateTime get createdAt;@JsonKey(fromJson: _senderFromJson) User? get sender;
/// Create a copy of InquiryMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InquiryMessageCopyWith<InquiryMessage> get copyWith => _$InquiryMessageCopyWithImpl<InquiryMessage>(this as InquiryMessage, _$identity);

  /// Serializes this InquiryMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InquiryMessage&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.sender, sender) || other.sender == sender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,senderId,message,createdAt,sender);

@override
String toString() {
  return 'InquiryMessage(publicId: $publicId, senderId: $senderId, message: $message, createdAt: $createdAt, sender: $sender)';
}


}

/// @nodoc
abstract mixin class $InquiryMessageCopyWith<$Res>  {
  factory $InquiryMessageCopyWith(InquiryMessage value, $Res Function(InquiryMessage) _then) = _$InquiryMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _readPublicId, fromJson: _publicIdFromJson) String publicId,@JsonKey(fromJson: _senderIdFromJson) int senderId, String message,@JsonKey(fromJson: _createdAtFromJson) DateTime createdAt,@JsonKey(fromJson: _senderFromJson) User? sender
});


$UserCopyWith<$Res>? get sender;

}
/// @nodoc
class _$InquiryMessageCopyWithImpl<$Res>
    implements $InquiryMessageCopyWith<$Res> {
  _$InquiryMessageCopyWithImpl(this._self, this._then);

  final InquiryMessage _self;
  final $Res Function(InquiryMessage) _then;

/// Create a copy of InquiryMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicId = null,Object? senderId = null,Object? message = null,Object? createdAt = null,Object? sender = freezed,}) {
  return _then(_self.copyWith(
publicId: null == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as User?,
  ));
}
/// Create a copy of InquiryMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get sender {
    if (_self.sender == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.sender!, (value) {
    return _then(_self.copyWith(sender: value));
  });
}
}


/// Adds pattern-matching-related methods to [InquiryMessage].
extension InquiryMessagePatterns on InquiryMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InquiryMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InquiryMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InquiryMessage value)  $default,){
final _that = this;
switch (_that) {
case _InquiryMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InquiryMessage value)?  $default,){
final _that = this;
switch (_that) {
case _InquiryMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readPublicId, fromJson: _publicIdFromJson)  String publicId, @JsonKey(fromJson: _senderIdFromJson)  int senderId,  String message, @JsonKey(fromJson: _createdAtFromJson)  DateTime createdAt, @JsonKey(fromJson: _senderFromJson)  User? sender)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InquiryMessage() when $default != null:
return $default(_that.publicId,_that.senderId,_that.message,_that.createdAt,_that.sender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readPublicId, fromJson: _publicIdFromJson)  String publicId, @JsonKey(fromJson: _senderIdFromJson)  int senderId,  String message, @JsonKey(fromJson: _createdAtFromJson)  DateTime createdAt, @JsonKey(fromJson: _senderFromJson)  User? sender)  $default,) {final _that = this;
switch (_that) {
case _InquiryMessage():
return $default(_that.publicId,_that.senderId,_that.message,_that.createdAt,_that.sender);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: _readPublicId, fromJson: _publicIdFromJson)  String publicId, @JsonKey(fromJson: _senderIdFromJson)  int senderId,  String message, @JsonKey(fromJson: _createdAtFromJson)  DateTime createdAt, @JsonKey(fromJson: _senderFromJson)  User? sender)?  $default,) {final _that = this;
switch (_that) {
case _InquiryMessage() when $default != null:
return $default(_that.publicId,_that.senderId,_that.message,_that.createdAt,_that.sender);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _InquiryMessage implements InquiryMessage {
  const _InquiryMessage({@JsonKey(readValue: _readPublicId, fromJson: _publicIdFromJson) required this.publicId, @JsonKey(fromJson: _senderIdFromJson) required this.senderId, this.message = '', @JsonKey(fromJson: _createdAtFromJson) required this.createdAt, @JsonKey(fromJson: _senderFromJson) this.sender});
  factory _InquiryMessage.fromJson(Map<String, dynamic> json) => _$InquiryMessageFromJson(json);

@override@JsonKey(readValue: _readPublicId, fromJson: _publicIdFromJson) final  String publicId;
@override@JsonKey(fromJson: _senderIdFromJson) final  int senderId;
@override@JsonKey() final  String message;
@override@JsonKey(fromJson: _createdAtFromJson) final  DateTime createdAt;
@override@JsonKey(fromJson: _senderFromJson) final  User? sender;

/// Create a copy of InquiryMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InquiryMessageCopyWith<_InquiryMessage> get copyWith => __$InquiryMessageCopyWithImpl<_InquiryMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InquiryMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InquiryMessage&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.sender, sender) || other.sender == sender));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,senderId,message,createdAt,sender);

@override
String toString() {
  return 'InquiryMessage(publicId: $publicId, senderId: $senderId, message: $message, createdAt: $createdAt, sender: $sender)';
}


}

/// @nodoc
abstract mixin class _$InquiryMessageCopyWith<$Res> implements $InquiryMessageCopyWith<$Res> {
  factory _$InquiryMessageCopyWith(_InquiryMessage value, $Res Function(_InquiryMessage) _then) = __$InquiryMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: _readPublicId, fromJson: _publicIdFromJson) String publicId,@JsonKey(fromJson: _senderIdFromJson) int senderId, String message,@JsonKey(fromJson: _createdAtFromJson) DateTime createdAt,@JsonKey(fromJson: _senderFromJson) User? sender
});


@override $UserCopyWith<$Res>? get sender;

}
/// @nodoc
class __$InquiryMessageCopyWithImpl<$Res>
    implements _$InquiryMessageCopyWith<$Res> {
  __$InquiryMessageCopyWithImpl(this._self, this._then);

  final _InquiryMessage _self;
  final $Res Function(_InquiryMessage) _then;

/// Create a copy of InquiryMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicId = null,Object? senderId = null,Object? message = null,Object? createdAt = null,Object? sender = freezed,}) {
  return _then(_InquiryMessage(
publicId: null == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,sender: freezed == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as User?,
  ));
}

/// Create a copy of InquiryMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get sender {
    if (_self.sender == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.sender!, (value) {
    return _then(_self.copyWith(sender: value));
  });
}
}

// dart format on
