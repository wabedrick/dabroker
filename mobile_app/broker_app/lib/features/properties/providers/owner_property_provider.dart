import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/features/properties/providers/property_list_provider.dart';
import 'package:broker_app/features/properties/repositories/property_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ownerPropertiesProvider = StateNotifierProvider.family<
    OwnerPropertiesNotifier,
    AsyncValue<List<Property>>,
    String?
>((ref, status) {
  final repository = ref.watch(propertyRepositoryProvider);
  return OwnerPropertiesNotifier(repository, status);
});

class OwnerPropertiesNotifier
    extends StateNotifier<AsyncValue<List<Property>>> {
  OwnerPropertiesNotifier(this._repository, this._status)
      : super(const AsyncValue.loading()) {
    load();
  }

  final PropertyRepository _repository;
  final String? _status;

  Future<void> load() async {
    try {
      state = const AsyncValue.loading();
      final response = await _repository.fetchOwnerProperties(
        page: 1,
        perPage: 100, // Fetch up to 100 properties to avoid complex pagination for owner dashboard
        status: _status,
      );
      state = AsyncValue.data(response.data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await load();
  }

  Future<void> delete(String id) async {
    try {
      await _repository.deleteProperty(id);
      state = state.whenData((list) => list.where((p) => p.id != id).toList());
    } catch (e) {
      rethrow;
    }
  }

  void remove(String id) {
    state = state.whenData((list) => list.where((p) => p.id != id).toList());
  }
}
