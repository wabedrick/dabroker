import 'package:broker_app/data/models/inquiry_message.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/data/models/user.dart';

class Inquiry {
  final String publicId;
  final String status;
  final List<InquiryMessage> messages;
  final Property? property;
  final User? sender;

  Inquiry({
    required this.publicId,
    required this.status,
    required this.messages,
    this.property,
    this.sender,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      publicId: json['public_id'] as String,
      status: json['status'] as String,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => InquiryMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      property: json['property'] != null
          ? Property.fromJson(json['property'] as Map<String, dynamic>)
          : null,
      sender: json['sender'] != null
          ? User.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
    );
  }
}
