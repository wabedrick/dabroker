import 'dart:io';

import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/data/models/property_list_response.dart';
import 'package:broker_app/data/models/room.dart';
import 'package:broker_app/features/properties/repositories/property_api_client.dart';

import '../models/property_query_params.dart';

class PropertyRepository {
  final PropertyApiClient _apiClient;

  PropertyRepository(this._apiClient);

  Future<PropertyListResponse> fetchProperties({
    required int page,
    required int perPage,
    PropertyQueryParams? params,
  }) async {
    try {
      final queries = {
        ...?params?.toQueryParameters(page: page, perPage: perPage),
        if (params == null) 'page': page,
        if (params == null) 'per_page': perPage,
      };
      return await _apiClient.fetchProperties(queries);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Property> fetchPropertyDetail(String id) async {
    try {
      return await _apiClient.fetchPropertyDetail(id);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> contactOwner({
    required String propertyId,
    required String message,
  }) async {
    try {
      await _apiClient.contactOwner(propertyId, {'message': message});
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<bool> toggleFavorite({
    required String propertyId,
    required bool favorite,
  }) async {
    try {
      if (favorite) {
        await _apiClient.favoriteProperty(propertyId);
      } else {
        await _apiClient.unfavoriteProperty(propertyId);
      }
      return favorite;
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Property> createProperty(Map<String, dynamic> data) async {
    try {
      return await _apiClient.createProperty(data);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> uploadPropertyMedia(String propertyId, File file) async {
    try {
      await _apiClient.uploadPropertyMedia(propertyId, file);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deletePropertyMedia(String propertyId, String mediaId) async {
    try {
      await _apiClient.deletePropertyMedia(propertyId, mediaId);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Property> updateProperty(String id, Map<String, dynamic> data) async {
    try {
      return await _apiClient.updateProperty(id, data);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deleteProperty(String id) async {
    try {
      await _apiClient.deleteProperty(id);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<List<Room>> getRooms(String propertyId) async {
    try {
      final response = await _apiClient.getRoomsRaw(propertyId);
      final List<dynamic> data = response['data'];
      return data.map((json) => Room.fromJson(json as Map<String, dynamic>)).toList();
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Room> createRoom(String propertyId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.createRoomRaw(propertyId, data);
      return Room.fromJson(response['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Room> updateRoom(String propertyId, String roomId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.updateRoomRaw(propertyId, roomId, data);
      return Room.fromJson(response['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deleteRoom(String propertyId, String roomId) async {
    try {
      await _apiClient.deleteRoom(propertyId, roomId);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
