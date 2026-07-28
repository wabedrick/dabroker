import 'dart:ui';
import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/core/utils/money_format.dart';
import 'package:flutter/services.dart';
import 'package:broker_app/core/widgets/shimmer_loading.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/lodgings/providers/lodging_list_provider.dart';
import 'package:broker_app/features/lodgings/screens/add_lodging_screen.dart';
import 'package:broker_app/features/lodgings/screens/lodging_detail_screen.dart';
import 'package:broker_app/features/lodgings/screens/lodging_map_screen.dart';
import 'package:broker_app/features/lodgings/widgets/location_search_dialog.dart';
import 'package:broker_app/features/lodgings/widgets/lodging_image_carousel.dart';
import 'package:broker_app/core/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Maps a lodging type key to a user-friendly plural label.
String _formatTypeLabel(String type) {
  switch (type.toLowerCase()) {
    case 'hotel':
    case 'hotels': return 'Hotels';
    case 'hostel':
    case 'hostels': return 'Hostels';
    case 'resort':
    case 'resorts': return 'Resorts';
    case 'lodge':
    case 'lodges': return 'Lodges';
    case 'apartment':
    case 'apartments': return 'Apartments';
    case 'villa':
    case 'villas': return 'Villas';
    case 'guest_house':
    case 'guest_houses':
    case 'guesthouse': return 'Guest Houses';
    case 'campsite':
    case 'campsites': return 'Campsites';
    case 'bnb': return 'B&Bs';
    default: 
      final clean = type.replaceAll('_', ' ').toLowerCase();
      if (clean.isEmpty) return type;
      final capitalized = clean.split(' ').map((word) {
        if (word.isEmpty) return '';
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }).join(' ');
      return capitalized.endsWith('s') ? capitalized : '${capitalized}s';
  }
}

/// Maps a lodging type key to a singular user-friendly label (for empty states).
String _formatTypeLabelSingular(String type) {
  final plural = _formatTypeLabel(type);
  if (plural == 'B&Bs') return 'B&B';
  if (plural.endsWith('Houses')) return plural.substring(0, plural.length - 1);
  if (plural.endsWith('es') && plural.length > 5) {
    if (plural == 'Lodges') return 'Lodge';
    if (plural == 'Campsites') return 'Campsite';
  }
  if (plural.endsWith('s')) return plural.substring(0, plural.length - 1);
  return plural;
}

class LodgingListScreen extends ConsumerStatefulWidget {
  const LodgingListScreen({super.key});

  @override
  ConsumerState<LodgingListScreen> createState() => _LodgingListScreenState();
}

