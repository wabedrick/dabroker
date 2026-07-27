// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PropertyListResponse _$PropertyListResponseFromJson(
  Map<String, dynamic> json,
) => _PropertyListResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
  links: PaginationLinks.fromJson(json['links'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PropertyListResponseToJson(
  _PropertyListResponse instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
  'links': instance.links.toJson(),
};
