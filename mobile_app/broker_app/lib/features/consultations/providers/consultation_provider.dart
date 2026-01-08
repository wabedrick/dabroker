import 'package:broker_app/data/models/consultation.dart';
import 'package:broker_app/features/consultations/repositories/consultation_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consultationListProvider =
    StateNotifierProvider<ConsultationListNotifier, AsyncValue<List<Consultation>>>(
      (ref) =>
          ConsultationListNotifier(ref.read(consultationRepositoryProvider)),
    );

class ConsultationListNotifier extends StateNotifier<AsyncValue<List<Consultation>>> {
  final ConsultationRepository _repository;

  ConsultationListNotifier(this._repository)
    : super(const AsyncValue.loading()) {
    loadConsultations();
  }

  Future<void> loadConsultations() async {
    try {
      state = const AsyncValue.loading();
      final consultations = await _repository.getConsultations();
      state = AsyncValue.data(consultations);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateStatus(String publicId, String status) async {
    try {
      await _repository.updateStatus(publicId, status);
      // Reload to get fresh data
      await loadConsultations();
    } catch (e) {
      // Handle error (maybe show snackbar in UI)
      rethrow;
    }
  }
}
