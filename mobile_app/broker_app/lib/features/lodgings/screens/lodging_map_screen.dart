import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/features/lodgings/providers/lodging_list_provider.dart';
import 'package:broker_app/features/lodgings/screens/lodging_detail_screen.dart';

class LodgingMapScreen extends ConsumerStatefulWidget {
  const LodgingMapScreen({super.key});

  @override
  ConsumerState<LodgingMapScreen> createState() => _LodgingMapScreenState();
}

class _LodgingMapScreenState extends ConsumerState<LodgingMapScreen> {
  final MapController _mapController = MapController();
  bool _showSearchButton = false;

  Widget _buildLodgingMarker({required ColorScheme colorScheme}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.onPrimary, width: 2),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.16),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.location_on, color: colorScheme.onPrimary, size: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lodgingState = ref.watch(lodgingListProvider);
    final lodgings = lodgingState.items;

    // Determine initial center
    // If we have lodgings, center on the first one
    // If we have a location filter, center on that
    // Otherwise default to London (or 0,0)
    LatLng initialCenter = const LatLng(51.509364, -0.128928);
    if (lodgingState.latitude != null && lodgingState.longitude != null) {
      initialCenter = LatLng(lodgingState.latitude!, lodgingState.longitude!);
    } else if (lodgings.isNotEmpty) {
      final firstWithLocation = lodgings
          .where((l) => l.latitude != null && l.longitude != null)
          .firstOrNull;
      if (firstWithLocation != null) {
        initialCenter = LatLng(
          firstWithLocation.latitude!,
          firstWithLocation.longitude!,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Map Search')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 13.0,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture && !_showSearchButton) {
                  setState(() => _showSearchButton = true);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.broker_app',
              ),
              MarkerLayer(
                markers: lodgings
                    .where((l) => l.latitude != null && l.longitude != null)
                    .map((lodging) {
                      return Marker(
                        point: LatLng(lodging.latitude!, lodging.longitude!),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LodgingDetailScreen(
                                  lodgingId: lodging.id,
                                  initialLodging: lodging,
                                ),
                              ),
                            );
                          },
                          child: _buildLodgingMarker(colorScheme: colorScheme),
                        ),
                      );
                    })
                    .toList(),
              ),
              RichAttributionWidget(
                attributions: const [
                  TextSourceAttribution('© OpenStreetMap contributors'),
                ],
              ),
            ],
          ),
          if (_showSearchButton)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _searchArea,
                  icon: const Icon(Icons.search),
                  label: const Text('Search this area'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    foregroundColor: colorScheme.onSurface,
                    elevation: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _searchArea() {
    try {
      final bounds = _mapController.camera.visibleBounds;
      ref
          .read(lodgingListProvider.notifier)
          .updateBoundsFilter(
            bounds.north,
            bounds.south,
            bounds.east,
            bounds.west,
          );
      setState(() => _showSearchButton = false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Map is still loading. Try again.')),
      );
    }
  }
}
