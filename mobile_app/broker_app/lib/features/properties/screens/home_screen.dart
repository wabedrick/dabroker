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

    final header = _HomeHeaderModel.from(state: state);
    final actions = <Widget>[
      if (authState.user?.preferredRole == 'admin')
        const _AdminDashboardAction(),
      const _NotificationAction(),
      const _UserProfileButton(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 76,
        titleSpacing: 16,
        title: _HomeHeaderTitle(model: header),
        actions: actions,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
      body: Column(
        children: [
          _HeaderPanel(
            state: state,
            searchController: _searchController,
            onApplyFilters: _applyFilters,
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

class _HeaderPanel extends StatelessWidget {
  const _HeaderPanel({
    required this.state,
    required this.searchController,
    required this.onApplyFilters,
  });

  final PropertyListState state;
  final TextEditingController searchController;
  final ValueChanged<PropertyQueryParams> onApplyFilters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surface = colorScheme.surface;
    final outline = colorScheme.outlineVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchBar(
              controller: searchController,
              onSubmitted: (value) {
                onApplyFilters(
                  state.params.copyWith(
                    search: value.trim().isEmpty ? null : value.trim(),
                  ),
                );
              },
              onClear: () {
                onApplyFilters(state.params.copyWith(search: null));
              },
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 10),
            Text(
              'Category',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            _FilterChips(
              selectedType: state.params.category,
              onFilterSelected: (category) {
                onApplyFilters(state.params.copyWith(category: category));
              },
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeaderModel {
  const _HomeHeaderModel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  static _HomeHeaderModel from({required PropertyListState state}) {
    final category = state.params.category;
    final filterLabel = switch (category) {
      'rent' => 'For rent',
      'sale' => 'For sale',
      _ => 'All listings',
    };

    final countLabel = state.items.length == 1
        ? 'Showing 1'
        : 'Showing ${state.items.length}';

    final search = state.params.search?.trim();
    final hasSearch = search != null && search.isNotEmpty;
    final statusLabel = state.isRefreshing
        ? 'Updating'
        : state.isLoading
        ? 'Loading'
        : null;

    final parts = <String>[filterLabel, countLabel];
    if (hasSearch) parts.add('Search');
    if (statusLabel != null) parts.add(statusLabel);

    return _HomeHeaderModel(title: 'Properties', subtitle: parts.join(' • '));
  }
}

class _HomeHeaderTitle extends StatelessWidget {
  const _HomeHeaderTitle({required this.model});

  final _HomeHeaderModel model;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(model.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(
          model.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: subtitleStyle,
        ),
      ],
    );
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
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
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
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 8),
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
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
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final String? selectedType;
  final ValueChanged<String?> onFilterSelected;
  final EdgeInsets padding;

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
        physics: const BouncingScrollPhysics(),
        padding: padding,
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
    final tooltip = _NotificationBadge.buildTooltip(state);

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            tooltip: tooltip,
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
          Positioned(
            right: 8,
            top: 6,
            child: IgnorePointer(child: _NotificationBadge(state: state)),
          ),
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

  static String _initialsFromName(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    final first = parts.first.substring(0, 1).toUpperCase();
    final last = parts.last.substring(0, 1).toUpperCase();
    return '$first$last';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    if (user == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final initials = _initialsFromName(user.name);

    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      tooltip: 'Account',
      color: colorScheme.surface,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      icon: Semantics(
        label: 'Account menu. ${user.name}',
        button: true,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          padding: const EdgeInsets.all(2),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              initials,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
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
                    foregroundColor: theme.colorScheme.error,
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 240),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      initials,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Text(
                          user.formattedRole,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: colorScheme.error, size: 20),
              SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
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

  static String? buildTooltip(NotificationCountersState state) {
    final counters = state.counters;
    if (counters == null) return 'Notifications';

    final inquiryUnread =
        counters.unreadInquiries + counters.buyerUnreadInquiries;
    final favoriteUnread = counters.unreadFavorites;
    final pendingReservations = counters.pendingReservations;
    final confirmedBookings = counters.confirmedBookings;

    final totalUnread =
        inquiryUnread +
        favoriteUnread +
        pendingReservations +
        confirmedBookings;

    if (totalUnread <= 0) return 'Notifications';

    return 'Unread notifications: $totalUnread\n'
        'Buyer inquiries: ${counters.buyerUnreadInquiries}\n'
        'General inquiries: ${counters.unreadInquiries}\n'
        'Favorite updates: ${counters.unreadFavorites}\n'
        'Pending reservations: ${counters.pendingReservations}\n'
        'Confirmed bookings: ${counters.confirmedBookings}';
  }

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

    final totalUnread =
        inquiryUnread +
        favoriteUnread +
        pendingReservations +
        confirmedBookings;

    if (totalUnread <= 0) {
      return const SizedBox.shrink();
    }

    final label = totalUnread > 9 ? '9+' : '$totalUnread';

    return Semantics(
      label: 'Unread notifications: $label',
      child: Container(
        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
