import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';



part 'inquiry_api_client.g.dart';

@RestApi()
abstract class InquiryApiClient {
  factory InquiryApiClient(Dio dio, {String baseUrl}) = _InquiryApiClient;

  @GET('/bookings/{bookingId}/inquiry')
  Future<dynamic> getBookingInquiryRaw(@Path('bookingId') String bookingId);

  @GET('/inquiries/{inquiryId}')
  Future<dynamic> getInquiryRaw(@Path('inquiryId') String inquiryId);

  @GET('/inquiries')
  Future<dynamic> getOwnerInquiriesRaw(@Query('page') int page);

  @POST('/inquiries/{inquiryId}/messages')
  Future<dynamic> sendMessageRaw(
    @Path('inquiryId') String inquiryId,
    @Body() Map<String, dynamic> body,
  );
}
