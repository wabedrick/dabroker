import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consultationRepositoryProvider = Provider<ConsultationRepository>((ref) {
  return ConsultationRepository(ref.read(dioClientProvider));
});

class ConsultationRepository {
  final DioClient _client;

  ConsultationRepository(this._client);

  Future<void> createConsultation({
    required int userId,
    required DateTime scheduledAt,
    String? notes,
  }) async {
    try {
      await _client.dio.post(
        ApiEndpoints.consultations,
        data: {
          'user_id': userId,
          'scheduled_at': scheduledAt.toIso8601String(),
          'notes': notes,
        },
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