class _LodgingListScreenState extends ConsumerState<LodgingListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(lodgingListProvider.notifier).load());
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = 200.0;
    final position = _scrollController.position;
    if (position.maxScrollExtent - position.pixels <= threshold) {
      ref.read(lodgingListProvider.notifier).loadMore();
    }
  }

  Future<void> _handleNearMe() async {
    final notifier = ref.read(lodgingListProvider.notifier);
    final state = ref.read(lodgingListProvider);

    // If already filtering by location, clear it
    if (state.latitude != null) {
      notifier.clearLocationFilter();
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
      notifier.updateLocationFilter(
        position.latitude,
        position.longitude,
        50, // 50km radius
      );
    }
  }

  void _showLocationSearch() {
    // Capture the parent's ScaffoldMessenger BEFORE opening dialog,
    // so fallback snackbar still shows after the dialog is popped.
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => LocationSearchDialog(
        onSearch: ({lat, lng, query}) {
          if (lat != null && lng != null) {
            ref
                .read(lodgingListProvider.notifier)
                .updateLocationFilter(lat, lng, 50);
          } else if (query != null) {
            ref.read(lodgingListProvider.notifier).updateSearchQuery(query);
          }
        },
        onFallbackMessage: (msg) {
          // Show snackbar on the parent scaffold, safe after dialog pop
          messenger.showSnackBar(
            SnackBar(
              content: Text(msg),
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(lodgingListProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    final state = ref.watch(lodgingListProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    final header = _LodgingsHeaderModel.from(state: state);
    final colorScheme = Theme.of(context).colorScheme;
    final hasMappableLodgings = state.items.any(
      (l) => l.latitude != null && l.longitude != null,
    );

    final canCreate =
        user != null &&
        (user.roles.contains('host') ||
            user.roles.contains('seller') ||
            user.roles.contains('admin') ||
            user.roles.contains('super_admin'));

    final hasFilter = state.searchQuery != null ||
        state.latitude != null ||
        state.longitude != null ||
        state.typeFilter != null;

    return PopScope(
      // When a filter is active, back clears it instead of navigating away
      canPop: !hasFilter,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && hasFilter) {
          ref.read(lodgingListProvider.notifier).clearLocationFilter();
          ref.read(lodgingListProvider.notifier).updateSearchQuery('');
          ref.read(lodgingListProvider.notifier).updateTypeFilter(null);
        }
      },
      child: Scaffold(
      floatingActionButton: hasMappableLodgings
          ? FloatingActionButton.extended(
              heroTag: 'lodging_map_fab',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LodgingMapScreen()),
                );
              },
              label: const Text('Map'),
              icon: const Icon(Icons.map),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        onRefresh: () => ref.read(lodgingListProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              toolbarHeight: 64,
              floating: true,
              pinned: true,
              titleSpacing: 16,
              title: _LodgingsHeaderTitle(
                model: header,
              ),
              actions: [
                Consumer(
                  builder: (context, ref, child) {
                    final locState = ref.watch(locationProvider);
                    final isLocating = locState.isLoading;
                    return IconButton(
                      icon: isLocating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              state.latitude != null
                                  ? Icons.location_on
                                  : Icons.location_on_outlined,
                              color: state.latitude != null ? colorScheme.primary : null,
                            ),
                      tooltip: state.latitude != null ? 'Clear location' : 'Near me',
                      onPressed: isLocating ? null : _handleNearMe,
                    );
                  },
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.sort,
                    color: state.sortBy != null ? colorScheme.primary : null,
                  ),
                  tooltip: 'Sort by',
                  onSelected: (value) {
                    ref
                        .read(lodgingListProvider.notifier)
                        .updateSortBy(value == 'default' ? null : value);
                  },
                  itemBuilder: (context) {
                    final hasLocation = state.latitude != null;
                    return [
                      const PopupMenuItem(
                        value: 'default',
                        child: Text('Newest (Default)'),
                      ),
                      PopupMenuItem(
                        value: 'nearest',
                        enabled: hasLocation,
                        child: Text(
                          'Nearest',
                          style: TextStyle(
                            color: hasLocation
                                ? null
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'price_asc',
                        child: Text('Price: Low to High'),
                      ),
                      const PopupMenuItem(
                        value: 'price_desc',
                        child: Text('Price: High to Low'),
                      ),
                    ];
                  },
                ),
                if (canCreate)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddLodgingScreen()),
                      );
                    },
                  ),
                const SizedBox(width: 8),
              ],
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(200),
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: const SizedBox.expand(),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(140),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LodgingHeaderPanel(state: state, onTapSearch: _showLocationSearch),
                    const SizedBox(height: 8),
                    _LodgingFilterChips(
                      selectedType: state.typeFilter,
                      onFilterSelected: (type) {
                        ref.read(lodgingListProvider.notifier).updateTypeFilter(type);
                      },
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
            if (state.latitude != null || state.north != null)
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  color: colorScheme.primaryContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.my_location,
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          () {
                            final label = state.typeFilter != null
                                ? _formatTypeLabel(state.typeFilter!)
                                : 'Lodgings';
                            return state.latitude != null
                                ? 'Showing $label near selected location'
                                : 'Showing $label in selected area';
                          }(),
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(lodgingListProvider.notifier)
                            .clearLocationFilter(),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        tooltip: 'Clear location filter',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      ),
                    ],
                  ),
                ),
              ),
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: _LodgingList(state: state),
            ),
          ],
        ),
      ),
      ), // end Scaffold
    ); // end PopScope
  }
}

class _LodgingsHeaderModel {
  const _LodgingsHeaderModel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  static _LodgingsHeaderModel from({required LodgingListState state}) {
    final parts = <String>[];

    if (state.isLoading && state.items.isEmpty) {
      parts.add('Loading…');
    } else {
      final total = state.totalResults;
      if (total != null) {
        parts.add('${state.items.length} of $total results');
      } else {
        parts.add('${state.items.length} results');
      }
    }

    if (state.typeFilter != null && state.typeFilter!.trim().isNotEmpty) {
      parts.add(_formatTypeLabel(state.typeFilter!));
    }

    if (state.searchQuery != null && state.searchQuery!.trim().isNotEmpty) {
      parts.add('“${state.searchQuery!.trim()}”');
    } else if (state.latitude != null) {
      parts.add('Near selected location');
    }

    if (state.sortBy != null) {
      parts.add(_formatSortLabel(state.sortBy!));
    }

    return _LodgingsHeaderModel(title: 'Lodgings', subtitle: parts.join(' • '));
  }

  static String _formatSortLabel(String sortBy) {
    switch (sortBy) {
      case 'nearest':
        return 'Nearest';
      case 'price_asc':
        return 'Price ↑';
      case 'price_desc':
        return 'Price ↓';
      default:
        return 'Sorted';
    }
  }
}

class _LodgingsHeaderTitle extends StatelessWidget {
  const _LodgingsHeaderTitle({required this.model});

