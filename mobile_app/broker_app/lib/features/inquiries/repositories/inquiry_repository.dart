import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/inquiry.dart';
import 'package:broker_app/data/models/inquiry_message.dart';
import 'package:broker_app/features/inquiries/repositories/inquiry_api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final inquiryApiClientProvider = Provider<InquiryApiClient>((ref) {
  final client = ref.watch(dioClientProvider);
  return InquiryApiClient(client.dio);
});

final inquiryRepositoryProvider = Provider<InquiryRepository>((ref) {
  return InquiryRepository(ref.watch(inquiryApiClientProvider));
});

class InquiryRepository {
  final InquiryApiClient _apiClient;

  InquiryRepository(this._apiClient);

  Future<Inquiry> getBookingInquiry(String bookingId) async {
    try {
      final response = await _apiClient.getBookingInquiryRaw(bookingId);
      return Inquiry.fromJson(response['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Inquiry> getInquiry(String inquiryId) async {
    try {
      final response = await _apiClient.getInquiryRaw(inquiryId);
      return Inquiry.fromJson(response['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<List<Inquiry>> getOwnerInquiries({int page = 1}) async {
    try {
      final response = await _apiClient.getOwnerInquiriesRaw(page);
      return (response['data'] as List)
          .map((e) => Inquiry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<InquiryMessage> sendMessage(String inquiryId, String message) async {
    try {
      final response = await _apiClient.sendMessageRaw(inquiryId, {'message': message});
      return InquiryMessage.fromJson((response['data'] ?? response) as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
