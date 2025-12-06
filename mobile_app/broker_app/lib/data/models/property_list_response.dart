import 'package:json_annotation/json_annotation.dart';

import 'pagination.dart';
import 'property.dart';

part 'property_list_response.g.dart';

@JsonSerializable()
class PropertyListResponse {
  final List<Property> data;
  final PaginationMeta meta;
  final PaginationLinks links;

  const PropertyListResponse({
    required this.data,
    required this.meta,
    required this.links,
  });

  factory PropertyListResponse.fromJson(Map<String, dynamic> json) =>
      _$PropertyListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyListResponseToJson(this);
}
