import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/core/utils/money_format.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/features/properties/screens/property_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PropertyMapScreen extends StatefulWidget {
  final List<Property> properties;

  const PropertyMapScreen({super.key, required this.properties});

  @override
  State<PropertyMapScreen> createState() => _PropertyMapScreenState();
}

class _PropertyMapScreenState extends State<PropertyMapScreen> {
  final MapController _mapController = MapController();
  Property? _selectedProperty;

  late List<Property> _validProperties;
  late LatLng _center;
  late List<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _recomputeData();
  }

  @override
  void didUpdateWidget(covariant PropertyMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.properties != widget.properties) {
      _recomputeData();
    }
  }

  void _recomputeData() {
    _validProperties = widget.properties
        .where((p) => p.latitude != null && p.longitude != null)
        .toList(growable: false);

    _center = _calculateCenter(_validProperties);
    _markers = List<Marker>.unmodifiable(
      _validProperties.map((property) {
        final isSelected = _selectedProperty?.id == property.id;
        return _buildMarker(property: property, isSelected: isSelected);
      }),
    );
  }

  static LatLng _calculateCenter(List<Property> validProperties) {
    if (validProperties.isEmpty) {
      return const LatLng(40.7128, -74.0060);
    }

    double latSum = 0;
    double longSum = 0;
    for (final p in validProperties) {
      latSum += p.latitude!;
      longSum += p.longitude!;
    }

    final avgLat = latSum / validProperties.length;
    final avgLong = longSum / validProperties.length;

    if (avgLat == 0 && avgLong == 0) {
      return const LatLng(40.7128, -74.0060);
    }

    return LatLng(avgLat, avgLong);
  }

  Marker _buildMarker({required Property property, required bool isSelected}) {
    return Marker(
      point: LatLng(property.latitude!, property.longitude!),
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedProperty = property;
            // Only recompose the marker widgets when selection changes.
            _markers = List<Marker>.unmodifiable(
              _validProperties.map((p) {
                return _buildMarker(
                  property: p,
                  isSelected: p.id == property.id,
                );
              }),
            );
          });
          _mapController.move(
            LatLng(property.latitude!, property.longitude!),
            15.0,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue
                : AppColors.primaryBlue.withValues(alpha: 0.85),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            // Shadows are expensive when you have many markers; only apply to selection.
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const [],
          ),
          child: Icon(
            Icons.home,
            color: Colors.white,
            size: isSelected ? 30 : 24,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_validProperties.isEmpty) {
      return const Center(
        child: Text('No properties with location data found.'),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 13.0,
            // Ensure we don't go out of bounds
            minZoom: 3.0,
            maxZoom: 18.0,
            onTap: (_, __) {
              if (_selectedProperty != null) {
                setState(() {
                  _selectedProperty = null;
                  _markers = List<Marker>.unmodifiable(
                    _validProperties.map(
                      (p) => _buildMarker(property: p, isSelected: false),
                    ),
                  );
                });
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              // Keep this aligned with the actual app id to help OSM identify traffic.
              userAgentPackageName: 'com.example.broker_app',
              // Add a fallback for tile loading issues
              errorImage: const NetworkImage(
                'https://via.placeholder.com/256x256.png?text=Map+Error',
              ),
            ),
            MarkerLayer(markers: _markers),
            RichAttributionWidget(
              attributions: const [
                TextSourceAttribution('© OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
        if (_selectedProperty != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: _PropertyMapCard(property: _selectedProperty!),
          ),
      ],
    );
  }
}

class _PropertyMapCard extends StatelessWidget {
  final Property property;

  const _PropertyMapCard({required this.property});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 80,
                height: 80,
                child: property.gallery != null && property.gallery!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: property.gallery!.first.url,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.home,
                          color: colorScheme.onSurfaceVariant,
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
                    property.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatMoney(
                      property.price,
                      property.currency,
                      fractionDigits: 0,
                    ),
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.address ?? 'No address',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
