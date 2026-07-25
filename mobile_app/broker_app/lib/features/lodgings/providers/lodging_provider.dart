import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/features/lodgings/repositories/lodging_repository.dart';

import 'package:broker_app/features/lodgings/repositories/lodging_api_client.dart';

final lodgingApiClientProvider = Provider<LodgingApiClient>((ref) {
  final client = ref.watch(dioClientProvider);
  return LodgingApiClient(client.dio);
});

final lodgingRepositoryProvider = Provider<LodgingRepository>((ref) {
  final apiClient = ref.watch(lodgingApiClientProvider);
  return LodgingRepository(apiClient);
});
