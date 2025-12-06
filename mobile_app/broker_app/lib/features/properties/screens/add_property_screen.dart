import 'dart:io';

import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/core/widgets/location_picker_screen.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/features/properties/providers/property_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class AddPropertyScreen extends ConsumerStatefulWidget {
  const AddPropertyScreen({super.key, this.property});

  final Property? property;

  @override
  ConsumerState<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends ConsumerState<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  // State
  String _type = 'house';
  String _category = 'sale';
  String _currency = 'USD';
  final List<File> _selectedImages = [];
  final List<PropertyMedia> _existingImages = [];
  final List<String> _deletedImageIds = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      final p = widget.property!;
      _titleController.text = p.title;
      _priceController.text = p.price?.toString() ?? '';
      _descriptionController.text = p.description ?? '';
      _addressController.text = p.address ?? '';
      _cityController.text = p.city ?? '';
      _countryController.text = p.country ?? '';
      _latitudeController.text = p.latitude?.toString() ?? '';
      _longitudeController.text = p.longitude?.toString() ?? '';
      _type = p.type ?? 'house';
      _category = p.category ?? 'sale';
      _currency = p.currency ?? 'USD';
      if (p.gallery != null) {
        _existingImages.addAll(p.gallery!);
      }
    }
  }

  double? _parsePrice(String value) {
    value = value.trim().toUpperCase();
    if (value.isEmpty) return null;

    double multiplier = 1.0;
    if (value.endsWith('K')) {
      multiplier = 1000.0;
      value = value.substring(0, value.length - 1);
    } else if (value.endsWith('M')) {
      multiplier = 1000000.0;
      value = value.substring(0, value.length - 1);
    } else if (value.endsWith('B')) {
      multiplier = 1000000000.0;
      value = value.substring(0, value.length - 1);
    }

    final number = double.tryParse(value);
    if (number == null) return null;
    return number * multiplier;
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      final image = _existingImages.removeAt(index);
      _deletedImageIds.add(image.id);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Location services are disabled.'),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () => Geolocator.openLocationSettings(),
              ),
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location permissions are permanently denied, we cannot request permissions.',
              ),
            ),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    }
  }

  Future<void> _pickLocationOnMap() async {
    final double? lat = double.tryParse(_latitudeController.text);
    final double? lng = double.tryParse(_longitudeController.text);

    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LocationPickerScreen(
              initialLatitude: lat,
              initialLongitude: lng,
            ),
      ),
    );

    if (result != null) {
      setState(() {
        _latitudeController.text = result.latitude.toString();
        _longitudeController.text = result.longitude.toString();
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'title': _titleController.text,
      'type': _type,
      'category': _category,
      'currency': _currency,
      'price': _parsePrice(_priceController.text),
      'description': _descriptionController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'country': _countryController.text,
      'latitude': double.tryParse(_latitudeController.text),
      'longitude': double.tryParse(_longitudeController.text),
      // Defaults or empty for now
      'amenities': [],
    };

    final notifier = ref.read(propertyManagementProvider.notifier);
    final bool success;

    if (widget.property != null) {
      success = await notifier.updateProperty(
        widget.property!.id,
        data,
        newImages: _selectedImages,
        deletedImageIds: _deletedImageIds,
      );
    } else {
      success = await notifier.createProperty(data, images: _selectedImages);
    }

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.property != null
                ? 'Property updated successfully'
                : 'Property created successfully',
          ),
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      final error = ref.read(propertyManagementProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save property: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertyManagementProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property != null ? 'Edit Property' : 'Add Property'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title *'),
              validator: (v) => v?.isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Property Type *'),
              items: const [
                DropdownMenuItem(value: 'house', child: Text('House')),
                DropdownMenuItem(value: 'land', child: Text('Land')),
                DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
                DropdownMenuItem(
                  value: 'commercial',
                  child: Text('Commercial'),
                ),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Listing Type *'),
              items: const [
                DropdownMenuItem(value: 'sale', child: Text('For Sale')),
                DropdownMenuItem(value: 'rent', child: Text('For Rent')),
              ],
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),

            // Image Picker Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Images',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._existingImages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final image = entry.value;
                      return Stack(
                        children: [
                          Image.network(
                            ImageHelper.fixUrl(image.thumbnailUrl ?? image.url),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => _removeExistingImage(index),
                              child: Container(
                                color: Colors.black54,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    ..._selectedImages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final file = entry.value;
                      return Stack(
                        children: [
                          Image.file(
                            file,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                color: Colors.black54,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    InkWell(
                      onTap: _pickImages,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    initialValue: _currency,
                    decoration: const InputDecoration(labelText: 'Currency *'),
                    items: const [
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'UGX', child: Text('UGX')),
                    ],
                    onChanged: (v) => setState(() => _currency = v!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      hintText: 'e.g. 2M, 500K',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (v) {
                      if (v == null || v.isEmpty) return null;
                      if (_parsePrice(v) == null) {
                        return 'Invalid format (use K, M, B)';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City *'),
              validator: (v) => v?.isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: 'Country *'),
              validator: (v) => v?.isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latitudeController,
                    decoration: const InputDecoration(labelText: 'Latitude'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _longitudeController,
                    decoration: const InputDecoration(labelText: 'Longitude'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _getCurrentLocation,
                  tooltip: 'Use Current Location',
                ),
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: _pickLocationOnMap,
                  tooltip: 'Pick on Map',
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.property != null
                          ? 'Update Property'
                          : 'Create Property',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
