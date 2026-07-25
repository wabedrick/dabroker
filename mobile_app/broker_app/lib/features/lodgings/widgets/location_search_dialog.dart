import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class LocationSearchDialog extends StatefulWidget {
  final Function({double? lat, double? lng, String? query}) onSearch;
  /// Called when geocoding fails and the dialog falls back to a name search.
  /// The parent (not the dialog) should show the snackbar so it works after pop.
  final void Function(String message)? onFallbackMessage;

  const LocationSearchDialog({
    super.key,
    required this.onSearch,
    this.onFallbackMessage,
  });

  @override
  State<LocationSearchDialog> createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<LocationSearchDialog> {
  final _controller = TextEditingController();
  bool _isGeocodingLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Tries to geocode the query as a real-world place.
  /// If geocoding succeeds → search by lat/lng within 50 km.
  /// If geocoding fails or returns nothing → fall back to name/keyword search
  /// so terms like "lodge", "beach house", "safari camp" still work.
  Future<void> _searchByArea(String query) async {
    if (_isGeocodingLoading || query.isEmpty) return;

    setState(() => _isGeocodingLoading = true);

    try {
      final locations = await locationFromAddress(query);
      if (!mounted) return;

      if (locations.isNotEmpty) {
        final loc = locations.first;
        widget.onSearch(lat: loc.latitude, lng: loc.longitude, query: query);
        Navigator.pop(context);
      } else {
        // Geocoder found nothing — fall back to keyword search silently
        _fallbackToNameSearch(query);
      }
    } catch (_) {
      if (!mounted) return;
      // Network/geocoder error — fall back to keyword search
      _fallbackToNameSearch(query);
    } finally {
      if (mounted) setState(() => _isGeocodingLoading = false);
    }
  }

  void _fallbackToNameSearch(String query) {
    widget.onSearch(query: query);
    final message =
        '"$query" wasn\'t found as a map location — showing lodgings matching the name instead.';
    if (mounted) Navigator.pop(context);
    // Notify parent to show snackbar (safe after dialog pop)
    widget.onFallbackMessage?.call(message);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final query = _controller.text.trim();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Find your next stay',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Search field ───────────────────────────────────────────────
            TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'City, neighborhood, or lodge name…',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (val) {
                final q = val.trim();
                if (q.isNotEmpty) {
                  widget.onSearch(query: q);
                  Navigator.pop(context);
                }
              },
            ),

            const SizedBox(height: 16),

            // ── Options (shown only when query is not empty) ───────────────
            if (query.isNotEmpty) ...[
              // Option 1: Name / keyword search (always works, instant)
              _SearchOption(
                icon: Icons.location_city_rounded,
                iconBg: colorScheme.primaryContainer,
                iconColor: colorScheme.onPrimaryContainer,
                title: 'Search by name',
                subtitle:
                    'Find lodgings whose name contains "$query"',
                onTap: () {
                  widget.onSearch(query: query);
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 8),

              // Option 2: Area / map search — geocodes, falls back if it fails
              _SearchOption(
                icon: Icons.map_rounded,
                iconBg: colorScheme.secondaryContainer,
                iconColor: colorScheme.onSecondaryContainer,
                isLoading: _isGeocodingLoading,
                title: 'Search nearby',
                subtitle:
                    'Find lodgings within 50 km of "$query"',
                onTap: _isGeocodingLoading ? null : () => _searchByArea(query),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Type a city, neighborhood, or lodge name to start searching.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable option row ────────────────────────────────────────────────────────

class _SearchOption extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isLoading;

  const _SearchOption({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration:
                  BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: iconColor,
                      ),
                    )
                  : Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
