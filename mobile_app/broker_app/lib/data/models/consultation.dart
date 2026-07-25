import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:broker_app/data/models/user.dart';

part 'consultation.freezed.dart';
part 'consultation.g.dart';

@freezed
abstract class Consultation with _$Consultation {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Consultation({
    required int id,
    required String publicId,
    required int userId,
    required int professionalId,
    required DateTime scheduledAt,
    required String status,
    String? notes,
    User? user,
    User? professional,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Consultation;

  factory Consultation.fromJson(Map<String, dynamic> json) =>
      _$ConsultationFromJson(json);
}
