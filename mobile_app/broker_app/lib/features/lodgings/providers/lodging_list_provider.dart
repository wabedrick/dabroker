import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/features/lodgings/repositories/lodging_repository.dart';

final lodgingRepositoryProvider = Provider<LodgingRepository>((ref) {
  final client = ref.watch(dioClientProvider);
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

  const LodgingListState({
    this.items = const [],
    this.isLoading = false,
    this.isRefreshing = false,
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
  });

  LodgingListState copyWith({
    List<Lodging>? items,
    bool? isLoading,
    bool? isRefreshing,
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
  }) {
    return LodgingListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error,
      typeFilter: typeFilter ?? this.typeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      north: north ?? this.north,
      south: south ?? this.south,
      east: east ?? this.east,
      west: west ?? this.west,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class LodgingListNotifier extends StateNotifier<LodgingListState> {
  LodgingListNotifier(this._repository) : super(const LodgingListState());

  final LodgingRepository _repository;

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
  }) async {
    state = state.copyWith(
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
    );
    try {
      final response = await _repository.fetchLodgings(
        page: 1,
        perPage: 20,
        type: type,
        search: search,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        north: north,
        south: south,
        east: east,
        west: west,
        sortBy: sortBy,
      );
      state = state.copyWith(items: response.data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final response = await _repository.fetchLodgings(
        page: 1,
        perPage: 20,
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
      );
      state = state.copyWith(items: response.data, isRefreshing: false);
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e.toString());
    }
  }

  void updateTypeFilter(String? type) {
    load(
      type: type,
      search: state.searchQuery,
      latitude: state.latitude,
      longitude: state.longitude,
      radius: state.radius,
      north: state.north,
      south: state.south,
      east: state.east,
      west: state.west,
      sortBy: state.sortBy,
    );
  }

  void updateSearchQuery(String query) {
    // Clear location filters when searching by text to avoid conflicts
    // Also reset sort if it was 'nearest' since we lose location context
    String? newSortBy = state.sortBy;
    if (newSortBy == 'nearest') {
      newSortBy = null;
    }

    load(
      type: state.typeFilter,
      search: query,
      latitude: null,
      longitude: null,
      radius: null,
      north: null,
      south: null,
      east: null,
      west: null,
      sortBy: newSortBy,
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
    // Reset sort if it was 'nearest' since we lose location context
    String? newSortBy = state.sortBy;
    if (newSortBy == 'nearest') {
      newSortBy = null;
    }
    load(type: state.typeFilter, sortBy: newSortBy);
  }

  Future<void> deleteLodging(String id) async {
    await _repository.deleteLodging(id);
    state = state.copyWith(
      items: state.items.where((l) => l.id != id).toList(),
    );
  }
}
