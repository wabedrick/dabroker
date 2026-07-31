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
import 'package:broker_app/core/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      Consumer(
        builder: (context, ref, child) {
          final locState = ref.watch(locationProvider);
          final isLocating = locState.isLoading;
          final isLocationSet = state.params.latitude != null;
          return IconButton(
            icon: isLocating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    isLocationSet
                        ? Icons.location_on
                        : Icons.location_on_outlined,
                    color: isLocationSet ? Theme.of(context).colorScheme.primary : null,
                  ),
            tooltip: isLocationSet ? 'Clear location' : 'Near me',
            onPressed: isLocating ? null : _handleNearMe,
          );
        },
      ),
      if (authState.user?.preferredRole == 'admin')
        const _AdminDashboardAction(),
      const _NotificationAction(),
      const _UserProfileButton(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref
                .read(propertyListProvider.notifier)
                .refresh(params: state.params),
            ref.read(notificationCountersProvider.notifier).refresh(),
          ]);
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              toolbarHeight: 64,
              floating: true,
              pinned: true,
              titleSpacing: 16,
              title: _HomeHeaderTitle(
                model: header,
                userName: authState.user?.name.split(' ').first,
              ),
              actions: actions,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(240),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(170), // Increased height to prevent RenderFlex overflow
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _SearchBar(
                        controller: _searchController,
                        onSubmitted: (value) {
                          _applyFilters(
                            state.params.copyWith(
                              search: value.trim().isEmpty ? null : value.trim(),
                            ),
                          );
                        },
                        onClear: () {
                          _applyFilters(state.params.copyWith(search: null));
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _QuickFilterPill(
                            label: 'Filters',
                            icon: Icons.tune,
                            isSelected: state.params.amenities?.isNotEmpty ?? false,
                            onTap: () => _showFiltersBottomSheet(context, state.params),
                          ),
                          const SizedBox(width: 8),
                          _QuickFilterPill(
                            label: 'For rent',
                            icon: Icons.key,
                            isSelected: state.params.category == 'rent',
                            onTap: () => _applyFilters(state.params.copyWith(category: 'rent')),
                          ),
                          const SizedBox(width: 8),
                          _QuickFilterPill(
                            label: 'For sale',
                            icon: Icons.sell,
                            isSelected: state.params.category == 'sale',
                            onTap: () => _applyFilters(state.params.copyWith(category: 'sale')),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ],
                ),
              ),
            ),
            // The Property Feed
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: _PropertyFeedSliver(state: state),
            ),
          ],
        ),
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

  Future<void> _handleNearMe() async {
    final notifier = ref.read(propertyListProvider.notifier);
    final state = ref.read(propertyListProvider);

    // If already filtering by location, clear it
    if (state.params.latitude != null) {
      notifier.updateFilters(state.params.copyWith(
        latitude: null,
        longitude: null,
        radiusKm: null,
        sort: state.params.sort == 'nearest' ? null : state.params.sort,
      ));
      ref.read(locationProvider.notifier).clearLocation();
      return;
    }

    final locationStateNotifier = ref.read(locationProvider.notifier);
    final position = await locationStateNotifier.getCurrentLocation();
    
    if (!mounted) return;

    final locationState = ref.read(locationProvider);

    if (locationState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locationState.error!),
          action: (locationState.isServiceDisabled || locationState.isPermissionPermanentlyDenied)
              ? SnackBarAction(
                  label: 'Settings',
                  onPressed: () => locationStateNotifier.openSettings(),
                )
              : null,
        ),
      );
      return;
    }

    if (position != null) {
      notifier.updateFilters(state.params.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        radiusKm: 50, // 50km radius
        sort: 'nearest',
      ));
    }
  }

  void _applyFilters(PropertyQueryParams params) {
    ref.read(propertyListProvider.notifier).updateFilters(params);
  }

  void _showFiltersBottomSheet(BuildContext context, PropertyQueryParams currentParams) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return _FiltersBottomSheet(
          initialParams: currentParams,
          onApply: (params) {
            _applyFilters(params);
            Navigator.pop(context);
          },
        );
      },
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
      _ => 'Properties',
    };

    final countLabel = state.items.length == 1
        ? 'Showing 1'
        : 'Showing ${state.items.length}';

    final search = state.params.search?.trim();
    final hasSearch = search != null && search.isNotEmpty;
    final hasLocation = state.params.latitude != null;
    final statusLabel = state.isRefreshing
        ? 'Updating'
        : state.isLoading
        ? 'Loading'
        : null;

    final parts = <String>[filterLabel, countLabel];
    if (hasSearch) parts.add('Search');
    if (hasLocation) parts.add('Near selected location');
    if (statusLabel != null) parts.add(statusLabel);

    return _HomeHeaderModel(title: 'Properties', subtitle: parts.join(' • '));
  }
}

class _HomeHeaderTitle extends StatelessWidget {
  const _HomeHeaderTitle({required this.model, this.userName});

  final _HomeHeaderModel model;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleText = 'DaBroker';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 14,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                model.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PropertyFeedSliver extends ConsumerWidget {
  const _PropertyFeedSliver({required this.state});

  final PropertyListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isRefreshing && state.items.isEmpty) {
      return const _PropertyFeedSkeletonSliver();
    }

