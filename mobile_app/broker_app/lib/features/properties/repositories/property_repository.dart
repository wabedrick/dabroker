import 'dart:io';

import 'package:dio/dio.dart';

import 'package:broker_app/core/api/api_endpoints.dart';
import 'package:broker_app/core/api/dio_client.dart';
import 'package:broker_app/core/utils/api_error_handler.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/data/models/property_list_response.dart';

import '../models/property_query_params.dart';

class PropertyRepository {
  final DioClient _client;

  PropertyRepository(this._client);

  Future<PropertyListResponse> fetchProperties({
    required int page,
    required int perPage,
    PropertyQueryParams? params,
  }) async {
    try {
      final response = await _client.dio.get(
        ApiEndpoints.properties,
        queryParameters: {
          ...?params?.toQueryParameters(page: page, perPage: perPage),
          if (params == null) 'page': page,
          if (params == null) 'per_page': perPage,
        },
      );

      return PropertyListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Property> fetchPropertyDetail(String id) async {
    try {
      final response = await _client.dio.get(ApiEndpoints.propertyDetail(id));
      return Property.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> contactOwner({
    required String propertyId,
    required String message,
  }) async {
    try {
      await _client.dio.post(
        ApiEndpoints.propertyContact(propertyId),
        data: {'message': message},
      );
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
        await _client.dio.post(ApiEndpoints.favoriteProperty(propertyId));
      } else {
        await _client.dio.delete(ApiEndpoints.favoriteProperty(propertyId));
      }
      return favorite;
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Property> createProperty(Map<String, dynamic> data) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.ownerProperties,
        data: data,
      );
      return Property.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> uploadPropertyMedia(String propertyId, File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      await _client.dio.post(
        ApiEndpoints.ownerPropertyMedia(propertyId),
        data: formData,
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deletePropertyMedia(String propertyId, String mediaId) async {
    try {
      await _client.dio.delete(
        ApiEndpoints.ownerPropertyMediaDelete(propertyId, mediaId),
      );
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<Property> updateProperty(String id, Map<String, dynamic> data) async {
    try {
      final response = await _client.dio.put(
        ApiEndpoints.ownerPropertyDetail(id),
        data: data,
      );
      return Property.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }

  Future<void> deleteProperty(String id) async {
    try {
      await _client.dio.delete(ApiEndpoints.ownerPropertyDetail(id));
    } catch (error) {
      throw ApiErrorHandler.getErrorMessage(error);
    }
  }
}
