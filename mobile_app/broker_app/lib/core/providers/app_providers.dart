import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/dio_client.dart';
import '../storage/storage_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StorageService(prefs);
});

final cacheDirectoryProvider = Provider<String>((ref) {
  throw UnimplementedError();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final cacheDir = ref.watch(cacheDirectoryProvider);
  return DioClient(cacheDir: cacheDir);
});
