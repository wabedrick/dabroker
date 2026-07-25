// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lodging_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LodgingListResponse _$LodgingListResponseFromJson(Map<String, dynamic> json) =>
    _LodgingListResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Lodging.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LodgingListResponseToJson(
  _LodgingListResponse instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};
