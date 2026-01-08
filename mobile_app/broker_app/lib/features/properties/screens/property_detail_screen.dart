import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/core/utils/money_format.dart';
import 'package:broker_app/core/widgets/skeleton_box.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/data/models/property_price_history.dart';
import 'package:broker_app/features/properties/providers/property_list_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/auth/screens/login_screen.dart';
import 'package:broker_app/features/properties/screens/add_property_screen.dart';
import 'package:broker_app/features/properties/screens/compare_properties_screen.dart';
import 'package:broker_app/features/properties/widgets/property_detail_widgets.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  const PropertyDetailScreen({
    super.key,
    required this.propertyId,
    this.initialProperty,
  });

  final String propertyId;
  final Property? initialProperty;

  @override
  ConsumerState<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  Property? _property;
  bool _isLoading = true;
  String? _error;
  bool _isFavoriteUpdating = false;
  bool _isContacting = false;
  bool _isOverviewExpanded = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageChanged);
    _property = widget.initialProperty;
    _isLoading = _property == null;
    _fetchProperty();
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_handlePageChanged)
      ..dispose();
    super.dispose();
  }

  void _handlePageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPage) {
      setState(() => _currentPage = page);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_property == null && _isLoading) {
      return const Scaffold(body: PropertyDetailSkeleton());
    }

    final property = _property;
    if (property == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 12),
                Text(
                  _error ?? 'Unable to load property details',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchProperty,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final location = _formatLocation(property.city, property.state);
    final price = _formatPrice(property.price, property.currency);
    final user = ref.watch(authStateProvider).user;
    final isOwner = user != null && property.owner?.id == user.id;
    final keyFacts = _extractKeyFacts(property);

    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
        actions: [
          if (isOwner) ...[
            Switch(
              value: property.isAvailable ?? true,
              onChanged: _toggleAvailability,
              activeTrackColor: Colors.green,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPropertyScreen(property: property),
                  ),
                );
                _fetchProperty();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, property.id),
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GallerySection(
                  controller: _pageController,
                  currentIndex: _currentPage,
                  media: property.gallery,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (property.verifiedAt != null)
                            const Chip(
                              label: Text('Verified'),
                              visualDensity: VisualDensity.compact,
                            ),
                          if (property.updatedAt != null)
                            Chip(
                              label: Text(
                                'Updated ${_formatTimeAgo(property.updatedAt!)}',
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                      if (location != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (property.address?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 6),
                        Text(
                          property.address!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],

                      const SizedBox(height: 16),
                      _DecisionSnapshotCard(property: property),

                      if (keyFacts.facts.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(
                          'Key facts',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: keyFacts.facts
                              .map(
                                (f) =>
                                    _InfoChip(label: f.label, value: f.value),
                              )
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          if (property.type != null)
                            _InfoChip(label: 'Type', value: property.type!),
                          if (property.category != null)
                            _InfoChip(
                              label: 'Listing Type',
                              value: property.category == 'rent'
                                  ? 'For Rent'
                                  : 'For Sale',
                            ),
                          if (property.size != null &&
                              property.sizeUnit != null)
                            _InfoChip(
                              label: 'Size',
                              value:
                                  '${formatNumber(property.size, fractionDigits: 0)} ${property.sizeUnit}',
                            ),
                          if (property.houseAge != null)
                            _InfoChip(
                              label: 'Built',
                              value: '${property.houseAge} yrs',
                            ),
                          if (property.status != null)
                            _InfoChip(label: 'Status', value: property.status!),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (property.owner != null)
                        _OwnerCard(owner: property.owner!),
                      if (property.description?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 32),
                        Text(
                          'Overview',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          property.description!,
                          maxLines: _isOverviewExpanded ? null : 6,
                          overflow: _isOverviewExpanded
                              ? null
                              : TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(height: 1.5),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _isOverviewExpanded = !_isOverviewExpanded;
                              });
                            },
                            child: Text(
                              _isOverviewExpanded ? 'Show less' : 'Read more',
                            ),
                          ),
                        ),
                      ],
                      if (property.amenities?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 32),
                        Text(
                          'Amenities',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _formatAmenities(property.amenities!)
                              .map(
                                (amenity) => Chip(
                                  label: Text(amenity),
                                  visualDensity: VisualDensity.compact,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      if (property.metadata?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 32),
                        Text(
                          'Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        ..._sortedMetadata(
                          property.metadata!,
                          excludeNormalizedKeys:
                              keyFacts.consumedNormalizedKeys,
                        ).map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _formatMetadataKey(entry.key),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    _formatMetadataValue(entry.value),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      VirtualTourSection(
                        videoUrl: property.videoUrl,
                        virtualTourUrl: property.virtualTourUrl,
                      ),
                      if (property.nearbyPlaces?.isNotEmpty ?? false)
                        NearbyPlacesSection(places: property.nearbyPlaces!),
                      if (property.priceHistory?.isNotEmpty ?? false)
                        PriceHistorySection(
                          history: property.priceHistory!,
                          currency: property.currency ?? '',
                        ),
                      if (property.similarProperties?.isNotEmpty ?? false)
                        SimilarPropertiesSection(
                          properties: property.similarProperties!,
                          onTap: (selected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PropertyDetailScreen(
                                  propertyId: selected.id,
                                  initialProperty: selected,
                                ),
                              ),
                            );
                          },
                          onCompare: (selected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ComparePropertiesScreen(
                                  left: property,
                                  right: selected,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha((0.05 * 255).round()),
                child: const PropertyDetailSkeleton(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: OutlinedButton(
                onPressed: _isFavoriteUpdating ? null : _handleToggleFavorite,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isFavoriteUpdating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        property.isFavorited == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: property.isFavorited == true
                            ? AppColors.error
                            : null,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isContacting ? null : _handleContactOwner,
                  child: _isContacting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Contact Owner'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchProperty() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repository = ref.read(propertyRepositoryProvider);
      final property = await repository.fetchPropertyDetail(widget.propertyId);
      if (!mounted) return;
      setState(() {
        _property = property;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleToggleFavorite() async {
    final property = _property;
    if (property == null) return;

    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sign in to save favorites'),
          action: SnackBarAction(
            label: 'Sign in',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ),
      );
      return;
    }

    final target = !(property.isFavorited ?? false);
    final previous = property.isFavorited ?? false;

    // Optimistic update: make the UI instant.
    setState(() {
      _property = property.copyWith(isFavorited: target);
      _isFavoriteUpdating = true;
    });
    ref
        .read(propertyListProvider.notifier)
        .updateFavoriteStatus(property.id, target);

    try {
      final confirmed = await ref
          .read(propertyRepositoryProvider)
          .toggleFavorite(propertyId: property.id, favorite: target);
      if (!mounted) return;

      setState(() {
        _property = (_property ?? property).copyWith(isFavorited: confirmed);
      });
      ref
          .read(propertyListProvider.notifier)
          .updateFavoriteStatus(property.id, confirmed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            confirmed ? 'Added to favorites' : 'Removed from favorites',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      // Roll back optimistic update.
      setState(() {
        _property = (_property ?? property).copyWith(isFavorited: previous);
      });
      ref
          .read(propertyListProvider.notifier)
          .updateFavoriteStatus(property.id, previous);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFavoriteUpdating = false;
        });
      }
    }
  }

  Future<void> _handleContactOwner() async {
    final property = _property;
    if (property == null) return;

    final message = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ContactOwnerSheet(propertyTitle: property.title),
    );

    if (message == null || message.trim().isEmpty) return;

    setState(() {
      _isContacting = true;
    });

    try {
      await ref
          .read(propertyRepositoryProvider)
          .contactOwner(propertyId: property.id, message: message.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Inquiry sent to owner')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isContacting = false;
        });
      }
    }
  }

  Future<void> _toggleAvailability(bool value) async {
    if (_property == null) return;

    try {
      final updatedProperty = await ref
          .read(propertyRepositoryProvider)
          .updateProperty(_property!.id, {'is_available': value});

      setState(() {
        _property = updatedProperty;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value
                  ? 'Property is now available'
                  : 'Property is now unavailable',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update availability: $e')),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, String propertyId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text(
          'Are you sure you want to delete this property? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Capture navigator & messenger before the async gap to avoid using
      // the passed BuildContext after awaiting.
      // ignore: use_build_context_synchronously
      final navigator = Navigator.of(context);
      // ignore: use_build_context_synchronously
      final messenger = ScaffoldMessenger.of(context);

      try {
        await ref
            .read(propertyListProvider.notifier)
            .deleteProperty(propertyId);
        if (!mounted) return;
        navigator.pop(); // Return to list
        messenger.showSnackBar(
          const SnackBar(content: Text('Property deleted successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to delete property: $e')),
        );
      }
    }
  }

  String? _formatLocation(String? city, String? state) {
    if ((city?.isEmpty ?? true) && (state?.isEmpty ?? true)) return null;
    if (city != null && state != null) return '$city, $state';
    return city ?? state;
  }

  String _formatPrice(double? price, String? currency) {
    if (price == null) return 'Contact for price';
    final code = (currency ?? 'USD').toUpperCase();
    final number = NumberFormat('#,##0', 'en_US');
    return '$code ${number.format(price)}';
  }

  List<String> _formatAmenities(List<String> raw) {
    final normalized = raw
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map(_titleCase)
        .toSet()
        .toList();
    normalized.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return normalized;
  }

  List<MapEntry<String, dynamic>> _sortedMetadata(
    Map<String, dynamic>? raw, {
    Set<String> excludeNormalizedKeys = const {},
  }) {
    if (raw == null || raw.isEmpty) return const [];

    final entries = raw.entries
        .where((e) => e.key.trim().isNotEmpty)
        .where((e) => !_shouldHideMetadataKey(e.key))
        .where((e) => _isUsefulMetadataValue(e.value))
        .where(
          (e) => !excludeNormalizedKeys.contains(_normalizeMetadataKey(e.key)),
        )
        .toList();
    entries.sort((a, b) {
      return _formatMetadataKey(
        a.key,
      ).toLowerCase().compareTo(_formatMetadataKey(b.key).toLowerCase());
    });
    return entries;
  }

  _KeyFactsResult _extractKeyFacts(Property property) {
    final metadata = property.metadata ?? const <String, dynamic>{};

    String? findValue(List<String> matchers) {
      for (final entry in metadata.entries) {
        final normalizedKey = _normalizeMetadataKey(entry.key);
        for (final matcher in matchers) {
          if (normalizedKey == matcher) {
            final value = _formatMetadataValue(entry.value);
            if (value != '-' && value.trim().isNotEmpty) return value;
          }
        }
      }
      return null;
    }

    String? findValueByContains(List<String> needles) {
      for (final entry in metadata.entries) {
        final normalizedKey = _normalizeMetadataKey(entry.key);
        for (final needle in needles) {
          if (normalizedKey.contains(needle)) {
            final value = _formatMetadataValue(entry.value);
            if (value != '-' && value.trim().isNotEmpty) return value;
          }
        }
      }
      return null;
    }

    String? findKeyNormalized(List<String> matchers, {bool contains = false}) {
      for (final entry in metadata.entries) {
        final normalizedKey = _normalizeMetadataKey(entry.key);
        for (final matcher in matchers) {
          final matches = contains
              ? normalizedKey.contains(matcher)
              : normalizedKey == matcher;
          if (matches) return normalizedKey;
        }
      }
      return null;
    }

    final facts = <_KeyFact>[];
    final consumed = <String>{};

    void add(String label, String? value, {String? consumedKey}) {
      if (value == null) return;
      final trimmed = value.trim();
      if (trimmed.isEmpty || trimmed == '-') return;
      facts.add(_KeyFact(label: label, value: trimmed));
      if (consumedKey != null) consumed.add(consumedKey);
    }

    final bedsKey = findKeyNormalized(const [
      'bedrooms',
      'beds',
      'bed_rooms',
      'bedroom_count',
    ]);
    add(
      'Beds',
      findValue(const ['bedrooms', 'beds', 'bed_rooms', 'bedroom_count']),
      consumedKey: bedsKey,
    );

    final bathsKey = findKeyNormalized(const [
      'bathrooms',
      'baths',
      'bath_rooms',
      'bathroom_count',
    ]);
    add(
      'Baths',
      findValue(const ['bathrooms', 'baths', 'bath_rooms', 'bathroom_count']),
      consumedKey: bathsKey,
    );

    final parkingKey = findKeyNormalized(const [
      'parking',
      'parking_spaces',
      'garage',
      'garage_spaces',
    ]);
    add(
      'Parking',
      findValue(const ['parking', 'parking_spaces', 'garage', 'garage_spaces']),
      consumedKey: parkingKey,
    );

    final floorKey = findKeyNormalized(const [
      'floor',
      'floor_number',
      'level',
    ]);
    add(
      'Floor',
      findValue(const ['floor', 'floor_number', 'level']),
      consumedKey: floorKey,
    );

    final furnishedKey = findKeyNormalized(const [
      'furnished',
      'furnishing',
      'furnish_status',
    ], contains: false);
    add(
      'Furnishing',
      findValue(const ['furnished', 'furnishing', 'furnish_status']) ??
          findValueByContains(const ['furnish']),
      consumedKey:
          furnishedKey ?? findKeyNormalized(const ['furnish'], contains: true),
    );

    final petKey = findKeyNormalized(const [
      'pet_friendly',
      'pets_allowed',
      'pets',
    ], contains: false);
    add(
      'Pets',
      findValue(const ['pet_friendly', 'pets_allowed', 'pets']) ??
          findValueByContains(const ['pet']),
      consumedKey: petKey ?? findKeyNormalized(const ['pet'], contains: true),
    );

    final hoaKey = findKeyNormalized(const [
      'hoa_fee',
      'association_fee',
      'maintenance_fee',
    ], contains: false);
    add(
      'Fees',
      findValue(const ['hoa_fee', 'association_fee', 'maintenance_fee']) ??
          findValueByContains(const ['hoa', 'fee', 'maintenance']),
      consumedKey:
          hoaKey ??
          findKeyNormalized(const [
            'hoa',
            'association',
            'maintenance',
          ], contains: true),
    );

    final lotKey = findKeyNormalized(const [
      'lot_size',
      'land_size',
      'plot_size',
    ], contains: false);
    add(
      'Lot',
      findValue(const ['lot_size', 'land_size', 'plot_size']) ??
          findValueByContains(const ['lot', 'land', 'plot']),
      consumedKey:
          lotKey ??
          findKeyNormalized(const ['lot', 'land', 'plot'], contains: true),
    );

    // Keep the section compact.
    final cappedFacts = facts.take(8).toList();
    return _KeyFactsResult(
      facts: cappedFacts,
      consumedNormalizedKeys: consumed,
    );
  }

  String _normalizeMetadataKey(String raw) {
    return raw
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(RegExp(r'\s+'), '_');
  }

  bool _shouldHideMetadataKey(String rawKey) {
    final key = _normalizeMetadataKey(rawKey);
    if (key.isEmpty) return true;
    if (key.startsWith('_')) return true;
    if (key.contains('internal')) return true;
    if (key == 'pivot') return true;
    if (key == 'deleted_at') return true;
    return false;
  }

  bool _isUsefulMetadataValue(Object? value) {
    if (value == null) return false;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return false;
      if (trimmed.toLowerCase() == 'null') return false;
      return true;
    }
    if (value is Iterable) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;
    return true;
  }

  String _formatMetadataKey(String raw) {
    final cleaned = raw.replaceAll('_', ' ').replaceAll('-', ' ').trim();
    return _titleCase(cleaned);
  }

  String _formatMetadataValue(Object? value) {
    if (value == null) return '-';
    if (value is bool) return value ? 'Yes' : 'No';
    if (value is num) {
      if (value is int) return value.toString();
      final number = NumberFormat('#,##0.##', 'en_US');
      return number.format(value);
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return '-';
      final parsed = DateTime.tryParse(trimmed);
      if (parsed != null) {
        return DateFormat.yMMMd().format(parsed);
      }
      return trimmed;
    }
    return value.toString();
  }

  String _titleCase(String value) {
    final words = value
        .split(RegExp(r'\s+'))
        .map((w) => w.trim())
        .where((w) => w.isNotEmpty)
        .toList();
    return words
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  String _formatTimeAgo(DateTime value) {
    final now = DateTime.now();
    final diff = now.difference(value);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';

    final months = (diff.inDays / 30).floor();
    if (months < 12) return '${months}mo ago';

    final years = (diff.inDays / 365).floor();
    return '${years}y ago';
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({
    required this.controller,
    required this.currentIndex,
    required this.media,
  });

  final PageController controller;
  final int currentIndex;
  final List<PropertyMedia>? media;

  @override
  Widget build(BuildContext context) {
    final images = media ?? const [];

    if (images.isEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: AppColors.primaryBlue.withAlpha((0.08 * 255).round()),
          child: const Center(child: Icon(Icons.home_outlined, size: 64)),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: controller,
            itemCount: images.length,
            itemBuilder: (_, index) {
              final item = images[index];
              final url = ImageHelper.fixUrl(item.previewUrl ?? item.url);
              return CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                memCacheWidth: 1080, // Optimize memory usage for detail view
                placeholder: (_, __) => Container(
                  color: AppColors.primaryBlue.withAlpha((0.08 * 255).round()),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.primaryBlue.withAlpha((0.08 * 255).round()),
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined, size: 48),
                  ),
                ),
              );
            },
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 12,
            child: Row(
              children: List.generate(
                images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? AppColors.primaryBlue
                        : AppColors.white.withAlpha((0.7 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        if (images.length > 1)
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((0.55 * 255).round()),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${currentIndex + 1}/${images.length}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.white),
              ),
            ),
          ),
      ],
    );
  }
}

class _DecisionSnapshotCard extends StatelessWidget {
  const _DecisionSnapshotCard({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surfaceContainerHighest;
    final price = property.price;
    final size = property.size;
    final unit = property.sizeUnit ?? 'unit';
    final currency = (property.currency ?? 'USD').toUpperCase();
    final number = NumberFormat('#,##0', 'en_US');

    String fmtMoney(double? value) {
      if (value == null) return '-';
      return '$currency ${number.format(value)}';
    }

    String fmtUnitPrice() {
      if (price == null || size == null || size <= 0) return '-';
      return '$currency ${number.format(price / size)}/$unit';
    }

    final history = (property.priceHistory ?? const <dynamic>[])
        .whereType<PropertyPriceHistory>()
        .toList();
    history.sort((a, b) {
      final aDate = a.changedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.changedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    String fmtLastMove() {
      if (history.isEmpty) return '-';
      final latest = history.first;
      final diff = (latest.newPrice ?? 0) - (latest.oldPrice ?? 0);
      final sign = diff > 0 ? '+' : '';
      final date = latest.changedAt != null
          ? DateFormat.yMMMd().format(latest.changedAt!)
          : null;
      final amount = '$sign$currency ${number.format(diff.abs())}';
      return date == null ? amount : '$amount · $date';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Decision snapshot',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SnapshotItem(
                  label: 'Unit price',
                  value: fmtUnitPrice(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SnapshotItem(
                  label: 'Last price move',
                  value: fmtLastMove(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SnapshotItem(
                  label: 'Listed',
                  value: property.createdAt != null
                      ? DateFormat.yMMMd().format(property.createdAt!)
                      : '-',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SnapshotItem(
                  label: 'Price',
                  value: fmtMoney(property.price),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SnapshotItem extends StatelessWidget {
  const _SnapshotItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _KeyFact {
  const _KeyFact({required this.label, required this.value});

  final String label;
  final String value;
}

class _KeyFactsResult {
  const _KeyFactsResult({
    required this.facts,
    required this.consumedNormalizedKeys,
  });

  final List<_KeyFact> facts;
  final Set<String> consumedNormalizedKeys;
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class PropertyDetailSkeleton extends StatelessWidget {
  const PropertyDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: const [
          SkeletonBox(width: double.infinity, height: 220, borderRadius: 0),
          SizedBox(height: 24),
          SkeletonBox(width: 180, height: 24),
          SizedBox(height: 12),
          SkeletonBox(width: 140, height: 16),
          SizedBox(height: 24),
          SkeletonBox(width: double.infinity, height: 100),
          SizedBox(height: 24),
          SkeletonBox(width: double.infinity, height: 160),
        ],
      ),
    );
  }
}

class _ContactOwnerSheet extends StatefulWidget {
  const _ContactOwnerSheet({required this.propertyTitle});

  final String propertyTitle;

  @override
  State<_ContactOwnerSheet> createState() => _ContactOwnerSheetState();
}

class _ContactOwnerSheetState extends State<_ContactOwnerSheet> {
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Owner',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Send a quick note about "${widget.propertyTitle}"',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tell the owner what interests you... ',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a message';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  Navigator.of(context).pop(_messageController.text.trim());
                },
                child: const Text('Send'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.owner});

  final PropertyUserSummary owner;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primaryBlue.withAlpha(
              (0.1 * 255).round(),
            ),
            child: Text(
              owner.name.isNotEmpty ? owner.name[0].toUpperCase() : '?',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.primaryBlue),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  owner.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (owner.preferredRole != null)
                  Text(
                    owner.formattedRole,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Navigate to owner profile once available.
            },
            icon: const Icon(Icons.chat_bubble_outline),
          ),
        ],
      ),
    );
  }
}
