import 'package:broker_app/core/theme/app_theme.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(lodgingListProvider.notifier).load());
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
            const SnackBar(
              content: Text(
                'Location permissions are permanently denied, we cannot request permissions.',
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
      builder:
          (context) => LocationSearchDialog(
            onSearch: ({lat, lng, query}) {
              if (lat != null && lng != null) {
                ref
                    .read(lodgingListProvider.notifier)
                    .updateLocationFilter(lat, lng, 10);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    final state = ref.watch(lodgingListProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    final canCreate =
        user != null &&
        (user.roles.contains('host') ||
            user.roles.contains('seller') ||
            user.roles.contains('admin') ||
            user.roles.contains('super_admin'));

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _showLocationSearch,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.latitude != null ? 'Location set' : 'Where to?',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: _isLocating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : Icon(
                    state.latitude != null
                        ? Icons.location_on
                        : Icons.location_on_outlined,
                    color: state.latitude != null
                        ? AppColors.primaryBlue
                        : null,
                  ),
            tooltip: state.latitude != null ? 'Clear location' : 'Near me',
            onPressed: _isLocating ? null : _handleNearMe,
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.sort,
              color: state.sortBy != null ? AppColors.primaryBlue : null,
            ),
            tooltip: 'Sort by',
            onSelected: (value) {
              ref.read(lodgingListProvider.notifier).updateSortBy(
                value == 'default' ? null : value,
              );
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
                      color: hasLocation ? null : Colors.grey,
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'lodging_map_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LodgingMapScreen()),
          );
        },
        label: const Text('Map'),
        icon: const Icon(Icons.map),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          _LodgingFilterChips(
            selectedType: state.typeFilter,
            onFilterSelected: (type) {
              ref.read(lodgingListProvider.notifier).updateTypeFilter(type);
            },
          ),
          if (state.latitude != null || state.north != null)
            Container(
              width: double.infinity,
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.my_location,
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.latitude != null
                        ? 'Showing lodgings within ${state.radius?.toInt()}km'
                        : 'Showing lodgings in selected area',
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => ref
                        .read(lodgingListProvider.notifier)
                        .clearLocationFilter(),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(lodgingListProvider.notifier).refresh(),
              child: _LodgingList(state: state),
            ),
          ),
        ],
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
  const _LodgingList({required this.state});

  final LodgingListState state;

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
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: const Center(child: Text('No lodgings found')),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: state.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
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
    final imageUrl = lodging.media?.isNotEmpty == true
        ? lodging.media!.first.previewUrl ?? lodging.media!.first.url
        : null;

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.hotel),
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
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (lodging.distance != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lodging.distance!.toStringAsFixed(1)} km away',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${lodging.currency} ${lodging.pricePerNight?.toStringAsFixed(0)} / night',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primaryBlue,
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.darkAccent
                                    : AppColors.backgroundGray,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lodging.type!.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : AppColors.textPrimary,
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
