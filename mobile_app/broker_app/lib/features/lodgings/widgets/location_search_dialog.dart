import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class LocationSearchDialog extends StatefulWidget {
  final Function({double? lat, double? lng, String? query}) onSearch;

  const LocationSearchDialog({super.key, required this.onSearch});

  @override
  State<LocationSearchDialog> createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<LocationSearchDialog> {
  final _controller = TextEditingController();
  List<Location> _locations = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    if (_isLoading) return;
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
      _locations = [];
    });

    try {
      final locations = await locationFromAddress(query);
      setState(() => _locations = locations);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not find location: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final query = _controller.text.trim();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Where to?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search City, Zip, or Address',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.arrow_forward),
                  onPressed: _isLoading ? null : _search,
                ),
              ),
              onSubmitted: (_) => _search(),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SizedBox(
                height: 200, // Limit height
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    if (query.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.search),
                        title: Text('Search for "$query"'),
                        onTap: () {
                          widget.onSearch(query: query);
                          Navigator.pop(context);
                        },
                      ),
                    ..._locations.map((loc) {
                      return ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        title: Text(query.isEmpty ? _controller.text : query),
                        subtitle: Text(
                          '${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}',
                        ),
                        onTap: () {
                          widget.onSearch(
                            lat: loc.latitude,
                            lng: loc.longitude,
                            query: query,
                          );
                          Navigator.pop(context);
                        },
                      );
                    }),
                    if (_locations.isEmpty && query.isNotEmpty && !_isLoading)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No location results found',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
