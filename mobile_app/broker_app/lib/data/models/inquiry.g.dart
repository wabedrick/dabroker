// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InquiryProperty _$InquiryPropertyFromJson(Map<String, dynamic> json) =>
    _InquiryProperty(
      id: json['id'] as String? ?? '',
      title: json['title'] == null
          ? 'Unknown Property'
          : _propertyTitleFromJson(json['title']),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$InquiryPropertyToJson(_InquiryProperty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
    };

_InquirySender _$InquirySenderFromJson(Map<String, dynamic> json) =>
    _InquirySender(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] == null
          ? 'Unknown User'
          : _senderNameFromJson(json['name']),
      preferredRole: json['preferred_role'] as String?,
    );

Map<String, dynamic> _$InquirySenderToJson(_InquirySender instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'preferred_role': instance.preferredRole,
    };

_Inquiry _$InquiryFromJson(Map<String, dynamic> json) => _Inquiry(
  publicId: json['public_id'] as String,
  status: json['status'] as String,
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => InquiryMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  property: json['property'] == null
      ? null
      : InquiryProperty.fromJson(json['property'] as Map<String, dynamic>),
  sender: json['sender'] == null
      ? null
      : InquirySender.fromJson(json['sender'] as Map<String, dynamic>),
  owner: json['owner'] == null
      ? null
      : InquirySender.fromJson(json['owner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InquiryToJson(_Inquiry instance) => <String, dynamic>{
  'public_id': instance.publicId,
  'status': instance.status,
  'messages': instance.messages.map((e) => e.toJson()).toList(),
  'property': instance.property?.toJson(),
  'sender': instance.sender?.toJson(),
  'owner': instance.owner?.toJson(),
};
