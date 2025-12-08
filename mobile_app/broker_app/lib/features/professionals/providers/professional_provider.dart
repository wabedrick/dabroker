import 'package:broker_app/data/models/user.dart';
import 'package:broker_app/features/professionals/repositories/professional_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final professionalListProvider =
    StateNotifierProvider<ProfessionalListNotifier, AsyncValue<List<User>>>(
      (ref) =>
          ProfessionalListNotifier(ref.read(professionalRepositoryProvider)),
    );

class ProfessionalListNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final ProfessionalRepository _repository;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String? _currentType;

  ProfessionalListNotifier(this._repository)
    : super(const AsyncValue.loading()) {
    loadProfessionals();
  }

  Future<void> loadProfessionals({
    String? type,
    bool refresh = false,
    bool showLoading = true,
  }) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      _currentType = type;
      if (showLoading) {
        state = const AsyncValue.loading();
      }
    }

    if (!_hasMore && !refresh) return;

    try {
      final result = await _repository.getProfessionals(
        page: _page,
        type: _currentType,
      );

      if (refresh) {
        state = AsyncValue.data(result.data);
      } else {
        state = AsyncValue.data([...state.value ?? [], ...result.data]);
      }

      _hasMore = result.meta.currentPage < result.meta.lastPage;
      _page++;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    await loadProfessionals();
    _isLoadingMore = false;
  }

  void filterByType(String? type) {
    loadProfessionals(type: type, refresh: true);
  }
}
