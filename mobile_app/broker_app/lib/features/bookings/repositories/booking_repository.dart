import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/booking.dart';

class BookingRepository {
  final DioClient _client;

  BookingRepository(this._client);

  Future<Booking> createBooking(Map<String, dynamic> data) async {
    try {
      final response = await _client.dio.post('/bookings', data: data);
      return Booking.fromJson(response.data['data']);
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<List<Booking>> getMyBookings() async {
    try {
      final response = await _client.dio.get('/bookings');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<List<Booking>> getHostBookings() async {
    try {
      final response = await _client.dio.get('/host/bookings');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<Booking> updateBookingStatus(String id, String status) async {
    try {
      final response = await _client.dio.put(
        '/bookings/$id',
        data: {'status': status},
      );
      return Booking.fromJson(response.data['data']);
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }
}
