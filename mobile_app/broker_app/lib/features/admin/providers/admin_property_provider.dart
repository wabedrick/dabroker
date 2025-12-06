import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/features/admin/data/admin_repository.dart';
import 'package:broker_app/features/admin/providers/admin_dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminPropertiesProvider =
    StateNotifierProvider.family<
      AdminPropertiesNotifier,
      AsyncValue<List<Property>>,
      String?
    >((ref, status) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminPropertiesNotifier(repository, status);
    });

class AdminPropertiesNotifier
    extends StateNotifier<AsyncValue<List<Property>>> {
  AdminPropertiesNotifier(this._repository, this._status)
    : super(const AsyncValue.loading()) {
    load();
  }

  final AdminRepository _repository;
  final String? _status;

  Future<void> load() async {
    try {
      state = const AsyncValue.loading();
      final response = await _repository.fetchProperties(status: _status);
      state = AsyncValue.data(response.data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> approve(String id) async {
    try {
      await _repository.approveProperty(id);
      // Remove from list if we are viewing pending properties
      if (_status == 'pending') {
        state = state.whenData(
          (list) => list.where((p) => p.id != id).toList(),
        );
      } else {
        await load();
      }
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> reject(String id, String reason) async {
    try {
      await _repository.rejectProperty(id, reason);
      if (_status == 'pending') {
        state = state.whenData(
          (list) => list.where((p) => p.id != id).toList(),
        );
      } else {
        await load();
      }
    } catch (e) {
      rethrow;
    }
  }
}
