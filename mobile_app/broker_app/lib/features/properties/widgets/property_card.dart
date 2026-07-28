import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/core/utils/money_format.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key, required this.property, this.onTap});

  final Property property;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (property.category == 'rent') {
      return _RentPropertyCard(property: property, onTap: onTap);
    }
    return _SalePropertyCard(property: property, onTap: onTap);
  }
}

class _SalePropertyCard extends StatelessWidget {
  const _SalePropertyCard({required this.property, this.onTap});

  final Property property;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final price = _formatPrice(property.price, property.currency);
    final location = _formatLocation(property.city, property.state);

    final images =
        property.gallery?.map((e) {
          final url = e.previewUrl ?? e.url ?? '';
          return ImageHelper.fixUrl(url);
        }).toList() ??
        [];

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'property_image_${property.id}',
                  child: _PropertyImage(images: images, propertyId: property.id),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'FOR SALE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                if (property.type != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatType(property.type!),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'property_title_${property.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        property.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  if (location != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                        if (property.distance != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.directions,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${property.distance!.toStringAsFixed(1)} km',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        price,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 8),
                      if (property.size != null && property.sizeUnit != null)
                        Text(
                          '${formatNumber(property.size, fractionDigits: 0)} ${property.sizeUnit}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      const Spacer(),
                      Icon(
                        property.isFavorited == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: property.isFavorited == true
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
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

class _RentPropertyCard extends StatelessWidget {
  const _RentPropertyCard({required this.property, this.onTap});

  final Property property;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final price = _formatPrice(property.price, property.currency);
    final location = _formatLocation(property.city, property.state);

    final images =
        property.gallery?.map((e) {
          final url = e.previewUrl ?? e.url ?? '';
          return ImageHelper.fixUrl(url);
        }).toList() ??
        [];

    final beds = property.metadata?['bedrooms'];
    final baths = property.metadata?['bathrooms'];

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'property_image_${property.id}',
                  child: _PropertyImage(images: images, propertyId: property.id),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'FOR RENT',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ),
                if (property.isAvailable ?? true)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'AVAILABLE NOW',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: 'property_title_${property.id}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              property.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        property.isFavorited == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 26,
                        color: property.isFavorited == true
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  if (location != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (beds != null) 
                        _AmenityBadge(icon: Icons.bed_outlined, value: '$beds Bed'),
                      if (baths != null) 
                        _AmenityBadge(icon: Icons.shower_outlined, value: '$baths Bath'),
                      if (property.type != null)
                        _AmenityBadge(icon: Icons.home_outlined, value: _formatType(property.type!)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '/ month',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

class _AmenityBadge extends StatelessWidget {
  const _AmenityBadge({required this.icon, required this.value});
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

// Helpers
String _formatPrice(double? price, String? currency) {
  if (price == null) return 'Contact for price';
  return formatMoney(price, currency, fractionDigits: 0);
}

String? _formatLocation(String? city, String? state) {
  if ((city?.isEmpty ?? true) && (state?.isEmpty ?? true)) return null;
  if (city != null && state != null) return '$city, $state';
  return city ?? state;
}

String _formatType(String type) {
  if (type == 'bank_property') return 'BANK PROPERTY';
  return type.toUpperCase();
}


class _PropertyImage extends StatefulWidget {
  const _PropertyImage({
    required this.images,
    required this.propertyId,
    this.aspectRatio = 16 / 9,
  });
  
  final List<String> images;
  final String propertyId;
  final double aspectRatio;

  @override
  State<_PropertyImage> createState() => _PropertyImageState();
}

class _PropertyImageState extends State<_PropertyImage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (widget.images.isEmpty) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          color: colorScheme.surfaceContainerHighest,
          child: Center(
            child: Icon(
              Icons.home_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.images[index],
                    fit: BoxFit.cover,
                    cacheWidth: 800, // Optimize memory usage
                    errorBuilder: (_, __, ___) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  // Subtle shadow for the pagination dots
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
