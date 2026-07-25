import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:broker_app/data/models/user.dart';

part 'inquiry_message.freezed.dart';
part 'inquiry_message.g.dart';

User? _senderFromJson(dynamic json) {
  if (json == null) return null;
  if (json is Map<String, dynamic>) {
    if (json['email'] != null) {
      return User.fromJson(json);
    } else {
      return User(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['name']?.toString() ?? 'Unknown',
        email: '',
        preferredRole: json['preferred_role']?.toString() ?? 'user',
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
  return null;
}

Object? _readPublicId(Map<dynamic, dynamic> json, String key) {
  return json['public_id'] ?? json['id'];
}

String _publicIdFromJson(dynamic json) {
  if (json == null) return '';
  return json.toString();
}

int _senderIdFromJson(dynamic json) {
  if (json is int) return json;
  return int.tryParse(json?.toString() ?? '0') ?? 0;
}

DateTime _createdAtFromJson(dynamic json) {
  return DateTime.tryParse(json?.toString() ?? '')?.toLocal() ?? DateTime.now();
}

@freezed
abstract class InquiryMessage with _$InquiryMessage {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory InquiryMessage({
    @JsonKey(readValue: _readPublicId, fromJson: _publicIdFromJson) required String publicId,
    @JsonKey(fromJson: _senderIdFromJson) required int senderId,
    @Default('') String message,
    @JsonKey(fromJson: _createdAtFromJson) required DateTime createdAt,
    @JsonKey(fromJson: _senderFromJson) User? sender,
  }) = _InquiryMessage;

  factory InquiryMessage.fromJson(Map<String, dynamic> json) =>
      _$InquiryMessageFromJson(json);
}
