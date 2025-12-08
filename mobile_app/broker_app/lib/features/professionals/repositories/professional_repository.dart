import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/pagination.dart';
import 'package:broker_app/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final professionalRepositoryProvider = Provider<ProfessionalRepository>((ref) {
  return ProfessionalRepository(ref.read(dioClientProvider));
});

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

      return Pagination.fromJson(
        response.data,
        (json) => User.fromJson(json as Map<String, dynamic>),
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
}
