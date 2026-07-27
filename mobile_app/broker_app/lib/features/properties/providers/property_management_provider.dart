import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/features/properties/providers/property_list_provider.dart';
import 'package:broker_app/features/properties/repositories/property_repository.dart';

final propertyManagementProvider =
    StateNotifierProvider<PropertyManagementNotifier, AsyncValue<void>>((ref) {
      final repository = ref.watch(propertyRepositoryProvider);
      return PropertyManagementNotifier(repository);
    });

class PropertyManagementNotifier extends StateNotifier<AsyncValue<void>> {
  PropertyManagementNotifier(this._repository)
    : super(const AsyncValue.data(null));

  final PropertyRepository _repository;

  Future<Property?> createProperty(
    Map<String, dynamic> data, {
    List<File>? images,
  }) async {
    state = const AsyncValue.loading();
    try {
      final property = await _repository.createProperty(data);

      if (images != null && images.isNotEmpty) {
        for (final image in images) {
          await _repository.uploadPropertyMedia(property.id, image);
        }
      }

      state = const AsyncValue.data(null);
      return property;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<Property?> updateProperty(
    String id,
    Map<String, dynamic> data, {
    List<File>? newImages,
    List<String>? deletedImageIds,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProperty(id, data);

      if (deletedImageIds != null && deletedImageIds.isNotEmpty) {
        for (final mediaId in deletedImageIds) {
          await _repository.deletePropertyMedia(id, mediaId);
        }
      }

      if (newImages != null && newImages.isNotEmpty) {
        for (final image in newImages) {
          await _repository.uploadPropertyMedia(id, image);
        }
      }

      state = const AsyncValue.data(null);
      final updatedProperty = await _repository.fetchPropertyDetail(id);
      return updatedProperty;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
