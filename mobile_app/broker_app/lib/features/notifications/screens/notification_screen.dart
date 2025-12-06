import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/core/widgets/skeleton_box.dart';
import 'package:broker_app/data/models/booking.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/bookings/screens/booking_detail_screen.dart';
import 'package:broker_app/features/notifications/models/notification_item.dart';
import 'package:broker_app/features/notifications/providers/notification_counters_provider.dart';
import 'package:broker_app/features/notifications/providers/notification_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<NotificationCategory> _categories;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).user;
    final isHost = user?.roles.contains('host') ?? false;
    final isSeller = user?.roles.contains('seller') ?? false;
    final isOwner = isHost || isSeller;

    _categories = [
      if (isOwner) ...[
        NotificationCategory.inquiries,
        NotificationCategory.favorites,
        NotificationCategory.reservations,
      ],
      NotificationCategory.bookings,
    ];

    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    Future.microtask(() async {
      if (_categories.isNotEmpty) {
        final notifier = ref.read(notificationListProvider.notifier);
        await notifier.load(_categories.first);
      }
      await ref.read(notificationCountersProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countersState = ref.watch(notificationCountersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories
              .map((category) => Tab(text: category.label))
              .toList(growable: false),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshCurrentTab(force: true),
          ),
        ],
      ),
      body: Column(
        children: [
          _SummaryChips(state: countersState),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories
                  .map((category) => _NotificationListView(category: category))
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshCurrentTab({bool force = false}) async {
    final category = _categories[_tabController.index];
    await Future.wait([
      ref.read(notificationListProvider.notifier).load(category, force: force),
      ref.read(notificationCountersProvider.notifier).refresh(),
    ]);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    final category = _categories[_tabController.index];
    ref.read(notificationListProvider.notifier).load(category);
  }
}

class _SummaryChips extends StatelessWidget {
  const _SummaryChips({required this.state});

  final NotificationCountersState state;

  @override
  Widget build(BuildContext context) {
    final counters = state.counters;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SummaryChip(
            label: 'Buyer',
            value: counters?.buyerUnreadInquiries ?? 0,
            color: AppColors.primaryBlue,
          ),
          _SummaryChip(
            label: 'General',
            value: counters?.unreadInquiries ?? 0,
            color: AppColors.warning,
          ),
          _SummaryChip(
            label: 'Favorites',
            value: counters?.unreadFavorites ?? 0,
            color: AppColors.error,
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationListView extends ConsumerWidget {
  const _NotificationListView({required this.category});

  final NotificationCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final map = ref.watch(notificationListProvider);
    final asyncValue = map[category];

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(notificationListProvider.notifier)
            .load(category, force: true);
        await ref.read(notificationCountersProvider.notifier).refresh();
      },
      child: Builder(
        builder: (context) {
          if (asyncValue == null ||
              asyncValue is AsyncLoading<List<NotificationItem>>) {
            return const _NotificationSkeletonList();
          }

          return asyncValue.when(
            data: (items) {
              if (items.isEmpty) {
                return _EmptyState(category: category);
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (_, index) =>
                    _NotificationTile(item: items[index]),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: items.length,
              );
            },
            error: (error, _) =>
                _ErrorState(message: error.toString(), category: category),
            loading: () => const _NotificationSkeletonList(),
          );
        },
      ),
    );
  }
}

class _NotificationSkeletonList extends StatelessWidget {
  const _NotificationSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, __) => const _NotificationSkeletonTile(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: 6,
    );
  }
}

class _NotificationSkeletonTile extends StatelessWidget {
  const _NotificationSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SkeletonBox(width: 48, height: 48, borderRadius: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SkeletonBox(width: 160, height: 16),
              SizedBox(height: 8),
              SkeletonBox(width: double.infinity, height: 14),
              SizedBox(height: 6),
              SkeletonBox(width: 120, height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = DateFormat('MMM d, h:mm a');
    final accent = switch (item.category) {
      NotificationCategory.favorites => AppColors.error,
      NotificationCategory.bookings ||
      NotificationCategory.reservations => Colors.green,
      _ => AppColors.primaryBlue,
    };

    final isPendingReservation =
        item.category == NotificationCategory.reservations &&
        item.metadata?['status'] == 'pending';

    return GestureDetector(
      onTap: () {
        if ((item.category == NotificationCategory.bookings ||
                item.category == NotificationCategory.reservations) &&
            item.metadata != null) {
          try {
            final booking = Booking.fromJson(item.metadata!);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingDetailScreen(
                  booking: booking,
                  isHost: item.category == NotificationCategory.reservations,
                ),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not open booking details: $e')),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.isRead
              ? Theme.of(context).cardColor
              : AppColors.primaryBlue.withAlpha((0.05 * 255).round()),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withAlpha((0.15 * 255).round())),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withAlpha((0.15 * 255).round()),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    switch (item.category) {
                      NotificationCategory.favorites => Icons.favorite_outline,
                      NotificationCategory.bookings => Icons.calendar_today,
                      NotificationCategory.reservations =>
                        Icons.bedroom_parent_outlined,
                      _ => Icons.chat_bubble_outline,
                    },
                    color: accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            formatter.format(item.createdAt),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.body,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (item.relatedPropertyId != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Property #${item.relatedPropertyId}',
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(color: accent),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (isPendingReservation) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        try {
                          final bookingId =
                              item.metadata?['public_id']?.toString() ??
                              item.id;
                          await ref
                              .read(notificationListProvider.notifier)
                              .rejectBooking(bookingId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Booking rejected')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final bookingId =
                              item.metadata?['public_id']?.toString() ??
                              item.id;
                          await ref
                              .read(notificationListProvider.notifier)
                              .approveBooking(bookingId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Booking approved')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Approve'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.category});

  final NotificationCategory category;

  @override
  Widget build(BuildContext context) {
    final (icon, message) = switch (category) {
      NotificationCategory.favorites => (
        Icons.favorite_border,
        'No favorite updates yet',
      ),
      NotificationCategory.bookings => (
        Icons.calendar_today_outlined,
        'No trips booked yet',
      ),
      NotificationCategory.reservations => (
        Icons.bedroom_parent_outlined,
        'No reservations received yet',
      ),
      NotificationCategory.inquiries => (
        Icons.mark_chat_unread_outlined,
        'No inquiries yet',
      ),
    };

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Icon(icon, size: 64, color: AppColors.textSecondary),
        const SizedBox(height: 16),
        Text(
          message,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Keep exploring properties and conversations. Updates will show up here.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ErrorState extends ConsumerWidget {
  const _ErrorState({required this.message, required this.category});

  final String message;
  final NotificationCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const Icon(Icons.error_outline, size: 64, color: AppColors.error),
        const SizedBox(height: 16),
        Text(
          'Unable to load ${category.label.toLowerCase()}',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            ref
                .read(notificationListProvider.notifier)
                .load(category, force: true);
          },
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
