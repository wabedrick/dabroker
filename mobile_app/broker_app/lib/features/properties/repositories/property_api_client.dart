import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/data/models/property_list_response.dart';

part 'property_api_client.g.dart';

@RestApi()
abstract class PropertyApiClient {
  factory PropertyApiClient(Dio dio, {String baseUrl}) = _PropertyApiClient;

  @GET('/properties')
  Future<PropertyListResponse> fetchProperties(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/properties/{id}')
  Future<dynamic> fetchPropertyDetailRaw(@Path('id') String id);

  @POST('/properties/{id}/contact')
  Future<void> contactOwner(
    @Path('id') String propertyId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/favorites/properties/{id}')
  Future<void> favoriteProperty(@Path('id') String propertyId);

  @DELETE('/favorites/properties/{id}')
  Future<void> unfavoriteProperty(@Path('id') String propertyId);

  @POST('/owner/properties')
  Future<dynamic> createPropertyRaw(@Body() Map<String, dynamic> body);

  @POST('/owner/properties/{id}/media')
  @MultiPart()
  Future<void> uploadPropertyMedia(
    @Path('id') String propertyId,
    @Part(name: "file") File file,
  );

  @DELETE('/owner/properties/{id}/media/{mediaId}')
  Future<void> deletePropertyMedia(
    @Path('id') String propertyId,
    @Path('mediaId') String mediaId,
  );

  @PUT('/owner/properties/{id}')
  Future<dynamic> updatePropertyRaw(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/owner/properties/{id}')
  Future<void> deleteProperty(@Path('id') String id);

  @GET('/owner/properties/{id}/rooms')
  Future<dynamic> getRoomsRaw(@Path('id') String propertyId);

  @POST('/owner/properties/{id}/rooms')
  Future<dynamic> createRoomRaw(
    @Path('id') String propertyId,
    @Body() Map<String, dynamic> body,
  );

  @PUT('/owner/properties/{id}/rooms/{roomId}')
  Future<dynamic> updateRoomRaw(
    @Path('id') String propertyId,
    @Path('roomId') String roomId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/owner/properties/{id}/rooms/{roomId}')
  Future<void> deleteRoom(
    @Path('id') String propertyId,
    @Path('roomId') String roomId,
  );
}
