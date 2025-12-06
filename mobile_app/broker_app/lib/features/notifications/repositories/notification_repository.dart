import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/features/notifications/models/notification_counters.dart';
import 'package:broker_app/features/notifications/models/notification_item.dart';

class NotificationRepository {
  NotificationRepository(this._client);

  final DioClient _client;

  Future<NotificationCounters> fetchCounters() async {
    try {
      final response = await _client.dio.get(
        ApiEndpoints.notificationsCounters,
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final payload = data['data'];
        if (payload is Map<String, dynamic>) {
          return NotificationCounters.fromJson(payload);
        }
        return NotificationCounters.fromJson(data);
      }
      throw const FormatException('Invalid counters payload');
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<List<NotificationItem>> fetchNotifications(
    NotificationCategory category,
  ) async {
    try {
      final String endpoint = switch (category) {
        NotificationCategory.inquiries => ApiEndpoints.ownerInquiries,
        NotificationCategory.favorites => ApiEndpoints.ownerInterestedBuyers,
        NotificationCategory.bookings => ApiEndpoints.bookings,
        NotificationCategory.reservations => ApiEndpoints.hostBookings,
      };

      final response = await _client.dio.get(endpoint);
      final payload = _extractList(response.data);
      return payload
          .map(
            (raw) => NotificationItem.fromJson(
              raw as Map<String, dynamic>,
              category,
            ),
          )
          .toList(growable: false);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> approveBooking(String bookingId) async {
    try {
      await _client.dio.post(ApiEndpoints.hostBookingApprove(bookingId));
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> rejectBooking(String bookingId) async {
    try {
      await _client.dio.post(ApiEndpoints.hostBookingReject(bookingId));
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final list = data['data'] ?? data['items'];
      if (list is List) return list;
    }
    throw const FormatException('Invalid notification payload');
  }
}
