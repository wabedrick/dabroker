import 'dart:io';

import 'package:dio/dio.dart';
import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/data/models/pagination.dart';

class LodgingListResponse {
  final List<Lodging> data;
  final PaginationMeta meta;

  LodgingListResponse({required this.data, required this.meta});

  factory LodgingListResponse.fromJson(Map<String, dynamic> json) {
    return LodgingListResponse(
      data: (json['data'] as List)
          .map((e) => Lodging.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

class LodgingRepository {
  final DioClient _client;

  LodgingRepository(this._client);

  Future<LodgingListResponse> fetchLodgings({
    required int page,
    required int perPage,
    String? type,
    String? search,
    double? latitude,
    double? longitude,
    double? radius,
    double? north,
    double? south,
    double? east,
    double? west,
    String? sortBy,
  }) async {
    try {
      final response = await _client.dio.get(
        ApiEndpoints.lodgings,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (type != null) 'type': type,
          if (search != null) 'search': search,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
          if (radius != null) 'radius': radius,
          if (north != null) 'north': north,
          if (south != null) 'south': south,
          if (east != null) 'east': east,
          if (west != null) 'west': west,
          if (sortBy != null) 'sort_by': sortBy,
        },
      );
      return LodgingListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<LodgingListResponse> fetchHostLodgings({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await _client.dio.get(
        '/host/lodgings',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return LodgingListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> rateLodging(String lodgingId, int rating, String review) async {
    try {
      await _client.dio.post(
        '/ratings',
        data: {
          'rateable_type': 'lodging',
          'rateable_id': lodgingId,
          'rating': rating,
          'review': review,
        },
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Lodging> fetchLodgingDetail(String id) async {
    try {
      final response = await _client.dio.get(ApiEndpoints.lodgingDetail(id));
      return Lodging.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Lodging> updateLodging(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.dio.put(
        ApiEndpoints.hostLodgingDetail(id),
        data: data,
      );
      return Lodging.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Lodging> createLodging(Map<String, dynamic> data) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.hostLodgings,
        data: data,
      );
      return Lodging.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> uploadLodgingMedia(String lodgingId, File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      await _client.dio.post(
        '${ApiEndpoints.hostLodgings}/$lodgingId/media',
        data: formData,
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deleteLodging(String id) async {
    try {
      await _client.dio.delete(ApiEndpoints.hostLodgingDetail(id));
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<int?> fetchAvailability(
    String lodgingId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    try {
      final response = await _client.dio.get(
        ApiEndpoints.lodgingAvailability(lodgingId),
        queryParameters: {
          'check_in': checkIn.toIso8601String(),
          'check_out': checkOut.toIso8601String(),
        },
      );

      if (response.data is Map<String, dynamic> &&
          response.data.containsKey('available_rooms')) {
        return (response.data['available_rooms'] as num?)?.toInt();
      }

      // Some APIs nest in data
      if (response.data is Map<String, dynamic> &&
          response.data['data'] != null) {
        final d = response.data['data'];
        if (d is Map<String, dynamic> && d.containsKey('available_rooms')) {
          return (d['available_rooms'] as num?)?.toInt();
        }
      }

      return null;
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
