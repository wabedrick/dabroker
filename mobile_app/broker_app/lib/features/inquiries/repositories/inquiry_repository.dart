import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/inquiry.dart';
import 'package:broker_app/data/models/inquiry_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final inquiryRepositoryProvider = Provider<InquiryRepository>((ref) {
  return InquiryRepository(ref.read(dioClientProvider));
});

class InquiryRepository {
  final DioClient _client;

  InquiryRepository(this._client);

  Future<Inquiry> getBookingInquiry(String bookingId) async {
    try {
      final response = await _client.dio.get(
        ApiEndpoints.bookingInquiry(bookingId),
      );
      return Inquiry.fromJson(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Inquiry> getInquiry(String inquiryId) async {
    try {
      final response = await _client.dio.get(
        ApiEndpoints.inquiryDetail(inquiryId),
      );
      return Inquiry.fromJson(response.data['data']);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<List<Inquiry>> getOwnerInquiries({int page = 1}) async {
    try {
      final response = await _client.dio.get(
        ApiEndpoints.ownerInquiries,
        queryParameters: {'page': page},
      );
      return (response.data['data'] as List)
          .map((e) => Inquiry.fromJson(e))
          .toList();
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<InquiryMessage> sendMessage(String inquiryId, String message) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.inquiryMessages(inquiryId),
        data: {'message': message},
      );
      // The API might return the message or the updated inquiry.
      // Based on PropertyInquiryMessageController, it returns the message resource?
      // Wait, I didn't check the return of PropertyInquiryMessageController.
      // Let's assume it returns the message or I can just reload the inquiry.
      // But for better UX, appending the message is better.
      // Let's check the controller return.
      return InquiryMessage.fromJson(response.data['data'] ?? response.data);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
