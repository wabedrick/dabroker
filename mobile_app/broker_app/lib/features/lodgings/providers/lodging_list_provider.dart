import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/features/lodgings/repositories/lodging_repository.dart';

import 'package:broker_app/features/lodgings/repositories/lodging_api_client.dart';

final lodgingApiClientProvider = Provider<LodgingApiClient>((ref) {
  final client = ref.watch(dioClientProvider);
  return LodgingApiClient(client.dio);
});

final lodgingRepositoryProvider = Provider<LodgingRepository>((ref) {
  final client = ref.watch(lodgingApiClientProvider);
  return LodgingRepository(client);
});

final lodgingListProvider =
    StateNotifierProvider<LodgingListNotifier, LodgingListState>((ref) {
      final repository = ref.watch(lodgingRepositoryProvider);
      return LodgingListNotifier(repository);
    });

final hostLodgingListProvider = FutureProvider.autoDispose<List<Lodging>>((
  ref,
) async {
  final repository = ref.watch(lodgingRepositoryProvider);
  final response = await repository.fetchHostLodgings(page: 1, perPage: 100);
  return response.data;
});

class LodgingListState {
  final List<Lodging> items;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasMore;
  final int currentPage;
  final int? totalResults;
  final String? error;
  final String? typeFilter;
  final String? searchQuery;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final double? north;
  final double? south;
  final double? east;
  final double? west;
  final String? sortBy;
  final double? minPrice;
  final double? maxPrice;
  final String? currency;

  const LodgingListState({
    this.items = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalResults,
    this.error,
    this.typeFilter,
    this.searchQuery,
    this.latitude,
    this.longitude,
    this.radius,
    this.north,
    this.south,
    this.east,
    this.west,
    this.sortBy,
    this.minPrice,
    this.maxPrice,
    this.currency = 'UGX',
  });

  LodgingListState copyWith({
    List<Lodging>? items,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasMore,
    int? currentPage,
    int? totalResults,
    String? error,
    String? typeFilter,
    String? searchQuery,
    double? latitude,
    double? longitude,
    double? radius,
    double? north,
    double? south,
    double? east,
    double? west,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    String? currency,
    // Explicit clear flags — set to true to force the field to null
    bool clearSearchQuery = false,
    bool clearLatLng = false,
    bool clearBounds = false,
    bool clearSortBy = false,
    bool clearTypeFilter = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
  }) {
    return LodgingListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      totalResults: totalResults ?? this.totalResults,
      error: error,
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      latitude: clearLatLng ? null : (latitude ?? this.latitude),
      longitude: clearLatLng ? null : (longitude ?? this.longitude),
      radius: clearLatLng ? null : (radius ?? this.radius),
      north: clearBounds ? null : (north ?? this.north),
      south: clearBounds ? null : (south ?? this.south),
      east: clearBounds ? null : (east ?? this.east),
      west: clearBounds ? null : (west ?? this.west),
      sortBy: clearSortBy ? null : (sortBy ?? this.sortBy),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      currency: currency ?? this.currency,
    );
  }
}

class LodgingListNotifier extends StateNotifier<LodgingListState> {
  LodgingListNotifier(this._repository) : super(const LodgingListState());

  final LodgingRepository _repository;
  static const int _perPage = 20;

