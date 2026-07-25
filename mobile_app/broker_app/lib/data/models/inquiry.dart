import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:broker_app/data/models/inquiry_message.dart';

part 'inquiry.freezed.dart';
part 'inquiry.g.dart';

String _propertyTitleFromJson(dynamic json) => json as String? ?? 'Unknown Property';
String _senderNameFromJson(dynamic json) => json as String? ?? 'Unknown User';

@freezed
abstract class InquiryProperty with _$InquiryProperty {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory InquiryProperty({
    @Default('') String id,
    @JsonKey(fromJson: _propertyTitleFromJson) @Default('Unknown Property') String title,
    String? status,
  }) = _InquiryProperty;

  factory InquiryProperty.fromJson(Map<String, dynamic> json) =>
      _$InquiryPropertyFromJson(json);
}

@freezed
abstract class InquirySender with _$InquirySender {
  const InquirySender._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory InquirySender({
    @Default(0) int id,
    @JsonKey(fromJson: _senderNameFromJson) @Default('Unknown User') String name,
    String? preferredRole,
  }) = _InquirySender;

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

  factory InquirySender.fromJson(Map<String, dynamic> json) =>
      _$InquirySenderFromJson(json);
}

@freezed
abstract class Inquiry with _$Inquiry {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Inquiry({
    required String publicId,
    required String status,
    @Default([]) List<InquiryMessage> messages,
    InquiryProperty? property,
    InquirySender? sender,
    InquirySender? owner,
  }) = _Inquiry;

  factory Inquiry.fromJson(Map<String, dynamic> json) =>
      _$InquiryFromJson(json);
}
