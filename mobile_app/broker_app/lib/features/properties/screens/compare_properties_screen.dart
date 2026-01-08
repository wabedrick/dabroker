import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComparePropertiesScreen extends StatelessWidget {
  final Property left;
  final Property right;

  const ComparePropertiesScreen({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <_CompareRowData>[
      _CompareRowData(
        label: 'Price',
        left: _formatPrice(left.price, left.currency),
        right: _formatPrice(right.price, right.currency),
      ),
      _CompareRowData(
        label: 'Price / Size',
        left: _formatPricePerSize(left),
        right: _formatPricePerSize(right),
      ),
      _CompareRowData(
        label: 'Location',
        left: _formatLocation(left),
        right: _formatLocation(right),
      ),
      _CompareRowData(
        label: 'Type',
        left: left.type ?? '-',
        right: right.type ?? '-',
      ),
      _CompareRowData(
        label: 'Listing',
        left: _formatCategory(left.category),
        right: _formatCategory(right.category),
      ),
      _CompareRowData(
        label: 'Size',
        left: _formatSize(left),
        right: _formatSize(right),
      ),
      _CompareRowData(
        label: 'Built',
        left: left.houseAge != null ? '${left.houseAge} yrs' : '-',
        right: right.houseAge != null ? '${right.houseAge} yrs' : '-',
      ),
      _CompareRowData(
        label: 'Verified',
        left: left.verifiedAt != null ? 'Yes' : 'No',
        right: right.verifiedAt != null ? 'Yes' : 'No',
      ),
      _CompareRowData(
        label: 'Updated',
        left: _formatDate(left.updatedAt),
        right: _formatDate(right.updatedAt),
      ),
      _CompareRowData(
        label: 'Last price change',
        left: _formatLastPriceChange(left),
        right: _formatLastPriceChange(right),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Compare')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCards(left: left, right: right),
            const SizedBox(height: 16),
            _CompareTable(rows: rows),
          ],
        ),
      ),
    );
  }
}

class _HeaderCards extends StatelessWidget {
  final Property left;
  final Property right;

  const _HeaderCards({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _PropertyHeaderCard(property: left)),
        const SizedBox(width: 12),
        Expanded(child: _PropertyHeaderCard(property: right)),
      ],
    );
  }
}

class _PropertyHeaderCard extends StatelessWidget {
  final Property property;

  const _PropertyHeaderCard({required this.property});

  @override
  Widget build(BuildContext context) {
    final price = _formatPrice(property.price, property.currency);
    final colorScheme = Theme.of(context).colorScheme;
    final surface = colorScheme.surface;
    final surfaceContainer = colorScheme.surfaceContainerHighest;
    final outline = colorScheme.outlineVariant;
    final coverUrl = property.gallery?.isNotEmpty == true
        ? ImageHelper.fixUrl(
            property.gallery!.first.previewUrl ?? property.gallery!.first.url,
          )
        : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: outline),
        borderRadius: BorderRadius.circular(12),
        color: surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (coverUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: coverUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: surfaceContainer),
                  errorWidget: (_, __, ___) => Container(
                    color: surfaceContainer,
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            property.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatLocation(property),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareTable extends StatelessWidget {
  final List<_CompareRowData> rows;

  const _CompareTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surface = colorScheme.surface;
    final outline = colorScheme.outlineVariant;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: outline),
        borderRadius: BorderRadius.circular(12),
        color: surface,
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.1),
          1: FlexColumnWidth(1.4),
          2: FlexColumnWidth(1.4),
        },
        border: TableBorder(horizontalInside: BorderSide(color: outline)),
        children: [
          for (final row in rows)
            TableRow(
              children: [
                _Cell(text: row.label, isLabel: true),
                _Cell(text: row.left),
                _Cell(text: row.right),
              ],
            ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final bool isLabel;

  const _Cell({required this.text, this.isLabel = false});

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: isLabel
            ? Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: onSurfaceVariant)
            : Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _CompareRowData {
  final String label;
  final String left;
  final String right;

  const _CompareRowData({
    required this.label,
    required this.left,
    required this.right,
  });
}

String _formatPrice(double? price, String? currency) {
  if (price == null) return '-';
  final formatted = NumberFormat('#,##0', 'en_US').format(price);
  final code = (currency ?? '').trim();
  return code.isEmpty ? formatted : '$code $formatted';
}

String _formatSize(Property property) {
  final size = property.size;
  if (size == null) return '-';
  final unit = property.sizeUnit?.trim();
  final formatted = NumberFormat('#,##0', 'en_US').format(size);
  return unit == null || unit.isEmpty ? formatted : '$formatted $unit';
}

String _formatLocation(Property property) {
  final city = property.city?.trim();
  final state = property.state?.trim();
  if ((city == null || city.isEmpty) && (state == null || state.isEmpty)) {
    return '-';
  }
  if (city != null && city.isNotEmpty && state != null && state.isNotEmpty) {
    return '$city, $state';
  }
  return (city?.isNotEmpty == true) ? city! : state!;
}

String _formatCategory(String? category) {
  if (category == null || category.isEmpty) return '-';
  if (category == 'rent') return 'For Rent';
  if (category == 'sale') return 'For Sale';
  return category;
}

String _formatPricePerSize(Property property) {
  final price = property.price;
  final size = property.size;
  if (price == null || size == null || size == 0) return '-';
  final value = price / size;
  final formatted = NumberFormat('#,##0', 'en_US').format(value);
  final code = (property.currency ?? '').trim();
  final unit = (property.sizeUnit ?? '').trim();
  final unitLabel = unit.isEmpty ? 'unit' : unit;
  return code.isEmpty
      ? '$formatted / $unitLabel'
      : '$code $formatted / $unitLabel';
}

String _formatDate(DateTime? value) {
  if (value == null) return '-';
  return DateFormat.yMMMd().format(value);
}

String _formatLastPriceChange(Property property) {
  final history = property.priceHistory;
  if (history == null || history.isEmpty) return '-';

  // Pick the most recent record by changedAt if present.
  final sorted = [...history]
    ..sort((a, b) {
      final aDate = a.changedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.changedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

  final latest = sorted.first;
  final oldP = latest.oldPrice;
  final newP = latest.newPrice;
  if (oldP == null || newP == null) return '-';
  final diff = newP - oldP;
  final sign = diff > 0 ? '+' : '';
  final formatted = NumberFormat('#,##0', 'en_US').format(diff.abs());
  final code = (property.currency ?? '').trim();
  final amount = code.isEmpty ? formatted : '$code $formatted';
  final date = latest.changedAt != null
      ? DateFormat.yMMMd().format(latest.changedAt!)
      : null;
  return date == null ? '$sign$amount' : '$sign$amount • $date';
}
