import 'package:broker_app/data/models/inquiry_message.dart';

class Inquiry {
  final String publicId;
  final String status;
  final List<InquiryMessage> messages;

  Inquiry({
    required this.publicId,
    required this.status,
    required this.messages,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      publicId: json['public_id'] as String,
      status: json['status'] as String,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => InquiryMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