  Future<void> load({
    String? type,
    String? search,
    double? latitude,
    double? longitude,
    double? radius,
    double? north,
    double? south,
    double? east,
    double? west,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    String? currency,
    // Explicit clear flags mirrored from copyWith
    bool clearSearchQuery = false,
    bool clearLatLng = false,
    bool clearBounds = false,
    bool clearSortBy = false,
    bool clearTypeFilter = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
  }) async {
    state = state.copyWith(
      items: const [],
      isLoading: true,
      error: null,
      typeFilter: type,
      searchQuery: search,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      north: north,
      south: south,
      east: east,
      west: west,
      sortBy: sortBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      currency: currency,
      hasMore: true,
      currentPage: 1,
      clearSearchQuery: clearSearchQuery,
      clearLatLng: clearLatLng,
      clearBounds: clearBounds,
      clearSortBy: clearSortBy,
      clearTypeFilter: clearTypeFilter,
      clearMinPrice: clearMinPrice,
      clearMaxPrice: clearMaxPrice,
    );
    // Re-read state after copyWith so we use the cleared/updated values
    final s = state;
    try {
      final response = await _repository.fetchLodgings(
        page: 1,
        perPage: _perPage,
        type: s.typeFilter,
        search: s.searchQuery,
        latitude: s.latitude,
        longitude: s.longitude,
        radius: s.radius,
        north: s.north,
        south: s.south,
        east: s.east,
        west: s.west,
        sortBy: s.sortBy,
        minPrice: s.minPrice,
        maxPrice: s.maxPrice,
        currency: s.currency,
      );
      state = state.copyWith(
        items: response.data,
        isLoading: false,
        hasMore: response.meta.hasMore,
        currentPage: response.meta.currentPage,
        totalResults: response.meta.total,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final response = await _repository.fetchLodgings(
        page: 1,
        perPage: _perPage,
        type: state.typeFilter,
        search: state.searchQuery,
        latitude: state.latitude,
        longitude: state.longitude,
        radius: state.radius,
        north: state.north,
        south: state.south,
        east: state.east,
        west: state.west,
        sortBy: state.sortBy,
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
        currency: state.currency,
      );
      state = state.copyWith(
        items: response.data,
        isRefreshing: false,
        hasMore: response.meta.hasMore,
        currentPage: response.meta.currentPage,
        totalResults: response.meta.total,
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final nextPage = state.currentPage + 1;
      final response = await _repository.fetchLodgings(
        page: nextPage,
        perPage: _perPage,
        type: state.typeFilter,
        search: state.searchQuery,
        latitude: state.latitude,
        longitude: state.longitude,
        radius: state.radius,
        north: state.north,
        south: state.south,
        east: state.east,
        west: state.west,
        sortBy: state.sortBy,
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
        currency: state.currency,
      );

      state = state.copyWith(
        items: [...state.items, ...response.data],
        isLoading: false,
        hasMore: response.meta.hasMore,
        currentPage: response.meta.currentPage,
        totalResults: response.meta.total,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateTypeFilter(String? type) {
    load(
      type: type,
      clearTypeFilter: type == null,
    );
  }

  void updatePriceFilter(double? min, double? max, {String? currency}) {
    load(
      minPrice: min,
      maxPrice: max,
      currency: currency,
      clearMinPrice: min == null,
      clearMaxPrice: max == null,
    );
  }

  void updateSearchQuery(String query) {
    // Clear location filters when searching by text
    String? newSortBy = state.sortBy;
    if (newSortBy == 'nearest') newSortBy = null;

    load(
      type: state.typeFilter,
      search: query.isEmpty ? null : query,
      clearLatLng: true,
      clearBounds: true,
      clearSearchQuery: query.isEmpty,
      sortBy: newSortBy,
      clearSortBy: newSortBy == null,
    );
  }

  void updateLocationFilter(double lat, double lng, double radius) {
    load(
      type: state.typeFilter,
      search: null,
      latitude: lat,
      longitude: lng,
      radius: radius,
      // Clear bounds when doing radius search
      north: null,
      south: null,
      east: null,
      west: null,
      sortBy: state.sortBy,
    );
  }

  void updateBoundsFilter(
    double north,
    double south,
    double east,
    double west,
  ) {
    load(
      type: state.typeFilter,
      search: null,
      north: north,
      south: south,
      east: east,
      west: west,
      // Clear radius search when doing bounds search
      latitude: null,
      longitude: null,
      radius: null,
      sortBy: state.sortBy,
    );
  }

  void updateSortBy(String? sortBy) {
    load(
      type: state.typeFilter,
      search: state.searchQuery,
      latitude: state.latitude,
      longitude: state.longitude,
      radius: state.radius,
      north: state.north,
      south: state.south,
      east: state.east,
      west: state.west,
      sortBy: sortBy,
    );
  }

  void clearLocationFilter() {
    String? newSortBy = state.sortBy;
    if (newSortBy == 'nearest') newSortBy = null;
    load(
      type: state.typeFilter,
      search: state.searchQuery,
      sortBy: newSortBy,
      clearSortBy: newSortBy == null,
      // Explicitly clear all location/bounds fields
      clearLatLng: true,
      clearBounds: true,
    );
  }

  Future<void> deleteLodging(String id) async {
    await _repository.deleteLodging(id);
    state = state.copyWith(
      items: state.items.where((l) => l.id != id).toList(),
    );
  }
}
