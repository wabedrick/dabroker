import 'package:freezed_annotation/freezed_annotation.dart';

import 'lodging.dart';
import 'pagination.dart';

part 'lodging_list_response.freezed.dart';
part 'lodging_list_response.g.dart';

@freezed
abstract class LodgingListResponse with _$LodgingListResponse {
  @JsonSerializable(explicitToJson: true)
  const factory LodgingListResponse({
    @Default([]) List<Lodging> data,
    required PaginationMeta meta,
  }) = _LodgingListResponse;

  factory LodgingListResponse.fromJson(Map<String, dynamic> json) =>
      _$LodgingListResponseFromJson(json);
}
