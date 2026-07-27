// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InquiryMessage _$InquiryMessageFromJson(Map<String, dynamic> json) =>
    _InquiryMessage(
      publicId: _publicIdFromJson(_readPublicId(json, 'public_id')),
      senderId: _senderIdFromJson(json['sender_id']),
      message: json['message'] as String? ?? '',
      createdAt: _createdAtFromJson(json['created_at']),
      sender: _senderFromJson(json['sender']),
    );

Map<String, dynamic> _$InquiryMessageToJson(_InquiryMessage instance) =>
    <String, dynamic>{
      'public_id': instance.publicId,
      'sender_id': instance.senderId,
      'message': instance.message,
      'created_at': instance.createdAt.toIso8601String(),
      'sender': instance.sender?.toJson(),
    };
