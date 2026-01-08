// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_portfolio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalPortfolio _$ProfessionalPortfolioFromJson(
        Map<String, dynamic> json) =>
    ProfessionalPortfolio(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      projectDate: json['project_date'] == null
          ? null
          : DateTime.parse(json['project_date'] as String),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$ProfessionalPortfolioToJson(
        ProfessionalPortfolio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'project_date': instance.projectDate?.toIso8601String(),
      'url': instance.url,
    };
