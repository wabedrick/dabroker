import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/data/models/property.dart';

import '../models/property_query_params.dart';
import '../repositories/property_repository.dart';

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  final client = ref.watch(dioClientProvider);
  return PropertyRepository(client);
});

final propertyListProvider =
    StateNotifierProvider<PropertyListNotifier, PropertyListState>((ref) {
      final repository = ref.watch(propertyRepositoryProvider);
      return PropertyListNotifier(repository);
    });

class PropertyListState {
  final List<Property> items;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasMore;
  final int currentPage;
  final String? error;
  final PropertyQueryParams params;

  const PropertyListState({
    this.items = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
    this.params = const PropertyQueryParams(),
  });

  PropertyListState copyWith({
    List<Property>? items,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasMore,
    int? currentPage,
    String? error,
    PropertyQueryParams? params,
  }) {
    return PropertyListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
      params: params ?? this.params,
    );
  }
}

class PropertyListNotifier extends StateNotifier<PropertyListState> {
  PropertyListNotifier(this._repository) : super(const PropertyListState());

  final PropertyRepository _repository;
  static const int _perPage = 15;
  bool _initialized = false;

  Future<void> initialize({PropertyQueryParams? params}) async {
    if (_initialized && params == null) return;
    _initialized = true;
    await refresh(params: params ?? state.params);
  }

  Future<void> refresh({PropertyQueryParams? params}) async {
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final response = await _repository.fetchProperties(
        page: 1,
        perPage: _perPage,
        params: params ?? state.params,
      );

      state = state.copyWith(
        items: response.data,
        isRefreshing: false,
        hasMore: response.meta.hasMore,
        currentPage: response.meta.currentPage,
        params: params ?? state.params,
      );
    } catch (error) {
      state = state.copyWith(isRefreshing: false, error: error.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final nextPage = state.currentPage + 1;
      final response = await _repository.fetchProperties(
        page: nextPage,
        perPage: _perPage,
        params: state.params,
      );

      state = state.copyWith(
        items: [...state.items, ...response.data],
        isLoading: false,
        hasMore: response.meta.hasMore,
        currentPage: response.meta.currentPage,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<void> updateFilters(PropertyQueryParams params) async {
    await refresh(params: params);
  }

  Future<void> deleteProperty(String id) async {
    await _repository.deleteProperty(id);
    state = state.copyWith(
      items: state.items.where((p) => p.id != id).toList(),
    );
  }

  void updateFavoriteStatus(String propertyId, bool isFavorited) {
    final updatedItems = state.items
        .map(
          (property) => property.id == propertyId
              ? property.copyWith(isFavorited: isFavorited)
              : property,
        )
        .toList();

    state = state.copyWith(items: updatedItems);
  }
}
