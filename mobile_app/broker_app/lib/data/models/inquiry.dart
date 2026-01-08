import 'package:broker_app/data/models/inquiry_message.dart';

class InquiryProperty {
  final String id;
  final String title;
  final String? status;

  InquiryProperty({required this.id, required this.title, this.status});

  factory InquiryProperty.fromJson(Map<String, dynamic> json) {
    return InquiryProperty(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Unknown Property',
      status: json['status'] as String?,
    );
  }
}

class InquirySender {
  final int id;
  final String name;
  final String? preferredRole;

  InquirySender({required this.id, required this.name, this.preferredRole});

  String get formattedRole {
    if (preferredRole == null) return '';
    return preferredRole!
        .split('_')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  factory InquirySender.fromJson(Map<String, dynamic> json) {
    return InquirySender(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown User',
      preferredRole: json['preferred_role'] as String?,
    );
  }
}

class Inquiry {
  final String publicId;
  final String status;
  final List<InquiryMessage> messages;
  final InquiryProperty? property;
  final InquirySender? sender;
  final InquirySender? owner;

  Inquiry({
    required this.publicId,
    required this.status,
    required this.messages,
    this.property,
    this.sender,
    this.owner,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      publicId: json['public_id'] as String,
      status: json['status'] as String,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => InquiryMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      property: json['property'] != null
          ? InquiryProperty.fromJson(json['property'] as Map<String, dynamic>)
          : null,
      sender: json['sender'] != null
          ? InquirySender.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      owner: json['owner'] != null
          ? InquirySender.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
    );
  }
}
