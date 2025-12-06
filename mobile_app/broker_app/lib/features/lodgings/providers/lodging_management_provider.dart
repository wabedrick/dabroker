import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/features/lodgings/providers/lodging_list_provider.dart';
import 'package:broker_app/features/lodgings/repositories/lodging_repository.dart';

final lodgingManagementProvider =
    StateNotifierProvider<LodgingManagementNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(lodgingRepositoryProvider);
      return LodgingManagementNotifier(repository);
    });

class LodgingManagementNotifier extends StateNotifier<AsyncValue<void>> {
  LodgingManagementNotifier(this._repository)
    : super(const AsyncValue.data(null));

  final LodgingRepository _repository;

  Future<bool> createLodging(
    Map<String, dynamic> data, {
    List<File>? images,
  }) async {
    state = const AsyncValue.loading();
    try {
      final lodging = await _repository.createLodging(data);

      if (images != null && images.isNotEmpty) {
        for (final image in images) {
          await _repository.uploadLodgingMedia(lodging.id, image);
        }
      }

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updateLodging(
    String id,
    Map<String, dynamic> data, {
    List<File>? newImages,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateLodging(id, data);

      if (newImages != null && newImages.isNotEmpty) {
        for (final image in newImages) {
          await _repository.uploadLodgingMedia(id, image);
        }
      }

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
