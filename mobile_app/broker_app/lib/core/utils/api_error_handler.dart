import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getErrorMessage(Object error) {
    if (error is DioException) {
      if (error.response != null && error.response?.data != null) {
        final data = error.response!.data;
        
        // Handle Laravel validation errors
        if (data is Map<String, dynamic>) {
          if (data.containsKey('errors')) {
            final errors = data['errors'];
            if (errors is Map<String, dynamic>) {
              // Combine all error messages
              final messages = <String>[];
              errors.forEach((key, value) {
                if (value is List) {
                  messages.addAll(value.map((e) => e.toString()));
                } else {
                  messages.add(value.toString());
                }
              });
              if (messages.isNotEmpty) {
                return messages.join('\n');
              }
            }
          }
          
          // Handle generic message
          if (data.containsKey('message')) {
            return data['message'].toString();
          }
        }
      }
      
      // Handle other Dio errors
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please check your internet connection.';
        case DioExceptionType.badResponse:
          return 'Server error: ${error.response?.statusCode}';
        case DioExceptionType.cancel:
          return 'Request cancelled';
        case DioExceptionType.connectionError:
          return 'No internet connection';
        default:
          return error.message ?? 'An unexpected error occurred';
      }
    }
    return error.toString();
  }
}
