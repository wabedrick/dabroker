import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/core/widgets/skeleton_box.dart';
import 'package:broker_app/data/models/user.dart';
import 'package:broker_app/features/admin/screens/admin_dashboard_screen.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/auth/screens/login_screen.dart';
import 'package:broker_app/features/notifications/providers/notification_counters_provider.dart';
import 'package:broker_app/features/notifications/screens/notification_screen.dart';
import 'package:broker_app/features/properties/models/property_query_params.dart';
import 'package:broker_app/features/properties/providers/property_list_provider.dart';
import 'package:broker_app/features/properties/screens/add_property_screen.dart';
import 'package:broker_app/features/properties/screens/property_detail_screen.dart';
import 'package:broker_app/features/properties/widgets/property_card.dart';
import 'package:broker_app/features/properties/widgets/property_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(
      () => ref.read(propertyListProvider.notifier).initialize(),
    );
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(notificationCountersProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertyListProvider);
    final authState = ref.watch(authStateProvider);
    _syncSearchField(state.params.search ?? '');
    final actions = <Widget>[
      if (authState.user?.preferredRole == 'admin')
        const _AdminDashboardAction(),
      const _NotificationAction(),
      const _UserProfileButton(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Discover Homes'), actions: actions),
      body: Column(
        children: [
          _SearchBar(
            controller: _searchController,
            onSubmitted: (value) => _applyFilters(
              state.params.copyWith(
                search: value.trim().isEmpty ? null : value.trim(),
              ),
            ),
            onClear: () => _applyFilters(state.params.copyWith(search: null)),
          ),
          _FilterChips(
            selectedType: state.params.category,
            onFilterSelected: (category) =>
                _applyFilters(state.params.copyWith(category: category)),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  ref
                      .read(propertyListProvider.notifier)
                      .refresh(params: state.params),
                  ref.read(notificationCountersProvider.notifier).refresh(),
                ]);
              },
              child: _PropertyFeed(state: state, controller: _scrollController),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(context, authState.user),
    );
  }

  Widget? _buildFab(BuildContext context, User? user) {
    if (user == null) return null;
    // Check permissions if available, or fallback to roles
    final canCreate =
        user.permissions.contains('properties.create') ||
        user.roles.contains('seller') ||
        user.roles.contains('owner') ||
        user.roles.contains('admin') ||
        user.roles.contains('super_admin');

    if (!canCreate) return null;

    return FloatingActionButton.extended(
      heroTag: 'add_property_fab',
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AddPropertyScreen()));
      },
      label: const Text('List Property'),
      icon: const Icon(Icons.add),
    );
  }

  void _syncSearchField(String value) {
    if (_searchController.text == value) return;
    _searchController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = 200.0;
    final position = _scrollController.position;
    if (position.maxScrollExtent - position.pixels <= threshold) {
      ref.read(propertyListProvider.notifier).loadMore();
    }
  }

  void _applyFilters(PropertyQueryParams params) {
    ref.read(propertyListProvider.notifier).updateFilters(params);
  }
}

class _PropertyFeed extends StatelessWidget {
  const _PropertyFeed({required this.state, required this.controller});

  final PropertyListState state;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    if (state.isRefreshing && state.items.isEmpty) {
      return const _PropertyFeedSkeleton();
    }

    if (state.error != null && state.items.isEmpty) {
      return _ErrorView(error: state.error!);
    }

