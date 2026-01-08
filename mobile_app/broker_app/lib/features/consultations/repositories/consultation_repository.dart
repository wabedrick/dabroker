import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/consultation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consultationRepositoryProvider = Provider<ConsultationRepository>((ref) {
  return ConsultationRepository(ref.read(dioClientProvider));
});

class ConsultationRepository {
  final DioClient _client;

  ConsultationRepository(this._client);

  Future<Consultation> requestConsultation({
    required int professionalId,
    required DateTime scheduledAt,
    String? notes,
  }) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.consultations,
        data: {
          'professional_id': professionalId,
          'scheduled_at': scheduledAt.toIso8601String(),
          'notes': notes,
        },
      );
      return Consultation.fromJson(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<List<Consultation>> getConsultations() async {
    try {
      final response = await _client.dio.get(ApiEndpoints.consultations);
      final dynamic data = response.data;
      List<dynamic> list;

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        list = data['data'] as List<dynamic>;
      } else if (data is List) {
        list = data;
      } else {
        list = [];
      }

      return list
          .map((json) => Consultation.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Consultation> updateStatus(String publicId, String status) async {
    try {
      final response = await _client.dio.put(
        '${ApiEndpoints.consultations}/$publicId',
        data: {'status': status},
      );
      return Consultation.fromJson(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
