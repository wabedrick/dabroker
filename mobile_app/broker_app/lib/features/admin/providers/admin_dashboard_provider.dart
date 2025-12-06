import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:broker_app/core/providers/app_providers.dart';
import 'package:broker_app/features/admin/data/admin_repository.dart';
import 'package:broker_app/features/admin/models/admin_analytics.dart';
import 'package:broker_app/features/admin/models/admin_dashboard_stats.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return AdminRepository(dio);
});

final adminDashboardStatsProvider =
    FutureProvider.autoDispose<AdminDashboardStats>((ref) async {
      final repository = ref.watch(adminRepositoryProvider);
      return repository.fetchDashboardStats();
    });

final adminDashboardAnalyticsProvider = FutureProvider.autoDispose
    .family<AdminAnalytics, int>((ref, rangeDays) async {
      final repository = ref.watch(adminRepositoryProvider);
      return repository.fetchDashboardAnalytics(rangeDays: rangeDays);
    });
