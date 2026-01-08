import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/lodgings/providers/lodging_list_provider.dart';
import 'package:broker_app/features/lodgings/screens/add_lodging_screen.dart';
import 'package:broker_app/features/lodgings/screens/lodging_detail_screen.dart';
import 'package:broker_app/features/lodgings/screens/lodging_map_screen.dart';
import 'package:broker_app/features/lodgings/widgets/location_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class LodgingListScreen extends ConsumerStatefulWidget {
  const LodgingListScreen({super.key});

  @override
  ConsumerState<LodgingListScreen> createState() => _LodgingListScreenState();
}

class _LodgingListScreenState extends ConsumerState<LodgingListScreen> {
  bool _isLocating = false;
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
      return;
    }

    setState(() => _isLocating = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Location services are disabled.'),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => Geolocator.openLocationSettings(),
              ),
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Location permission is permanently denied.'),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => Geolocator.openAppSettings(),
              ),
            ),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      notifier.updateLocationFilter(
        position.latitude,
        position.longitude,
        50, // 50km radius
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _showLocationSearch() {
    showDialog(
      context: context,
      builder: (context) => LocationSearchDialog(
        onSearch: ({lat, lng, query}) {
          if (lat != null && lng != null) {
            ref
                .read(lodgingListProvider.notifier)
                .updateLocationFilter(lat, lng, 50);
          } else if (query != null) {
            ref.read(lodgingListProvider.notifier).updateSearchQuery(query);
          }
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

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        titleSpacing: 16,
        title: _LodgingsHeaderTitle(model: header),
        actions: [
          IconButton(
            icon: _isLocating
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
            onPressed: _isLocating ? null : _handleNearMe,
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
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
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
      body: Column(
        children: [
          _LodgingHeaderPanel(state: state, onTapSearch: _showLocationSearch),
          _LodgingFilterChips(
            selectedType: state.typeFilter,
            onFilterSelected: (type) {
              ref.read(lodgingListProvider.notifier).updateTypeFilter(type);
            },
          ),
          if (state.latitude != null || state.north != null)
            Container(
              width: double.infinity,
              color: colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.my_location,
                    size: 16,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.latitude != null
                        ? 'Showing lodgings near selected location'
                        : 'Showing lodgings in selected area',
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => ref
                        .read(lodgingListProvider.notifier)
                        .clearLocationFilter(),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(lodgingListProvider.notifier).refresh(),
              child: _LodgingList(state: state, controller: _scrollController),
            ),
          ),
        ],
      ),
    );
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
      if (q != null && q.isNotEmpty) return q;
      if (state.latitude != null) {
        return 'Near selected location';
      }
      return 'Where to?';
    }();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: outline),
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

class _LodgingList extends StatelessWidget {
  const _LodgingList({required this.state, required this.controller});

  final LodgingListState state;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(child: Text('Error: ${state.error}')),
          ),
        ],
      );
    }

    if (state.items.isEmpty) {
      return ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: const Center(child: Text('No lodgings found')),
          ),
        ],
      );
    }

    final showFooter = state.isLoading || state.hasMore;
    final itemCount = state.items.length + (showFooter ? 1 : 0);

    return ListView.separated(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
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
        return _LodgingCard(lodging: lodging);
      },
    );
  }
}

class _LodgingCard extends StatelessWidget {
  const _LodgingCard({required this.lodging});

  final Lodging lodging;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageUrl = lodging.media?.isNotEmpty == true
        ? lodging.media!.first.previewUrl ?? lodging.media!.first.url
        : null;

    final priceText = lodging.pricePerNight != null
        ? '${lodging.currency} ${lodging.pricePerNight!.toStringAsFixed(0)} / night'
        : 'Price on request';

    return Card(
      clipBehavior: Clip.hardEdge,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: imageUrl != null
                  ? Image.network(
                      ImageHelper.fixUrl(imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.broken_image,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.hotel,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lodging.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lodging.city}, ${lodging.country}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        lodging.averageRating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (lodging.distance != null) ...[
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lodging.distance!.toStringAsFixed(1)} km away',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        priceText,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (lodging.type != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _formatTypeLabel(lodging.type!),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTypeLabel(String raw) {
  final normalized = raw.trim().replaceAll('_', ' ');
  if (normalized.isEmpty) return raw;
  return normalized
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .map(
        (w) => w.length == 1
            ? w.toUpperCase()
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}',
      )
      .join(' ');
}
