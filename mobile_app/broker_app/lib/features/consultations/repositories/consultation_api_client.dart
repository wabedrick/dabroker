import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'consultation_api_client.g.dart';

@RestApi()
abstract class ConsultationApiClient {
  factory ConsultationApiClient(Dio dio, {String baseUrl}) =
      _ConsultationApiClient;

  @POST('/consultations')
  Future<dynamic> requestConsultationRaw(@Body() Map<String, dynamic> body);

  @GET('/consultations')
  Future<dynamic> getConsultationsRaw();

  @PUT('/consultations/{publicId}')
  Future<dynamic> updateStatusRaw(
    @Path('publicId') String publicId,
    @Body() Map<String, dynamic> body,
  );
}
