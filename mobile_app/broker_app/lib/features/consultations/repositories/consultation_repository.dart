import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/consultation.dart';
import 'package:broker_app/features/consultations/repositories/consultation_api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consultationApiClientProvider = Provider<ConsultationApiClient>((ref) {
  final client = ref.watch(dioClientProvider);
  return ConsultationApiClient(client.dio);
});

final consultationRepositoryProvider = Provider<ConsultationRepository>((ref) {
  return ConsultationRepository(ref.watch(consultationApiClientProvider));
});

class ConsultationRepository {
  final ConsultationApiClient _apiClient;

  ConsultationRepository(this._apiClient);

  Future<Consultation> requestConsultation({
    required int professionalId,
    required DateTime scheduledAt,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.requestConsultationRaw({
        'professional_id': professionalId,
        'scheduled_at': scheduledAt.toIso8601String(),
        'notes': notes,
      });
      return Consultation.fromJson(response['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<List<Consultation>> getConsultations() async {
    try {
      final response = await _apiClient.getConsultationsRaw();
      final dynamic data = response;
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
      final response = await _apiClient.updateStatusRaw(publicId, {'status': status});
      return Consultation.fromJson(response['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
