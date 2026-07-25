import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/data/models/user.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST(ApiEndpoints.register)
  Future<AuthResponse> register(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.login)
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.verifyOtp)
  Future<dynamic> verifyOtp(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.resendOtp)
  Future<void> resendOtp(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.logout)
  Future<void> logout();

  @GET(ApiEndpoints.profile)
  Future<dynamic> getProfile();

  @POST(ApiEndpoints.forgotPassword)
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.resetPassword)
  Future<void> resetPassword(@Body() Map<String, dynamic> body);
}
