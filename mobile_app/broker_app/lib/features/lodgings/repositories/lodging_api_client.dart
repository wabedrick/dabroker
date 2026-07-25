import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';


import 'package:broker_app/data/models/lodging_list_response.dart';

part 'lodging_api_client.g.dart';

@RestApi()
abstract class LodgingApiClient {
  factory LodgingApiClient(Dio dio, {String baseUrl}) = _LodgingApiClient;

  @GET('/lodgings')
  Future<LodgingListResponse> fetchLodgings(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/host/lodgings')
  Future<LodgingListResponse> fetchHostLodgings(
    @Queries() Map<String, dynamic> queries,
  );

  @POST('/ratings')
  Future<void> rateLodging(@Body() Map<String, dynamic> body);

  @GET('/lodgings/{id}')
  Future<dynamic> fetchLodgingDetailRaw(@Path('id') String id);

  @PUT('/host/lodgings/{id}')
  Future<dynamic> updateLodgingRaw(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('/host/lodgings')
  Future<dynamic> createLodgingRaw(@Body() Map<String, dynamic> body);

  @POST('/host/lodgings/{id}/media')
  @MultiPart()
  Future<void> uploadLodgingMedia(
    @Path('id') String id,
    @Part(name: "file") File file,
  );

  @DELETE('/host/lodgings/{id}')
  Future<void> deleteLodging(@Path('id') String id);

  @GET('/lodgings/{id}/availability')
  Future<dynamic> fetchAvailability(
    @Path('id') String id,
    @Queries() Map<String, dynamic> queries,
  );
}
