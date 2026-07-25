import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/booking.dart';
import 'package:broker_app/features/bookings/repositories/booking_api_client.dart';

class BookingRepository {
  final BookingApiClient _apiClient;

  BookingRepository(this._apiClient);

  Future<Booking> createBooking(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.createBookingRaw(data);
      return Booking.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<List<Booking>> getMyBookings() async {
    try {
      final response = await _apiClient.getMyBookingsRaw();
      final List<dynamic> data = response['data'];
      return data.map((json) => Booking.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<List<Booking>> getHostBookings() async {
    try {
      final response = await _apiClient.getHostBookingsRaw();
      final List<dynamic> data = response['data'];
      return data.map((json) => Booking.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<Booking> updateBookingStatus(String id, String status) async {
    try {
      final response = await _apiClient.updateBookingStatusRaw(id, {'status': status});
      return Booking.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }
}
