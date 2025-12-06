import 'package:broker_app/features/inquiries/repositories/inquiry_repository.dart';
import 'package:broker_app/data/models/inquiry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ownerInquiryListProvider =
    StateNotifierProvider<OwnerInquiryListNotifier, AsyncValue<List<Inquiry>>>(
        (ref) {
  return OwnerInquiryListNotifier(ref.read(inquiryRepositoryProvider));
});

class OwnerInquiryListNotifier extends StateNotifier<AsyncValue<List<Inquiry>>> {
  final InquiryRepository _repository;

  OwnerInquiryListNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadInquiries() async {
    try {
      state = const AsyncValue.loading();
      final inquiries = await _repository.getOwnerInquiries();
      state = AsyncValue.data(inquiries);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
