import 'package:broker_app/data/models/user.dart';

class InquiryMessage {
  final String publicId;
  final int senderId;
  final String message;
  final DateTime createdAt;
  final User? sender;

  InquiryMessage({
    required this.publicId,
    required this.senderId,
    required this.message,
    required this.createdAt,
    this.sender,
  });

  factory InquiryMessage.fromJson(Map<String, dynamic> json) {
    User? sender;
    if (json['sender'] != null) {
      final s = json['sender'];
      if (s['email'] != null) {
        sender = User.fromJson(s);
      } else {
        sender = User(
          id: s['id'] is int
              ? s['id']
              : int.tryParse(s['id']?.toString() ?? '0') ?? 0,
          name: s['name']?.toString() ?? 'Unknown',
          email: '',
          preferredRole: s['preferred_role']?.toString() ?? 'user',
          status: 'active',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    }

    return InquiryMessage(
      publicId: (json['public_id'] ?? json['id'])?.toString() ?? '',
      senderId: json['sender_id'] is int
          ? json['sender_id']
          : int.tryParse(json['sender_id']?.toString() ?? '0') ?? 0,
      message: json['message']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '')
              ?.toLocal() ??
          DateTime.now(),
      sender: sender,
    );
  }
}