  final _LodgingsHeaderModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          model.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: 'DM Serif Display',
            fontSize: 28,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          model.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _LodgingHeaderPanel extends StatelessWidget {
  const _LodgingHeaderPanel({required this.state, required this.onTapSearch});

  final LodgingListState state;
  final VoidCallback onTapSearch;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surface = colorScheme.surface;
    final outline = colorScheme.outlineVariant;

    final label = () {
      final q = state.searchQuery?.trim();
      if (q != null && q.isNotEmpty) return 'Search: "$q"';
      if (state.latitude != null) {
        return 'Showing nearby lodgings';
      }
      return 'Search destinations or properties...';
    }();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: outline.withAlpha(100)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTapSearch,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(Icons.tune, size: 18, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LodgingFilterChips extends StatelessWidget {
  const _LodgingFilterChips({
    required this.selectedType,
    required this.onFilterSelected,
  });

  final String? selectedType;
  final ValueChanged<String?> onFilterSelected;

  static const _filters = [
    (label: 'All', value: null),
    (label: 'Hotel', value: 'hotel'),
    (label: 'Guest House', value: 'guest_house'),
    (label: 'Lodge', value: 'lodge'),
    (label: 'Apartment', value: 'apartment'),
    (label: 'Resort', value: 'resort'),
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
              HapticFeedback.selectionClick();
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

class _LodgingFeedSkeletonSliver extends StatelessWidget {
  const _LodgingFeedSkeletonSliver();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList.separated(
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return const _LodgingCardSkeleton();
        },
      ),
    );
  }
}

class _LodgingCardSkeleton extends StatelessWidget {
  const _LodgingCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ShimmerLoading(
        width: double.infinity,
        height: double.infinity,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _LodgingList extends ConsumerWidget {
  const _LodgingList({required this.state});

  final LodgingListState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading && state.items.isEmpty) {
      return const _LodgingFeedSkeletonSliver();
    }

    if (state.error != null && state.items.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text('Error: ${state.error}')),
      );
    }

    if (state.items.isEmpty) {
      if (state.latitude != null) {
        final label = state.typeFilter != null 
            ? _formatTypeLabelSingular(state.typeFilter!)
            : 'Lodging';
        
        return SliverFillRemaining(
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
                  'No $label near you',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting the search radius\nor viewing all ${label.toLowerCase()}s.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(lodgingListProvider.notifier).clearLocationFilter();
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
            ).animate().fade(duration: 400.ms).scaleXY(begin: 0.9, end: 1, curve: Curves.easeOutBack),
          ),
        );
      }

      final label = state.typeFilter != null 
          ? _formatTypeLabelSingular(state.typeFilter!)
          : 'Lodging';

      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hotel_outlined,
                size: 64,
                color: Theme.of(context).disabledColor,
              ),
              const SizedBox(height: 16),
              Text(
                'No $label found',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        ),
      );
    }

    final showFooter = state.isLoading || state.hasMore;
    final itemCount = state.items.length + (showFooter ? 1 : 0);

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList.separated(
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            if (state.isLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            // Has more but not currently loading; keep space for the FAB.
            return const SizedBox(height: 72);
          }

          final lodging = state.items[index];
          return _LodgingCard(lodging: lodging)
              .animate(delay: (index * 50).ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
        },
      ),
    );
  }
}

class _LodgingCard extends StatelessWidget {
  const _LodgingCard({required this.lodging});

  final Lodging lodging;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final images = lodging.media?.map((e) {
          final url = e.previewUrl ?? e.url ?? '';
          return ImageHelper.fixUrl(url);
        }).toList() ?? [];

    final priceText = lodging.pricePerNight != null
        ? '${formatMoney(lodging.pricePerNight, lodging.currency, fractionDigits: 0)} / night'
        : 'Price on request';

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      shadowColor: Colors.black.withAlpha(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.outlineVariant.withAlpha(50)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LodgingDetailScreen(
                lodgingId: lodging.id,
                initialLodging: lodging,
              ),
            ),
          );
        },
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'lodging_image_${lodging.id}',
                child: LodgingImageCarousel(images: images, lodgingId: lodging.id),
              ),
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(100),
                        Colors.black.withAlpha(200),
                      ],
                      stops: const [0.4, 0.75, 1.0],
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                child: Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Hero(
                              tag: 'lodging_title_${lodging.id}',
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  lodging.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      const Shadow(color: Colors.black54, blurRadius: 4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withAlpha(230),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              priceText,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.white70),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${lodging.city}, ${lodging.country}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          if (lodging.averageRating > 0) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              lodging.averageRating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (lodging.type != null)
                IgnorePointer(
                  child: Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(150),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Text(
                        _formatTypeLabel(lodging.type!),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

