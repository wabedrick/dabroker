import 'package:flutter/material.dart';
import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/data/models/property_price_history.dart';
import 'package:broker_app/features/properties/widgets/property_card.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class VirtualTourSection extends StatelessWidget {
  final String? videoUrl;
  final String? virtualTourUrl;

  const VirtualTourSection({super.key, this.videoUrl, this.virtualTourUrl});

  @override
  Widget build(BuildContext context) {
    if (videoUrl == null && virtualTourUrl == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          'Virtual Tour & Video',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (videoUrl != null)
              Expanded(
                child: _LinkButton(
                  icon: Icons.play_circle_outline,
                  label: 'Watch Video',
                  url: videoUrl!,
                  color: AppColors.error,
                ),
              ),
            if (videoUrl != null && virtualTourUrl != null)
              const SizedBox(width: 12),
            if (virtualTourUrl != null)
              Expanded(
                child: _LinkButton(
                  icon: Icons.threed_rotation,
                  label: '3D Tour',
                  url: virtualTourUrl!,
                  color: AppColors.primaryBlue,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final Color color;

  const _LinkButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => launchUrl(Uri.parse(url)),
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

class NearbyPlacesSection extends StatelessWidget {
  final List<Map<String, dynamic>> places;

  const NearbyPlacesSection({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text('Nearby Places', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: places.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final place = places[index];
            return ListTile(
              leading: const Icon(Icons.place, color: AppColors.primaryBlue),
              title: Text(place['name'] ?? ''),
              subtitle: Text(place['type']?.toString().toUpperCase() ?? ''),
              trailing: Text(
                place['distance'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              contentPadding: EdgeInsets.zero,
            );
          },
        ),
      ],
    );
  }
}

class PriceHistorySection extends StatelessWidget {
  final List<PropertyPriceHistory> history;
  final String currency;

  const PriceHistorySection({
    super.key,
    required this.history,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    final surface = Theme.of(context).colorScheme.surfaceContainerHighest;

    final sorted = [...history]
      ..sort((a, b) {
        final aDate = a.changedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.changedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

    final latest = sorted.first;
    final earliest = sorted.last;

    final latestOld = latest.oldPrice;
    final latestNew = latest.newPrice;
    final latestDiff = (latestNew ?? 0) - (latestOld ?? 0);
    final latestIsUp = latestDiff > 0;

    final firstOld = earliest.oldPrice;
    final totalDiff = (latestNew ?? 0) - (firstOld ?? 0);
    final totalIsUp = totalDiff > 0;

    final number = NumberFormat('#,##0', 'en_US');
    String fmtMoney(double? value) {
      if (value == null) return '-';
      final formatted = number.format(value);
      final code = currency.trim();
      return code.isEmpty ? formatted : '$code $formatted';
    }

    String fmtDelta(double value) {
      final sign = value > 0 ? '+' : '';
      final formatted = number.format(value.abs());
      final code = currency.trim();
      final amount = code.isEmpty ? formatted : '$code $formatted';
      return '$sign$amount';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text('Price History', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last change',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    latestIsUp ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: latestIsUp ? AppColors.error : AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    fmtDelta(latestDiff),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: latestIsUp ? AppColors.error : AppColors.success,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    fmtMoney(latestNew),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Total change',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    totalIsUp ? Icons.trending_up : Icons.trending_down,
                    size: 16,
                    color: totalIsUp ? AppColors.error : AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    fmtDelta(totalDiff),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: totalIsUp ? AppColors.error : AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final item = sorted[index];
            final date = item.changedAt != null
                ? DateFormat.yMMMd().format(item.changedAt!)
                : '-';
            final diff = (item.newPrice ?? 0) - (item.oldPrice ?? 0);
            final isUp = diff > 0;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(fmtMoney(item.newPrice)),
              subtitle: Text(date),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isUp ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isUp ? AppColors.error : AppColors.success,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    fmtDelta(diff),
                    style: TextStyle(
                      color: isUp ? AppColors.error : AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class SimilarPropertiesSection extends StatelessWidget {
  final List<Property> properties;
  final Function(Property) onTap;
  final Function(Property)? onCompare;

  const SimilarPropertiesSection({
    super.key,
    required this.properties,
    required this.onTap,
    this.onCompare,
  });

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          'Similar Properties',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: properties.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final property = properties[index];

              return SizedBox(
                width: 240,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PropertyCard(
                        property: property,
                        onTap: () => onTap(property),
                      ),
                    ),
                    if (onCompare != null)
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: ElevatedButton(
                          onPressed: () => onCompare!(property),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Compare'),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
