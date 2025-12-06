import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:broker_app/features/admin/data/admin_repository.dart';
import 'package:broker_app/features/admin/models/moderation_log.dart';
import 'package:broker_app/features/admin/providers/admin_dashboard_provider.dart';

class ModerationLogsFilter {
  const ModerationLogsFilter({
    this.entityType,
    this.action,
    this.dateFrom,
    this.dateTo,
  });

  final String? entityType;
  final String? action;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  bool get isActive =>
      entityType != null ||
      action != null ||
      dateFrom != null ||
      dateTo != null;

  ModerationLogsFilter copyWith({
    String? entityType,
    bool clearEntity = false,
    String? action,
    bool clearAction = false,
    DateTime? dateFrom,
    bool clearDateFrom = false,
    DateTime? dateTo,
    bool clearDateTo = false,
  }) {
    return ModerationLogsFilter(
      entityType: clearEntity ? null : (entityType ?? this.entityType),
      action: clearAction ? null : (action ?? this.action),
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
    );
  }
}

class ModerationLogsState {
  const ModerationLogsState({
    this.logs = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 0,
    this.filter = const ModerationLogsFilter(),
  });

  final List<ModerationLog> logs;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;
  final ModerationLogsFilter filter;

  ModerationLogsState copyWith({
    List<ModerationLog>? logs,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
    ModerationLogsFilter? filter,
  }) {
    return ModerationLogsState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
      filter: filter ?? this.filter,
    );
  }
}

class ModerationLogsNotifier extends StateNotifier<ModerationLogsState> {
  ModerationLogsNotifier(this._repo) : super(const ModerationLogsState());

  final AdminRepository _repo;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await fetchPage(reset: true);
  }

  Future<void> fetchPage({bool reset = false}) async {
    if (state.isLoading) return;

    final nextPage = reset ? 1 : state.currentPage + 1;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repo.fetchModerationLogs(
        page: nextPage,
        entityType: state.filter.entityType,
        action: state.filter.action,
        dateFrom: state.filter.dateFrom,
        dateTo: state.filter.dateTo,
      );
      final logs = reset ? response.data : [...state.logs, ...response.data];

      state = state.copyWith(
        logs: logs,
        isLoading: false,
        hasMore: response.meta.hasMore,
        currentPage: nextPage,
      );
    } catch (err) {
      state = state.copyWith(isLoading: false, error: err.toString());
    }
  }

  Future<void> refresh() async {
    await fetchPage(reset: true);
  }

  Future<void> applyFilter(ModerationLogsFilter filter) async {
    state = state.copyWith(filter: filter);
    await fetchPage(reset: true);
  }

  Future<void> clearFilters() async {
    state = state.copyWith(filter: const ModerationLogsFilter());
    await fetchPage(reset: true);
  }
}

final moderationLogsNotifierProvider =
    StateNotifierProvider.autoDispose<
      ModerationLogsNotifier,
      ModerationLogsState
    >((ref) {
      final repository = ref.watch(adminRepositoryProvider);
      final notifier = ModerationLogsNotifier(repository)..initialize();
      return notifier;
    });
