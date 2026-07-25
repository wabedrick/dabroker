import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';


part 'booking_api_client.g.dart';

@RestApi()
abstract class BookingApiClient {
  factory BookingApiClient(Dio dio, {String baseUrl}) = _BookingApiClient;

  @POST('/bookings')
  Future<dynamic> createBookingRaw(@Body() Map<String, dynamic> body);

  @GET('/bookings')
  Future<dynamic> getMyBookingsRaw();

  @GET('/host/bookings')
  Future<dynamic> getHostBookingsRaw();

  @PUT('/bookings/{id}')
  Future<dynamic> updateBookingStatusRaw(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}
