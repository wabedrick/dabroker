import 'package:json_annotation/json_annotation.dart';

part 'professional_portfolio.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProfessionalPortfolio {
  final int id;
  final String title;
  final String? description;
  final DateTime? projectDate;
  final String? url;

  ProfessionalPortfolio({
    required this.id,
    required this.title,
    this.description,
    this.projectDate,
    this.url,
  });

  factory ProfessionalPortfolio.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalPortfolioFromJson(json);
  Map<String, dynamic> toJson() => _$ProfessionalPortfolioToJson(this);
}
