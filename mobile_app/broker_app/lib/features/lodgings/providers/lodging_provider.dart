import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/features/lodgings/repositories/lodging_repository.dart';

final lodgingRepositoryProvider = Provider<LodgingRepository>((ref) {
  final client = ref.watch(dioClientProvider);
  return LodgingRepository(client);
});