    if (!state.isRefreshing && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_work_outlined,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).disabledColor,
              ),
            ),
            if (state.params.category != null) ...[
              const SizedBox(height: 8),
              Text(
                'Try changing your filters',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ],
        ),
      );
    }

    final showLoader = state.isLoading;
    final showInlineError = state.error != null && state.items.isNotEmpty;
    final extraCount = (showLoader ? 1 : 0) + (showInlineError ? 1 : 0);

    return ListView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: state.items.length + extraCount,
      itemBuilder: (context, index) {
        if (index >= state.items.length) {
          final extraIndex = index - state.items.length;
          if (showInlineError && extraIndex == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _InlineError(message: state.error!),
            );
          }

          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final property = state.items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PropertyCard(
            property: property,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PropertyDetailScreen(
                    propertyId: property.id,
                    initialProperty: property,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (_, value, __) {
          return TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: 'Search by city, address, or keyword',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: value.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        controller.clear();
                        onClear();
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.selectedType,
    required this.onFilterSelected,
  });

  final String? selectedType;
  final ValueChanged<String?> onFilterSelected;

  static const _filters = [
    (label: 'All', value: null),
    (label: 'Rent', value: 'rent'),
    (label: 'Sale', value: 'sale'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = selectedType == filter.value;
          return ChoiceChip(
            label: Text(filter.label),
            selected: isSelected,
            onSelected: (selected) {
              if (filter.value == null) {
                onFilterSelected(null);
                return;
              }
              onFilterSelected(selected && !isSelected ? filter.value : null);
            },
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: _filters.length,
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha((0.08 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationAction extends ConsumerWidget {
  const _NotificationAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationCountersProvider);

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () async {
              final notifier = ref.read(notificationCountersProvider.notifier);
              await notifier.refresh();
              if (context.mounted) {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                );
                await notifier.refresh();
              }
            },
          ),
          Positioned(right: 8, top: 6, child: _NotificationBadge(state: state)),
        ],
      ),
    );
  }
}

class _AdminDashboardAction extends StatelessWidget {
  const _AdminDashboardAction();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Admin dashboard',
      icon: const Icon(Icons.dashboard_customize_outlined),
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
      },
    );
  }
}

class _UserProfileButton extends ConsumerWidget {
  const _UserProfileButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    if (user == null) return const SizedBox.shrink();

    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      tooltip: 'Account',
      icon: CircleAvatar(
        radius: 16,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : '?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onSelected: (value) async {
        if (value == 'logout') {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );

          if (confirmed == true) {
            if (context.mounted) {
              await ref.read(authStateProvider.notifier).logout();
              if (!context.mounted) return;

              final error = ref.read(authStateProvider).error;
              if (error != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error)));
                return;
              }

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            }
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red, size: 20),
              SizedBox(width: 12),
              Text('Logout', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge({required this.state});

  final NotificationCountersState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.counters == null) {
      return const SkeletonBox(width: 18, height: 18, borderRadius: 9);
    }

    final counters = state.counters;
    if (counters == null) return const SizedBox.shrink();

    final inquiryUnread =
        counters.unreadInquiries + counters.buyerUnreadInquiries;
    final favoriteUnread = counters.unreadFavorites;
    final pendingReservations = counters.pendingReservations;
    final confirmedBookings = counters.confirmedBookings;
    
    final totalUnread = inquiryUnread + favoriteUnread + pendingReservations + confirmedBookings;

    if (totalUnread <= 0) {
      return const SizedBox.shrink();
    }

    final label = totalUnread > 9 ? '9+' : '$totalUnread';
    final tooltip =
        'Buyer inquiries: ${counters.buyerUnreadInquiries}\n'
        'General inquiries: ${counters.unreadInquiries}\n'
        'Favorite updates: ${counters.unreadFavorites}\n'
        'Pending reservations: ${counters.pendingReservations}\n'
        'Confirmed bookings: ${counters.confirmedBookings}';

    return Semantics(
      label: 'Unread notifications. $tooltip',
      child: Tooltip(
        message: tooltip,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (inquiryUnread > 0) ...[
                const SizedBox(width: 4),
                _NotificationBadgeDot(color: AppColors.primaryBlue, label: 'I'),
              ],
              if (favoriteUnread > 0) ...[
                const SizedBox(width: 2),
                _NotificationBadgeDot(color: AppColors.warning, label: 'F'),
              ],
              if (pendingReservations > 0) ...[
                const SizedBox(width: 2),
                _NotificationBadgeDot(color: Colors.orange, label: 'R'),
              ],
              if (confirmedBookings > 0) ...[
                const SizedBox(width: 2),
                _NotificationBadgeDot(color: Colors.green, label: 'B'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationBadgeDot extends StatelessWidget {
  const _NotificationBadgeDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _PropertyFeedSkeleton extends StatelessWidget {
  const _PropertyFeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __) => const PropertyCardSkeleton(),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: 4,
    );
  }
}

class _ErrorView extends ConsumerWidget {
  const _ErrorView({required this.error});

  final String error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(propertyListProvider.notifier)
                  .refresh(params: ref.read(propertyListProvider).params),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
