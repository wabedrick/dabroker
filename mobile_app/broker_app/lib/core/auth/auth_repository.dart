import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/storage/storage_service.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/user.dart';

class AuthRepository {
  final DioClient _dioClient;
  final StorageService _storage;

  AuthRepository(this._dioClient, this._storage);

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String phone,
    required String countryCode,
    required String password,
    required String passwordConfirmation,
    String? preferredRole,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'country_code': countryCode,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'preferred_role': preferredRole ?? 'buyer',
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Save user data
      await _storage.saveUser(authResponse.data.toJson());

      return authResponse;
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<AuthResponse> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: {
          'identifier': identifier,
          'password': password,
          'device_name': 'mobile',
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Save token and user data
      if (authResponse.token != null) {
        await _dioClient.setAuthToken(authResponse.token!);
      }

      await _storage.saveUser(authResponse.data.toJson());

      return authResponse;
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<void> verifyOtp({
    required String identifier,
    required String otp,
    required String purpose,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.verifyOtp,
        data: {'identifier': identifier, 'otp': otp, 'purpose': purpose},
      );

      // Update user data after verification
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        final user = User.fromJson(data);
        await _storage.saveUser(user.toJson());
      }
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<void> resendOtp({
    required String identifier,
    required String purpose,
  }) async {
    try {
      await _dioClient.dio.post(
        ApiEndpoints.resendOtp,
        data: {'identifier': identifier, 'purpose': purpose},
      );
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<void> logout() async {
    try {
      if (_dioClient.isAuthenticated) {
        await _dioClient.dio.post(ApiEndpoints.logout);
      }
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      await _dioClient.clearAuthToken();
      await _storage.clearUser();
    }
  }

  Future<User> getProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.profile);
      final user = User.fromJson(response.data['data']);
      await _storage.saveUser(user.toJson());
      return user;
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<void> forgotPassword({required String identifier}) async {
    try {
      await _dioClient.dio.post(
        ApiEndpoints.forgotPassword,
        data: {'identifier': identifier},
      );
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<void> resetPassword({
    required String identifier,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _dioClient.dio.post(
        ApiEndpoints.resetPassword,
        data: {
          'identifier': identifier,
          'otp': otp,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }
}
