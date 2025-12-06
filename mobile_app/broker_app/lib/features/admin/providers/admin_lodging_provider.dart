import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/features/admin/data/admin_repository.dart';
import 'package:broker_app/features/admin/providers/admin_dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminLodgingsProvider =
    StateNotifierProvider.family<
      AdminLodgingsNotifier,
      AsyncValue<List<Lodging>>,
      String?
    >((ref, status) {
      final repository = ref.watch(adminRepositoryProvider);
      return AdminLodgingsNotifier(repository, status);
    });

class AdminLodgingsNotifier extends StateNotifier<AsyncValue<List<Lodging>>> {
  AdminLodgingsNotifier(this._repository, this._status)
    : super(const AsyncValue.loading()) {
    load();
  }

  final AdminRepository _repository;
  final String? _status;

  Future<void> load() async {
    try {
      state = const AsyncValue.loading();
      final response = await _repository.fetchLodgings(status: _status);
      state = AsyncValue.data(response.data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> approve(String id) async {
    try {
      await _repository.approveLodging(id);
      // Remove from list if we are viewing pending lodgings
      if (_status == 'pending') {
        state = state.whenData(
          (list) => list.where((l) => l.id != id).toList(),
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
      await _repository.rejectLodging(id, reason);
      // Remove from list if we are viewing pending lodgings
      if (_status == 'pending') {
        state = state.whenData(
          (list) => list.where((l) => l.id != id).toList(),
        );
      } else {
        await load();
      }
    } catch (e) {
      // Handle error
      rethrow;
    }
  }
}
