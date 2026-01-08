// ignore_for_file: unused_field

import 'package:broker_app/core/widgets/rating_dialog.dart';
import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/features/bookings/providers/booking_provider.dart';
import 'package:broker_app/features/lodgings/providers/lodging_list_provider.dart';
import 'package:broker_app/features/lodgings/screens/add_lodging_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class LodgingDetailScreen extends ConsumerStatefulWidget {
  const LodgingDetailScreen({
    super.key,
    required this.lodgingId,
    this.initialLodging,
  });

  final String lodgingId;
  final Lodging? initialLodging;

  @override
  ConsumerState<LodgingDetailScreen> createState() =>
      _LodgingDetailScreenState();
}

class _LodgingDetailScreenState extends ConsumerState<LodgingDetailScreen> {
  Lodging? _lodging;
  bool _isLoading = true;
  String? _error;
  int? _availableTonight;
  bool _loadingAvailability = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _lodging = widget.initialLodging;
    _isLoading = _lodging == null;
    _fetchLodging();
  }

  Future<void> _fetchLodging() async {
    try {
      final lodging = await ref
          .read(lodgingRepositoryProvider)
          .fetchLodgingDetail(widget.lodgingId);
      if (mounted) {
        setState(() {
          _lodging = lodging;
          _isLoading = false;
        });
      }

      // Fetch a quick availability estimate for tonight->tomorrow to show a badge
      try {
        setState(() => _loadingAvailability = true);
        final avail = await ref
            .read(lodgingRepositoryProvider)
            .fetchAvailability(
              lodging.id,
              DateTime.now(),
              DateTime.now().add(const Duration(days: 1)),
            );
        if (mounted) setState(() => _availableTonight = avail);
      } catch (_) {
        // ignore errors; badge will show as unknown
      } finally {
        if (mounted) setState(() => _loadingAvailability = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showRatingDialog(BuildContext context, WidgetRef ref) async {
    if (_lodging == null) return;

    showDialog(
      context: context,
      builder: (context) => RatingDialog(
        onSubmit: (rating, review) async {
          try {
            await ref
                .read(lodgingRepositoryProvider)
                .rateLodging(_lodging!.id, rating.toInt(), review);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rating submitted successfully')),
              );
              _fetchLodging(); // Refresh to show new rating
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          }
        },
      ),
    );
  }

  Future<void> _toggleAvailability(bool value) async {
    if (_lodging == null) return;

    try {
      final updatedLodging = await ref
          .read(lodgingRepositoryProvider)
          .updateLodging(_lodging!.id, {'is_available': value});

      setState(() {
        _lodging = updatedLodging;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value ? 'Lodging is now available' : 'Lodging is now unavailable',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update availability: $e')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, String lodgingId) async {
    final colorScheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lodging'),
        content: const Text(
          'Are you sure you want to delete this lodging? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Capture navigator and messenger before the async gap to avoid
      // using the passed BuildContext after awaiting.
      // ignore: use_build_context_synchronously
      final navigator = Navigator.of(context);
      // ignore: use_build_context_synchronously
      final messenger = ScaffoldMessenger.of(context);

      try {
        await ref.read(lodgingListProvider.notifier).deleteLodging(lodgingId);
        if (!mounted) return;
        navigator.pop(); // Return to list
        messenger.showSnackBar(
          const SnackBar(content: Text('Lodging deleted successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to delete lodging: $e')),
        );
      }
    }
  }

  Future<void> _showBookingDialog(BuildContext context, Lodging lodging) async {
    final user = ref.read(authStateProvider).user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to book a lodging')),
      );
      return;
    }

    final colorScheme = Theme.of(context).colorScheme;

    DateTimeRange? dateRange;
    int guests = 1;
    int rooms = 1;
    final notesController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          int? availableRooms;
          bool checkingAvailability = false;

          final nights = dateRange?.duration.inDays ?? 0;
          final totalPrice = (lodging.pricePerNight ?? 0) * nights * rooms;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'Book ${lodging.title}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Dates'),
                  subtitle: Text(
                    dateRange == null
                        ? 'Select dates'
                        : '${DateFormat('MMM d').format(dateRange!.start)} - ${DateFormat('MMM d').format(dateRange!.end)} ($nights nights)',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setModalState(() {
                        dateRange = picked;
                        checkingAvailability = true;
                        availableRooms = null;
                      });

                      try {
                        final avail = await ref
                            .read(lodgingRepositoryProvider)
                            .fetchAvailability(
                              lodging.id,
                              picked.start,
                              picked.end,
                            );
                        setModalState(() {
                          availableRooms = avail;
                          checkingAvailability = false;
                        });
                      } catch (_) {
                        setModalState(() {
                          availableRooms = null;
                          checkingAvailability = false;
                        });
                      }
                    }
                  },
                ),
                if (dateRange != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.meeting_room,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      if (checkingAvailability)
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      if (!checkingAvailability && availableRooms != null)
                        Text(
                          'Available rooms: $availableRooms',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      if (!checkingAvailability && availableRooms == null)
                        Text(
                          'Availability not available',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                ListTile(
                  title: const Text('Rooms'),
                  subtitle: Text(
                    '$rooms rooms (Max ${((availableRooms ?? lodging.totalRooms) ?? 1)})',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: rooms > 1
                            ? () => setModalState(() => rooms--)
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: (() {
                          final maxRooms =
                              (availableRooms ?? lodging.totalRooms ?? 1);
                          return rooms < maxRooms
                              ? () => setModalState(() => rooms++)
                              : null;
                        })(),
                      ),
                    ],
                  ),
                ),
                // Inline availability warning
                if (availableRooms != null) ...[
                  const SizedBox(height: 8),
                  if (availableRooms! <= 0)
                    Text(
                      'No rooms available for the selected dates',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (availableRooms! > 0 && rooms >= availableRooms!)
                    Text(
                      'You have selected all available rooms',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
                ListTile(
                  title: const Text('Guests'),
                  subtitle: Text('$guests guests'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: guests > 1
                            ? () => setModalState(() => guests--)
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: guests < ((lodging.maxGuests ?? 1) * rooms)
                            ? () => setModalState(() => guests++)
                            : null,
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes for host (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                if (dateRange != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${lodging.currency} ${totalPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (dateRange == null ||
                            (availableRooms != null &&
                                (availableRooms! <= 0 ||
                                    rooms > availableRooms!)))
                        ? null
                        : () async {
                            // Capture navigator & messenger to avoid using the
                            // modal BuildContext across async gap.
                            final navigator = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);

                            final success = await ref
                                .read(bookingProvider.notifier)
                                .createBooking({
                                  'lodging_id':
                                      lodging.id, // Assuming public_id is id
                                  'check_in': dateRange!.start
                                      .toIso8601String(),
                                  'check_out': dateRange!.end.toIso8601String(),
                                  'guests_count': guests,
                                  'rooms_count': rooms,
                                  'notes': notesController.text,
                                });

                            // Use captured references instead of the builder
                            // context after await to satisfy analyzer.
                            navigator.pop();
                            if (success != null) {
                              ref.invalidate(myBookingsProvider);
                              final available = success.availableRooms;
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    available != null
                                        ? 'Booking request sent! $available rooms remaining'
                                        : 'Booking request sent!',
                                  ),
                                ),
                              );
                            } else {
                              final error = ref.read(bookingProvider).error;
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('Failed to book: $error'),
                                ),
                              );
                            }
                          },
                    child: const Text('Book Now'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('wifi') || lower.contains('internet')) return Icons.wifi;
    if (lower.contains('pool')) return Icons.pool;
    if (lower.contains('parking')) return Icons.local_parking;
    if (lower.contains('gym') || lower.contains('fitness')) {
      return Icons.fitness_center;
    }
    if (lower.contains('ac') || lower.contains('air condition')) {
      return Icons.ac_unit;
    }
    if (lower.contains('tv')) return Icons.tv;
    if (lower.contains('kitchen')) return Icons.kitchen;
    if (lower.contains('washer') || lower.contains('laundry')) {
      return Icons.local_laundry_service;
    }
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null || _lodging == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(_error ?? 'Failed to load lodging')),
      );
    }

    final lodging = _lodging!;
    final user = ref.watch(authStateProvider).user;
    final isHost =
        user != null &&
        (lodging.host?.id == user.id || lodging.hostId == user.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: lodging.media?.isNotEmpty == true
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          itemCount: lodging.media!.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.network(
                              ImageHelper.fixUrl(lodging.media![index].url),
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withValues(
                                alpha: 0.85,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_currentImageIndex + 1} / ${lodging.media!.length}',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.hotel,
                        size: 64,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
            actions: [
              if (isHost) ...[
                IconButton(
                  icon: Icon(
                    lodging.isAvailable == true
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      _toggleAvailability(!(lodging.isAvailable ?? true)),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddLodgingScreen(lodging: lodging),
                      ),
                    );
                    _fetchLodging();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDelete(context, lodging.id),
                ),
              ],
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lodging.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (lodging.pricePerNight != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${lodging.currency} ${lodging.pricePerNight!.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'per night',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        lodging.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        ' (${lodging.ratingsCount} reviews)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      if (!isHost)
                        TextButton.icon(
                          onPressed: () => _showRatingDialog(context, ref),
                          icon: const Icon(Icons.star_outline, size: 18),
                          label: const Text('Rate'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lodging.city}, ${lodging.country}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.hotel,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lodging.totalRooms ?? 1} Rooms • ${lodging.maxGuests ?? 1} Guests/room',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Description'),
                  const SizedBox(height: 8),
                  Text(
                    lodging.description ?? 'No description available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  if (lodging.latitude != null &&
                      lodging.longitude != null) ...[
                    _SectionTitle(title: 'Where you\'ll be'),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              lodging.latitude!,
                              lodging.longitude!,
                            ),
                            initialZoom: 13,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.broker_app',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(
                                    lodging.latitude!,
                                    lodging.longitude!,
                                  ),
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.location_on,
                                    color: colorScheme.primary,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                            RichAttributionWidget(
                              attributions: const [
                                TextSourceAttribution(
                                  '© OpenStreetMap contributors',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (lodging.amenities?.isNotEmpty == true) ...[
                    _SectionTitle(title: 'What this place offers'),
                    const SizedBox(height: 16),
                    ...lodging.amenities!.map((amenity) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Icon(
                              _getAmenityIcon(amenity),
                              size: 24,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              amenity,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                  if (lodging.host != null) ...[
                    const Divider(),
                    const SizedBox(height: 24),
                    _SectionTitle(title: 'Hosted by ${lodging.host!.name}'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          child: Text(
                            lodging.host!.name[0].toUpperCase(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Joined ${DateFormat.yMMMM().format(lodging.host!.createdAt)}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: !isHost
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showBookingDialog(context, lodging),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Check Availability'),
                ),
              ),
            )
          : null,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
