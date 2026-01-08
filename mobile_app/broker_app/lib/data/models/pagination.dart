import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class PaginationMeta {
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'last_page')
  final int lastPage;
  @JsonKey(name: 'per_page')
  final int perPage;
  final int? from;
  final int? to;
  final int total;

  const PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.from,
    this.to,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}

@JsonSerializable()
class PaginationLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  const PaginationLinks({this.first, this.last, this.prev, this.next});

  factory PaginationLinks.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinksFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationLinksToJson(this);
}

class Pagination<T> {
  final List<T> data;
  final PaginationMeta meta;
  final PaginationLinks links;

  const Pagination({
    required this.data,
    required this.meta,
    required this.links,
  });

  factory Pagination.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return Pagination(
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      meta: json['meta'] != null
          ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : const PaginationMeta(
              currentPage: 1,
              lastPage: 1,
              perPage: 15,
              total: 0,
            ),
      links: json['links'] != null
          ? PaginationLinks.fromJson(json['links'] as Map<String, dynamic>)
          : const PaginationLinks(),
    );
  }
}
