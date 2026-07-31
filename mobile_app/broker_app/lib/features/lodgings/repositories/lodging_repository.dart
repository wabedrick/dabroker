import 'dart:io';

import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/data/models/lodging_list_response.dart';
import 'package:broker_app/data/models/lodging_room.dart';
import 'package:broker_app/data/models/rating.dart';
import 'package:broker_app/features/lodgings/repositories/lodging_api_client.dart';

class LodgingRepository {
  final LodgingApiClient _apiClient;

  LodgingRepository(this._apiClient);

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
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queries = {
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
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
      };
      return await _apiClient.fetchLodgings(queries);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<LodgingListResponse> fetchHostLodgings({
    required int page,
    required int perPage,
  }) async {
    try {
      return await _apiClient.fetchHostLodgings({
        'page': page,
        'per_page': perPage,
      });
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<List<Rating>> fetchRatings(String lodgingId, {int page = 1}) async {
    try {
      final response = await _apiClient.fetchRatings({
        'rateable_type': 'lodging',
        'rateable_id': lodgingId,
        'page': page,
      });
      final data = response['data'] as List<dynamic>;
      return data.map((e) => Rating.fromJson(e as Map<String, dynamic>)).toList();
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> rateLodging(String lodgingId, int rating, String review) async {
    try {
      await _apiClient.rateLodging({
        'rateable_type': 'lodging',
        'rateable_id': lodgingId,
        'rating': rating,
        'review': review,
      });
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Lodging> fetchLodgingDetail(String id) async {
    try {
      final response = await _apiClient.fetchLodgingDetailRaw(id);
      return Lodging.fromJson(response['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Lodging> updateLodging(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.updateLodgingRaw(id, data);
      return Lodging.fromJson(response['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Lodging> createLodging(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.createLodgingRaw(data);
      return Lodging.fromJson(response['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> uploadLodgingMedia(String lodgingId, File file) async {
    try {
      await _apiClient.uploadLodgingMedia(lodgingId, file);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deleteLodgingMedia(String lodgingId, String mediaId) async {
    try {
      await _apiClient.deleteLodgingMedia(lodgingId, mediaId);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deleteLodging(String id) async {
    try {
      await _apiClient.deleteLodging(id);
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
      final response = await _apiClient.fetchAvailability(
        lodgingId,
        {
          'check_in': checkIn.toIso8601String(),
          'check_out': checkOut.toIso8601String(),
        },
      );

      if (response is Map<String, dynamic> &&
          response.containsKey('available_rooms')) {
        return (response['available_rooms'] as num?)?.toInt();
      }

      if (response is Map<String, dynamic> && response['data'] != null) {
        final d = response['data'];
        if (d is Map<String, dynamic> && d.containsKey('available_rooms')) {
          return (d['available_rooms'] as num?)?.toInt();
        }
      }

      return null;
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<List<LodgingRoom>> fetchHostLodgingRooms(String lodgingId) async {
    try {
      final response = await _apiClient.fetchHostLodgingRoomsRaw(lodgingId);
      final data = response['data'] as List<dynamic>;
      return data.map((e) => LodgingRoom.fromJson(e as Map<String, dynamic>)).toList();
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<dynamic> createLodgingRoom(String lodgingId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.createLodgingRoomRaw(lodgingId, data);
      return response['data'];
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<dynamic> updateLodgingRoom(String lodgingId, String roomId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.updateLodgingRoomRaw(lodgingId, roomId, data);
      return response['data'];
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deleteLodgingRoom(String lodgingId, String roomId) async {
    try {
      await _apiClient.deleteLodgingRoom(lodgingId, roomId);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> uploadLodgingRoomMedia(String lodgingId, String roomId, File file) async {
    try {
      await _apiClient.uploadLodgingRoomMedia(lodgingId, roomId, file);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deleteLodgingRoomMedia(String lodgingId, String roomId, String mediaId) async {
    try {
      await _apiClient.deleteLodgingRoomMedia(lodgingId, roomId, mediaId);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
