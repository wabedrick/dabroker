import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/features/notifications/models/notification_counters.dart';
import 'package:broker_app/features/notifications/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final client = ref.watch(dioClientProvider);
  return NotificationRepository(client);
});

final notificationCountersProvider =
    StateNotifierProvider<
      NotificationCountersNotifier,
      NotificationCountersState
    >((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      final notifier = NotificationCountersNotifier(repository);
      notifier.fetchCounters();
      return notifier;
    });

class NotificationCountersState {
  const NotificationCountersState({
    this.counters,
    this.isLoading = false,
    this.error,
    this.hasInitialized = false,
  });

  static const _sentinel = Object();
  final NotificationCounters? counters;
  final bool isLoading;
  final String? error;
  final bool hasInitialized;

  NotificationCountersState copyWith({
    NotificationCounters? counters,
    bool? isLoading,
    Object? error = _sentinel,
    bool? hasInitialized,
  }) {
    return NotificationCountersState(
      counters: counters ?? this.counters,
      isLoading: isLoading ?? this.isLoading,
      error: error == _sentinel ? this.error : error as String?,
      hasInitialized: hasInitialized ?? this.hasInitialized,
    );
  }
}

class NotificationCountersNotifier
    extends StateNotifier<NotificationCountersState> {
  NotificationCountersNotifier(this._repository)
    : super(const NotificationCountersState());

  final NotificationRepository _repository;

  Future<void> fetchCounters({bool force = false}) async {
    if (state.isLoading) return;
    if (state.hasInitialized && !force) return;

    state = state.copyWith(isLoading: true, error: null, hasInitialized: true);

    try {
      final counters = await _repository.fetchCounters();
      state = state.copyWith(counters: counters, isLoading: false);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<void> refresh() => fetchCounters(force: true);
}
