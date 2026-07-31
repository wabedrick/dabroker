class PropertyQueryParams {
  static const _unset = Object();

  final String? search;
  final String? type;
  final String? category;
  final double? priceMin;
  final double? priceMax;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final String? sort;
  final List<String>? amenities;

  const PropertyQueryParams({
    this.search,
    this.type,
    this.category,
    this.priceMin,
    this.priceMax,
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.sort,
    this.amenities,
  });

  PropertyQueryParams copyWith({
    Object? search = _unset,
    Object? type = _unset,
    Object? category = _unset,
    Object? priceMin = _unset,
    Object? priceMax = _unset,
    Object? latitude = _unset,
    Object? longitude = _unset,
    Object? radiusKm = _unset,
    Object? sort = _unset,
    Object? amenities = _unset,
  }) {
    return PropertyQueryParams(
      search: search == _unset ? this.search : search as String?,
      type: type == _unset ? this.type : type as String?,
      category: category == _unset ? this.category : category as String?,
      priceMin: priceMin == _unset ? this.priceMin : (priceMin as num?)?.toDouble(),
      priceMax: priceMax == _unset ? this.priceMax : (priceMax as num?)?.toDouble(),
      latitude: latitude == _unset ? this.latitude : (latitude as num?)?.toDouble(),
      longitude: longitude == _unset ? this.longitude : (longitude as num?)?.toDouble(),
      radiusKm: radiusKm == _unset ? this.radiusKm : (radiusKm as num?)?.toDouble(),
      sort: sort == _unset ? this.sort : sort as String?,
      amenities: amenities == _unset ? this.amenities : amenities as List<String>?,
    );
  }

  Map<String, dynamic> toQueryParameters({int page = 1, int perPage = 15}) {
    final params = <String, dynamic>{'page': page, 'per_page': perPage};

    if (search?.isNotEmpty ?? false) params['q'] = search;
    if (type?.isNotEmpty ?? false) params['type'] = type;
    if (category?.isNotEmpty ?? false) params['category'] = category;
    if (priceMin != null) params['price_min'] = priceMin;
    if (priceMax != null) params['price_max'] = priceMax;
    if (latitude != null && longitude != null && radiusKm != null) {
      params['lat'] = latitude;
      params['lng'] = longitude;
      params['radius_km'] = radiusKm;
    }
    if (sort?.isNotEmpty ?? false) params['sort'] = sort;
    if (amenities?.isNotEmpty ?? false) params['amenities'] = amenities!.join(',');

    return params;
  }
}