    if (state.error != null && state.items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _ErrorView(error: state.error!),
      );
    }

    if (!state.isRefreshing && state.items.isEmpty) {
      if (state.params.latitude != null) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary.withAlpha(150),
              ),
              const SizedBox(height: 16),
              Text(
                'No properties near you',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting the search radius\nor viewing all properties.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(propertyListProvider.notifier).updateFilters(
                        state.params.copyWith(
                          latitude: null,
                          longitude: null,
                          radiusKm: null,
                          sort: state.params.sort == 'nearest' ? null : state.params.sort,
                        ),
                      );
                  ref.read(locationProvider.notifier).clearLocation();
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear Location Filter'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          ).animate().fade(duration: 400.ms).scaleXY(begin: 0.9, end: 1, curve: Curves.easeOutBack),
        );
      }

      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
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
          ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        ),
      );
    }

    final showLoader = state.isLoading;
    final showInlineError = state.error != null && state.items.isNotEmpty;
    final extraCount = (showLoader ? 1 : 0) + (showInlineError ? 1 : 0);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
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
        ).animate(delay: (index * 50).ms).fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
      },
      childCount: state.items.length + extraCount,
    )));
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



class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isNetworkError = message.toLowerCase().contains('internet') || 
                           message.toLowerCase().contains('connection') ||
                           message.toLowerCase().contains('offline') ||
                           message.toLowerCase().contains('timeout');
                           
    final icon = isNetworkError ? Icons.wifi_off_rounded : Icons.error_outline_rounded;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.errorContainer),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
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
    final authState = ref.watch(authStateProvider);
    if (authState.user == null) return const SizedBox.shrink();

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

    if (user == null) {
      return IconButton(
        icon: const Icon(Icons.account_circle_outlined, size: 28),
        tooltip: 'Login',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      );
    }

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
                        user.email ?? user.phone ?? '',
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
              Icon(Icons.power_settings_new_rounded, color: colorScheme.error, size: 20),
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
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onError,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _PropertyFeedSkeletonSliver extends StatelessWidget {
  const _PropertyFeedSkeletonSliver();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: PropertyCardSkeleton(),
            );
          },
          childCount: 4,
        ),
      ),
    );
  }
}

class _QuickFilterPill extends StatelessWidget {
  const _QuickFilterPill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest.withAlpha((0.6 * 255).round());
    final foregroundColor = isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;
    
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: foregroundColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  const _ErrorView({required this.error});

  final String error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    
    final isNetworkError = error.toLowerCase().contains('internet') || 
                           error.toLowerCase().contains('connection') ||
                           error.toLowerCase().contains('offline');
    final isTimeoutError = error.toLowerCase().contains('timed out') || 
                           error.toLowerCase().contains('timeout');
    
    final String title;
    final IconData icon;
    
    if (isTimeoutError) {
      title = 'Slow Connection';
      icon = Icons.wifi_tethering_error_rounded;
    } else if (isNetworkError) {
      title = 'No Internet Connection';
      icon = Icons.wifi_off_rounded;
    } else {
      title = 'Oops! Something went wrong';
      icon = Icons.error_outline_rounded;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: colorScheme.error),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => ref
                  .read(propertyListProvider.notifier)
                  .refresh(params: ref.read(propertyListProvider).params),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersBottomSheet extends StatefulWidget {
  final PropertyQueryParams initialParams;
  final ValueChanged<PropertyQueryParams> onApply;

  const _FiltersBottomSheet({
    required this.initialParams,
    required this.onApply,
  });

  @override
  State<_FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<_FiltersBottomSheet> {
  late PropertyQueryParams _params;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  final List<String> _apartmentAmenities = [
    '24/7 Security', 'Serviced', 'Generator Backup', 'Elevator Available'
  ];

  final List<String> _rentalAmenities = [
    'Self-Contained', 'Separate Yaka Meter', 'Shared Outside Toilet', 'Gated Compound'
  ];

  @override
  void initState() {
    super.initState();
    _params = widget.initialParams;
    if (_params.priceMin != null) _minPriceController.text = _params.priceMin.toString();
    if (_params.priceMax != null) _maxPriceController.text = _params.priceMax.toString();
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _toggleAmenity(String amenity) {
    setState(() {
      final currentAmenities = _params.amenities?.toList() ?? [];
      if (currentAmenities.contains(amenity)) {
        currentAmenities.remove(amenity);
      } else {
        currentAmenities.add(amenity);
      }
      _params = _params.copyWith(amenities: currentAmenities.isEmpty ? null : currentAmenities);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allAmenities = [..._apartmentAmenities, ..._rentalAmenities];

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filters', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price Range', style: Theme.of(context).textTheme.titleMedium),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'UGX', label: Text('UGX')),
                    ButtonSegment(value: 'USD', label: Text('USD')),
                  ],
                  selected: {_params.currency ?? 'UGX'},
                  onSelectionChanged: (val) {
                    setState(() {
                      _params = _params.copyWith(currency: val.first);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    decoration: InputDecoration(labelText: 'Min Price', prefixText: (_params.currency ?? 'UGX') == 'UGX' ? 'USh ' : '\$ '),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        _params = _params.copyWith(priceMin: double.tryParse(val));
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    decoration: InputDecoration(labelText: 'Max Price', prefixText: (_params.currency ?? 'UGX') == 'UGX' ? 'USh ' : '\$ '),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        _params = _params.copyWith(priceMax: double.tryParse(val));
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Amenities', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allAmenities.map((amenity) {
                final isSelected = _params.amenities?.contains(amenity) ?? false;
                return FilterChip(
                  label: Text(amenity),
                  selected: isSelected,
                  onSelected: (_) => _toggleAmenity(amenity),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _params = _params.copyWith(amenities: null, priceMin: null, priceMax: null, currency: 'UGX');
                        _minPriceController.clear();
                        _maxPriceController.clear();
                      });
                    },
                    child: const Text('Clear Filters'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () => widget.onApply(_params),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
