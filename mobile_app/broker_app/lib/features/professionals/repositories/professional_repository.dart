import 'package:dio/dio.dart';
import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/pagination.dart';
import 'package:broker_app/data/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final professionalRepositoryProvider = Provider<ProfessionalRepository>((ref) {
  return ProfessionalRepository(ref.read(dioClientProvider));
});

Pagination<User> _parseProfessionalsResponse(Map<String, dynamic> data) {
  return Pagination.fromJson(
    data,
    (json) => User.fromJson(json as Map<String, dynamic>),
  );
}

class ProfessionalRepository {
  final DioClient _client;

  ProfessionalRepository(this._client);

  Future<Pagination<User>> getProfessionals({
    int page = 1,
    String? type,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page,
        if (type != null) 'type': type,
        if (search != null) 'search': search,
      };

      final response = await _client.dio.get(
        ApiEndpoints.professionals,
        queryParameters: queryParams,
      );

      return compute(
        _parseProfessionalsResponse,
        response.data as Map<String, dynamic>,
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<User> getProfessional(String id) async {
    try {
      final response = await _client.dio.get(
        ApiEndpoints.professionalDetail(id),
      );
      return User.fromJson(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Map<String, dynamic>> contactProfessional(
    String professionalId,
    String message,
  ) async {
    try {
      final response = await _client.dio.post(
        '/professionals/$professionalId/contact',
        data: {'message': message},
      );
      return response.data['data'];
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> rateProfessional(
    int professionalId,
    int rating,
    String review,
  ) async {
    try {
      await _client.dio.post(
        '/ratings',
        data: {
          'rateable_type': 'user',
          'rateable_id': professionalId,
          'rating': rating,
          'review': review,
        },
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Pagination<Map<String, dynamic>>> getReviews(
    int professionalId, {
    int page = 1,
  }) async {
    try {
      final response = await _client.dio.get(
        '/ratings',
        queryParameters: {
          'rateable_type': 'user',
          'rateable_id': professionalId,
          'page': page,
        },
      );
      return Pagination.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      // Check if there's a file in the data
      bool hasFile = data.values.any((element) => element is MultipartFile);

      if (hasFile) {
        // Laravel sometimes has issues with PUT and FormData (multipart/form-data).
        // A common workaround is POST with _method=PUT.
        data['_method'] = 'PUT';

        // Pre-process data for FormData/Laravel compatibility
        final Map<String, dynamic> formattedData = {};
        data.forEach((key, value) {
          if (value is List) {
            // Append [] to key for PHP array handling in FormData
            formattedData['$key[]'] = value;
          } else if (value is bool) {
            // Convert bool to 1/0 for Laravel validation (doesn't accept "true"/"false" strings)
            formattedData[key] = value ? 1 : 0;
          } else {
            formattedData[key] = value;
          }
        });

        final formDataWithMethod = FormData.fromMap(formattedData);

        await _client.dio.post(
          '/professionals/profile',
          data: formDataWithMethod,
        );
      } else {
        await _client.dio.put('/professional/profile', data: data);
      }
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<List<dynamic>> getPortfolio() async {
    try {
      final response = await _client.dio.get('/professional/portfolio');
      return response.data as List<dynamic>;
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> addPortfolioItem(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      await _client.dio.post('/professional/portfolio', data: formData);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> updatePortfolioItem(int id, Map<String, dynamic> data) async {
    try {
      data['_method'] = 'PUT';
      final formData = FormData.fromMap(data);
      await _client.dio.post('/professional/portfolio/$id', data: formData);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deletePortfolioItem(int id) async {
    try {
      await _client.dio.delete('/professional/portfolio/$id');
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
