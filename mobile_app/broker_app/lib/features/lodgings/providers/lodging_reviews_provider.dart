import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/data/models/rating.dart';
import 'package:broker_app/features/lodgings/providers/lodging_list_provider.dart';

final lodgingReviewsProvider = FutureProvider.family.autoDispose<List<Rating>, String>((ref, lodgingId) async {
  final repository = ref.watch(lodgingRepositoryProvider);
  return repository.fetchRatings(lodgingId);
});
