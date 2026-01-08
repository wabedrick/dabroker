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
    final colorScheme = Theme.of(context).colorScheme;
    final price = _formatPrice(property.price, property.currency);
    final location = _formatLocation(property.city, property.state);

    final images =
        property.gallery?.map((e) {
          final url = e.previewUrl ?? e.url;
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
                _PropertyImage(images: images),
                if (property.category != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: property.category == 'rent'
                            ? colorScheme.primary
                            : colorScheme.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        property.category == 'rent' ? 'FOR RENT' : 'FOR SALE',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: property.category == 'rent'
                              ? colorScheme.onPrimary
                              : colorScheme.onSecondary,
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
                  Text(
                    property.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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

  String _formatPrice(double? price, String? currency) {
    if (price == null) return 'Contact for price';
    return formatMoney(price, currency, fractionDigits: 0);
  }

  String? _formatLocation(String? city, String? state) {
    if ((city?.isEmpty ?? true) && (state?.isEmpty ?? true)) return null;
    if (city != null && state != null) return '$city, $state';
    return city ?? state;
  }
}

class _PropertyImage extends StatefulWidget {
  const _PropertyImage({required this.images});

  final List<String> images;

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
        aspectRatio: 16 / 9,
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
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return Image.network(
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
