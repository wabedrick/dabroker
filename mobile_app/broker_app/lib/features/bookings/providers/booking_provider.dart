import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/data/models/booking.dart';
import 'package:broker_app/features/bookings/repositories/booking_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final client = ref.watch(dioClientProvider);
  return BookingRepository(client);
});

final myBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getMyBookings();
});

final hostBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getHostBookings();
});

final bookingProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(bookingRepositoryProvider);
      return BookingNotifier(repository);
    });

class BookingNotifier extends StateNotifier<AsyncValue<void>> {
  final BookingRepository _repository;

  BookingNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<Booking?> createBooking(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final booking = await _repository.createBooking(data);
      state = const AsyncValue.data(null);
      return booking;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> updateStatus(String id, String status) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateBookingStatus(id, status);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
