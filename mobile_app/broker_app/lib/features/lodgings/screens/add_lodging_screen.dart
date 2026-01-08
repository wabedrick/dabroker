import 'dart:io';

import 'package:broker_app/core/widgets/location_picker_screen.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/features/lodgings/providers/lodging_management_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class AddLodgingScreen extends ConsumerStatefulWidget {
  const AddLodgingScreen({super.key, this.lodging});

  final Lodging? lodging;

  @override
  ConsumerState<AddLodgingScreen> createState() => _AddLodgingScreenState();
}

class _AddLodgingScreenState extends ConsumerState<AddLodgingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _maxGuestsController = TextEditingController();
  final _totalRoomsController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  // State
  String _type = 'hotel';
  String _currency = 'USD';
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.lodging != null) {
      final l = widget.lodging!;
      _titleController.text = l.title;
      _priceController.text = l.pricePerNight?.toString() ?? '';
      _descriptionController.text = l.description ?? '';
      _addressController.text = l.address ?? '';
      _cityController.text = l.city ?? '';
      _countryController.text = l.country ?? '';
      _maxGuestsController.text = l.maxGuests?.toString() ?? '';
      _totalRoomsController.text = l.totalRooms?.toString() ?? '1';
      _latitudeController.text = l.latitude?.toString() ?? '';
      _longitudeController.text = l.longitude?.toString() ?? '';
      _type = l.type ?? 'hotel';
      _currency = l.currency ?? 'USD';
    } else {
      _totalRoomsController.text = '1';
    }
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

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _maxGuestsController.dispose();
    _totalRoomsController.dispose();
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
        builder: (context) =>
            LocationPickerScreen(initialLatitude: lat, initialLongitude: lng),
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
      'currency': _currency,
      'price_per_night': double.tryParse(_priceController.text),
      'max_guests': int.tryParse(_maxGuestsController.text),
      'total_rooms': int.tryParse(_totalRoomsController.text),
      'description': _descriptionController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'country': _countryController.text,
      'latitude': double.tryParse(_latitudeController.text),
      'longitude': double.tryParse(_longitudeController.text),
      'amenities': [],
    };

    final notifier = ref.read(lodgingManagementProvider.notifier);
    bool success;

    if (widget.lodging != null) {
      success = await notifier.updateLodging(
        widget.lodging!.id,
        data,
        newImages: _selectedImages,
      );
    } else {
      success = await notifier.createLodging(data, images: _selectedImages);
    }

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.lodging != null
                ? 'Lodging updated successfully'
                : 'Lodging created successfully',
          ),
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      final error = ref.read(lodgingManagementProvider).error;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save lodging: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lodgingManagementProvider);
    final isLoading = state.isLoading;
    final isEditing = widget.lodging != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Lodging' : 'Add Lodging')),
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
              decoration: const InputDecoration(labelText: 'Type *'),
              items: const [
                DropdownMenuItem(value: 'hotel', child: Text('Hotel')),
                DropdownMenuItem(
                  value: 'guest_house',
                  child: Text('Guest House'),
                ),
                DropdownMenuItem(value: 'lodge', child: Text('Lodge')),
                DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
                DropdownMenuItem(value: 'resort', child: Text('Resort')),
              ],
              onChanged: (v) => setState(() => _type = v!),
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
                      labelText: 'Price per Night',
                      hintText: 'e.g. 100',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _maxGuestsController,
                    decoration: const InputDecoration(
                      labelText: 'Max Guests (per room)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _totalRoomsController,
                    decoration: const InputDecoration(
                      labelText: 'Number of Rooms *',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
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
                  : Text(isEditing ? 'Update Lodging' : 'Create Lodging'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
