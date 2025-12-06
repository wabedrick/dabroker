import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:broker_app/features/notifications/models/notification_item.dart';
import 'package:broker_app/features/notifications/repositories/notification_repository.dart';

import 'notification_counters_provider.dart';

final notificationListProvider =
    StateNotifierProvider<
      NotificationListNotifier,
      Map<NotificationCategory, AsyncValue<List<NotificationItem>>>
    >((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      return NotificationListNotifier(repository);
    });

class NotificationListNotifier
    extends
        StateNotifier<
          Map<NotificationCategory, AsyncValue<List<NotificationItem>>>
        > {
  NotificationListNotifier(this._repository) : super({});

  final NotificationRepository _repository;

  Future<void> load(NotificationCategory category, {bool force = false}) async {
    final current = state[category];
    if (!force && current is AsyncData<List<NotificationItem>>) {
      return;
    }

    state = {...state, category: const AsyncLoading<List<NotificationItem>>()};

    try {
      final items = await _repository.fetchNotifications(category);
      state = {...state, category: AsyncData<List<NotificationItem>>(items)};
    } catch (error, stackTrace) {
      state = {
        ...state,
        category: AsyncError<List<NotificationItem>>(error, stackTrace),
      };
    }
  }

  Future<void> approveBooking(String bookingId) async {
    try {
      await _repository.approveBooking(bookingId);
      try {
        await load(NotificationCategory.reservations, force: true);
      } catch (_) {
        // Ignore reload errors as the action succeeded
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectBooking(String bookingId) async {
    try {
      await _repository.rejectBooking(bookingId);
      try {
        await load(NotificationCategory.reservations, force: true);
      } catch (_) {
        // Ignore reload errors as the action succeeded
      }
    } catch (e) {
      rethrow;
    }
  }
}
