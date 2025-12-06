// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyListResponse _$PropertyListResponseFromJson(
        Map<String, dynamic> json) =>
    PropertyListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
      links: PaginationLinks.fromJson(json['links'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PropertyListResponseToJson(
        PropertyListResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
      'links': instance.links,
    };
