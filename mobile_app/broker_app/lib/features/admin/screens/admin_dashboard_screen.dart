// ignore_for_file: unused_import, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:broker_app/features/admin/models/admin_analytics.dart';
import 'package:broker_app/features/admin/models/admin_dashboard_stats.dart';
import 'package:broker_app/features/admin/providers/admin_dashboard_provider.dart';
import 'package:broker_app/features/admin/screens/moderation_logs_screen.dart';
import 'package:broker_app/features/admin/screens/user_management_screen.dart';
import 'package:broker_app/features/admin/screens/admin_property_list_screen.dart';
import 'package:broker_app/features/admin/screens/admin_lodging_list_screen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  static const _analyticsRangeDays = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminDashboardStatsProvider);
    final analyticsAsync = ref.watch(
      adminDashboardAnalyticsProvider(_analyticsRangeDays),
    );

    Future<void> refresh() async {
      await Future.wait([
        ref.refresh(adminDashboardStatsProvider.future),
        ref.refresh(
          adminDashboardAnalyticsProvider(_analyticsRangeDays).future,
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Manage Users',
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UserManagementScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Moderation logs',
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ModerationLogsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: statsAsync.isLoading ? null : () => refresh(),
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) => RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(title: 'Users'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const UserManagementScreen(),
                        ),
                      );
                    },
                    child: const Text('Manage'),
                  ),
                ],
              ),
              _StatsGrid(
                cards: [
                  _StatCard(label: 'Total Users', value: stats.users.total),
                  _StatCard(label: 'New Today', value: stats.users.newToday),
                  _StatCard(label: 'Brokers', value: stats.users.brokers),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(title: 'Properties'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminPropertyListScreen(),
                        ),
                      );
                    },
                    child: const Text('Manage'),
                  ),
                ],
              ),
              _StatsGrid(
                cards: [
                  _StatCard(label: 'Total', value: stats.properties.total),
                  _StatCard(label: 'Pending', value: stats.properties.pending),
                  _StatCard(
                    label: 'Approved',
                    value: stats.properties.approved,
                  ),
                  _StatCard(
                    label: 'New Today',
                    value: stats.properties.newToday,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(title: 'Lodgings'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminLodgingListScreen(),
                        ),
                      );
                    },
                    child: const Text('Manage'),
                  ),
                ],
              ),
              _StatsGrid(
                cards: [
                  _StatCard(label: 'Total', value: stats.lodgings.total),
                  _StatCard(label: 'Pending', value: stats.lodgings.pending),
                  _StatCard(label: 'Approved', value: stats.lodgings.approved),
                  _StatCard(label: 'New Today', value: stats.lodgings.newToday),
                ],
              ),
              const SizedBox(height: 24),
              _AnalyticsSection(
                rangeDays: _analyticsRangeDays,
                analyticsAsync: analyticsAsync,
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            _ErrorState(message: err.toString(), onRetry: refresh),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.cards});

  final List<_StatCard> cards;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (_, index) => cards[index],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value.toString(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Failed to load admin stats',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsSection extends StatelessWidget {
  const _AnalyticsSection({
    required this.rangeDays,
    required this.analyticsAsync,
  });

  final int rangeDays;
  final AsyncValue<AdminAnalytics> analyticsAsync;

  @override
  Widget build(BuildContext context) {
    return analyticsAsync.when(
      data: (analytics) {
        final usersLatest = _latestCount(analytics.users.dailyNew);
        final propertyApprovalsLatest = _latestCount(
          analytics.properties.dailyApproved,
        );
        final lodgingApprovalsLatest = _latestCount(
          analytics.lodgings.dailyApproved,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: 'Analytics ($rangeDays days)'),
            const SizedBox(height: 12),
            _StatsGrid(
              cards: [
                _StatCard(label: 'New Users (last day)', value: usersLatest),
                _StatCard(
                  label: 'Property approvals (last day)',
                  value: propertyApprovalsLatest,
                ),
                _StatCard(
                  label: 'Lodging approvals (last day)',
                  value: lodgingApprovalsLatest,
                ),
                _StatCard(
                  label: 'Pending Properties',
                  value: analytics.properties.pending,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _TrendCard(
              title: 'User signups trend',
              points: analytics.users.dailyNew,
            ),
            const SizedBox(height: 12),
            _TrendCard(
              title: 'Property approvals trend',
              points: analytics.properties.dailyApproved,
            ),
            const SizedBox(height: 12),
            _TrendCard(
              title: 'Lodging approvals trend',
              points: analytics.lodgings.dailyApproved,
            ),
            const SizedBox(height: 16),
            _ModerationTopActions(actions: analytics.moderation.topActions),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ModerationLogsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.list_alt),
                label: const Text('View moderation logs'),
              ),
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Failed to load analytics: ${err.toString()}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }

  static int _latestCount(List<TimeSeriesPoint> points) {
    if (points.isEmpty) return 0;
    return points.last.count;
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.title, required this.points});

  final String title;
  final List<TimeSeriesPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = points.reversed.take(5).toList();
    final formatter = DateFormat('MMM d');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (recent.isEmpty)
            Text('No data available', style: theme.textTheme.bodyMedium)
          else
            ...recent.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatter.format(DateTime.parse(point.date))),
                    Text(
                      point.count.toString(),
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ModerationTopActions extends StatelessWidget {
  const _ModerationTopActions({required this.actions});

  final List<TopModerationAction> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top moderation actions', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          if (actions.isEmpty)
            Text(
              'No moderation activity recorded in this window.',
              style: theme.textTheme.bodyMedium,
            )
          else
            ...actions.map(
              (action) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(action.action.replaceAll('_', ' ')),
                    Text(
                      action.count.toString(),
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
