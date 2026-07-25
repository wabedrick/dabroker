import 'package:broker_app/core/api/auth_api_client.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/storage/storage_service.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/user.dart';

class AuthRepository {
  final DioClient _dioClient;
  final StorageService _storage;
  late final AuthApiClient _apiClient;

  AuthRepository(this._dioClient, this._storage) {
    _apiClient = AuthApiClient(_dioClient.dio);
  }

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
      final authResponse = await _apiClient.register({
        'name': name,
        'email': email,
        'phone': phone,
        'country_code': countryCode,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'preferred_role': preferredRole ?? 'buyer',
      });

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
      final authResponse = await _apiClient.login({
        'identifier': identifier,
        'password': password,
        'device_name': 'mobile',
      });

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
      final response = await _apiClient.verifyOtp({
        'identifier': identifier,
        'otp': otp,
        'purpose': purpose,
      });

      // Update user data after verification
      final data = response['data'];
      if (data != null && data is Map<String, dynamic>) {
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
      await _apiClient.resendOtp({
        'identifier': identifier,
        'purpose': purpose,
      });
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<void> logout() async {
    try {
      if (await _dioClient.isAuthenticated) {
        await _apiClient.logout();
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
      final response = await _apiClient.getProfile();
      final user = User.fromJson(response['data'] as Map<String, dynamic>);
      await _storage.saveUser(user.toJson());
      return user;
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }

  Future<void> forgotPassword({required String identifier}) async {
    try {
      await _apiClient.forgotPassword({
        'identifier': identifier,
      });
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
      await _apiClient.resetPassword({
        'identifier': identifier,
        'otp': otp,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });
    } catch (e) {
      throw ApiErrorHandler.getErrorMessage(e);
    }
  }
}
