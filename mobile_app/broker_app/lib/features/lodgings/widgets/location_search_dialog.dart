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

  Future<void> _search() async {
    if (_controller.text.isEmpty) return;
    setState(() {
      _isLoading = true;
      _locations = [];
    });
    
    try {
      List<Location> locations = await locationFromAddress(_controller.text);
      setState(() => _locations = locations);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not find location: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Where to?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Flexible(
                child: SizedBox(
                  height: 200, // Limit height
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      if (_controller.text.isNotEmpty)
                        ListTile(
                          leading: const Icon(Icons.search),
                          title: Text('Search for "${_controller.text}"'),
                          onTap: () {
                            widget.onSearch(query: _controller.text);
                            Navigator.pop(context);
                          },
                        ),
                      ..._locations.map((loc) {
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          title: Text(_controller.text),
                          subtitle: Text(
                            '${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}',
                          ),
                          onTap: () {
                            widget.onSearch(
                              lat: loc.latitude,
                              lng: loc.longitude,
                              query: _controller.text,
                            );
                            Navigator.pop(context);
                          },
                        );
                      }),
                      if (_locations.isEmpty &&
                          _controller.text.isNotEmpty &&
                          !_isLoading)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'No location results found',
                            style: TextStyle(color: Colors.grey),
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
