import 'package:broker_app/data/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consultation.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Consultation {
  final int id;
  final String publicId;
  final int userId;
  final int professionalId;
  final DateTime scheduledAt;
  final String status;
  final String? notes;
  final User? user;
  final User? professional;
  final DateTime createdAt;
  final DateTime updatedAt;

  Consultation({
    required this.id,
    required this.publicId,
    required this.userId,
    required this.professionalId,
    required this.scheduledAt,
    required this.status,
    this.notes,
    this.user,
    this.professional,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) =>
      _$ConsultationFromJson(json);
  Map<String, dynamic> toJson() => _$ConsultationToJson(this);
}
