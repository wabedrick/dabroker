import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/data/models/user.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/features/lodgings/repositories/lodging_repository.dart';
import 'package:broker_app/features/admin/models/admin_analytics.dart';
import 'package:broker_app/features/admin/models/admin_dashboard_stats.dart';
import 'package:broker_app/features/admin/models/moderation_log.dart';
import 'package:broker_app/features/admin/models/user_list_response.dart';
import 'package:broker_app/data/models/property_list_response.dart';

class AdminRepository {
  AdminRepository(this._dioClient);

  final DioClient _dioClient;

  Future<AdminDashboardStats> fetchDashboardStats() async {
    final response = await _dioClient.dio.get(ApiEndpoints.adminDashboardStats);
    return AdminDashboardStats.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AdminAnalytics> fetchDashboardAnalytics({int rangeDays = 30}) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.adminDashboardAnalytics,
      queryParameters: {'range_days': rangeDays},
    );
    return AdminAnalytics.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ModerationLogResponse> fetchModerationLogs({
    int page = 1,
    int perPage = 20,
    String? entityType,
    String? action,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.adminModerationLogs,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (entityType != null) 'entity_type': entityType,
        if (action != null) 'action': action,
        if (dateFrom != null) 'date_from': dateFrom.toIso8601String(),
        if (dateTo != null) 'date_to': dateTo.toIso8601String(),
      },
    );
    return ModerationLogResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<UserListResponse> fetchUsers({
    int page = 1,
    String? search,
    String? role,
  }) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.adminUsers,
      queryParameters: {
        'page': page,
        if (search != null && search.isNotEmpty) 'search': search,
        if (role != null && role != 'all') 'role': role,
      },
    );
    return UserListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<User> updateUser(String id, Map<String, dynamic> data) async {
    final response = await _dioClient.dio.patch(
      ApiEndpoints.adminUser(id),
      data: data,
    );
    return User.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteUser(String id) async {
    await _dioClient.dio.delete(ApiEndpoints.adminUser(id));
  }

  Future<PropertyListResponse> fetchProperties({
    int page = 1,
    String? status,
  }) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.adminProperties,
      queryParameters: {'page': page, if (status != null) 'status': status},
    );
    return PropertyListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Property> approveProperty(String id) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.adminPropertyApprove(id),
    );
    return Property.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<Property> rejectProperty(String id, String reason) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.adminPropertyReject(id),
      data: {'reason': reason},
    );
    return Property.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<LodgingListResponse> fetchLodgings({
    int page = 1,
    String? status,
  }) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.adminLodgings,
      queryParameters: {'page': page, if (status != null) 'status': status},
    );
    return LodgingListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Lodging> approveLodging(String id) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.adminLodgingApprove(id),
    );
    return Lodging.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<Lodging> rejectLodging(String id, String reason) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.adminLodgingReject(id),
      data: {'reason': reason},
    );
    return Lodging.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
