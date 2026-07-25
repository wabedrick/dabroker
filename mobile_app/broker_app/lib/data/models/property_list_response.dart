import 'package:freezed_annotation/freezed_annotation.dart';

import 'pagination.dart';
import 'property.dart';

part 'property_list_response.freezed.dart';
part 'property_list_response.g.dart';

@freezed
abstract class PropertyListResponse with _$PropertyListResponse {
  @JsonSerializable(explicitToJson: true)
  const factory PropertyListResponse({
    @Default([]) List<Property> data,
    required PaginationMeta meta,
    required PaginationLinks links,
  }) = _PropertyListResponse;

  factory PropertyListResponse.fromJson(Map<String, dynamic> json) =>
      _$PropertyListResponseFromJson(json);
}
