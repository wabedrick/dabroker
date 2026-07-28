import 'dart:io';

import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/core/widgets/location_picker_screen.dart';
import 'package:broker_app/features/properties/screens/manage_rooms_screen.dart';
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

  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _sizeController = TextEditingController();
  final _houseAgeController = TextEditingController();
  final _minLeaseController = TextEditingController();

  // State
  String _type = 'house';
  String _category = 'sale';
  String _currency = 'USD';
  String _sizeUnit = 'sqft';
  DateTime? _availableFrom;
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
      
      _bedroomsController.text = p.metadata?['bedrooms']?.toString() ?? '';
      _bathroomsController.text = p.metadata?['bathrooms']?.toString() ?? '';
      _sizeController.text = p.size?.toString() ?? '';
      _sizeUnit = p.sizeUnit ?? 'sqft';
      _houseAgeController.text = p.houseAge?.toString() ?? '';
      _minLeaseController.text = p.metadata?['min_lease_months']?.toString() ?? '';
      _availableFrom = p.availableFrom;

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
      if (image.id != null) {
        _deletedImageIds.add(image.id!);
      }
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
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _sizeController.dispose();
    _houseAgeController.dispose();
    _minLeaseController.dispose();
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

  int _currentStep = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  Future<void> _submit() async {
    // Validate final step before submission just in case
    if (!_formKeys[_currentStep].currentState!.validate()) return;

    final data = {
      'title': _titleController.text,
      'type': _type,
      'category': _category,
      'currency': _currency,
      'price': _parsePrice(_priceController.text) ?? 0,
      'description': _descriptionController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'country': _countryController.text,
      'latitude': double.tryParse(_latitudeController.text),
      'longitude': double.tryParse(_longitudeController.text),
      'amenities': [],
      'metadata': {
        if (_type != 'land' && _bedroomsController.text.isNotEmpty) 'bedrooms': int.tryParse(_bedroomsController.text),
        if (_type != 'land' && _bathroomsController.text.isNotEmpty) 'bathrooms': int.tryParse(_bathroomsController.text),
        if (_category == 'rent' && _minLeaseController.text.isNotEmpty) 'min_lease_months': int.tryParse(_minLeaseController.text),
      },
      'size': double.tryParse(_sizeController.text),
      'size_unit': _sizeUnit,
      if (_type != 'land' && _houseAgeController.text.isNotEmpty) 'house_age': int.tryParse(_houseAgeController.text),
      if (_category == 'rent' && _availableFrom != null) 'available_from': _availableFrom!.toIso8601String(),
    };

    final Property? property;
    final notifier = ref.read(propertyManagementProvider.notifier);

    if (widget.property != null) {
      property = await notifier.updateProperty(
        widget.property!.id,
        data,
        newImages: _selectedImages,
        deletedImageIds: _deletedImageIds,
      );
    } else {
      property = await notifier.createProperty(data, images: _selectedImages);
    }

    final success = property != null;

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
      if (_type == 'apartment' || _category == 'rent') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ManageRoomsScreen(property: property!),
          ),
        );
      } else {
        Navigator.pop(context);
      }
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
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            Navigator.pop(context);
          }
        },
        onStepContinue: () {
          final isLastStep = _currentStep == _getSteps().length - 1;
          if (_formKeys[_currentStep].currentState!.validate()) {
            if (isLastStep) {
              _submit();
            } else {
              setState(() => _currentStep += 1);
            }
          }
        },
        onStepTapped: (step) {
          if (_formKeys[_currentStep].currentState!.validate()) {
            setState(() => _currentStep = step);
          }
        },
        controlsBuilder: (context, details) {
          final isLastStep = _currentStep == _getSteps().length - 1;
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: isLoading ? null : details.onStepContinue,
                    child: isLoading && isLastStep
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(isLastStep ? (widget.property != null ? 'Update' : 'Submit') : 'Next'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading ? null : details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: _getSteps(),
      ),
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: const Text('Basic Details'),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeys[0],
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title *'),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Property Type *'),
                items: const [
                  DropdownMenuItem(value: 'house', child: Text('House')),
                  DropdownMenuItem(value: 'land', child: Text('Land')),
                  DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
                  DropdownMenuItem(value: 'commercial', child: Text('Commercial')),
                  DropdownMenuItem(value: 'rental', child: Text('Rental')),
                  DropdownMenuItem(value: 'hostel', child: Text('Hostel')),
                  DropdownMenuItem(value: 'bank_property', child: Text('Bank Property')),
                ],
                onChanged: (v) => setState(() => _type = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Listing Type *'),
                items: const [
                  DropdownMenuItem(value: 'sale', child: Text('For Sale')),
                  DropdownMenuItem(value: 'rent', child: Text('For Rent')),
                ],
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _currency,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Currency *', contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
                      iconSize: 20,
                      items: const [
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                        DropdownMenuItem(value: 'UGX', child: Text('UGX')),
                      ],
                      onChanged: (v) => setState(() => _currency = v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price ($_currency) ${(_type == 'apartment' || _category == 'rent') ? '(Optional if rooms have individual prices)' : '*'}',
                      ),
                      keyboardType: TextInputType.text,
                      validator: (v) {
                        if (_type == 'apartment' || _category == 'rent') {
                          if (v?.isNotEmpty == true && _parsePrice(v!) == null) {
                            return 'Invalid format';
                          }
                          return null;
                        }
                        if (v == null || v.isEmpty) return 'Required';
                        if (_parsePrice(v) == null) return 'Use format 500K, 1M';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Features & Amenities'),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeys[1],
          child: Column(
            children: [
              if (_type != 'land') ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _bedroomsController,
                        decoration: const InputDecoration(labelText: 'Bedrooms'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _bathroomsController,
                        decoration: const InputDecoration(labelText: 'Bathrooms'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _sizeController,
                      decoration: const InputDecoration(labelText: 'Size'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _sizeUnit,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Unit', contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
                      iconSize: 20,
                      items: const [
                        DropdownMenuItem(value: 'sqft', child: Text('sqft')),
                        DropdownMenuItem(value: 'sqm', child: Text('sqm')),
                        DropdownMenuItem(value: 'acres', child: Text('acres')),
                      ],
                      onChanged: (v) => setState(() => _sizeUnit = v!),
                    ),
                  ),
                ],
              ),
              if (_type != 'land') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _houseAgeController,
                  decoration: const InputDecoration(labelText: 'House Age (Years)'),
                  keyboardType: TextInputType.number,
                ),
              ],
              if (_category == 'rent') ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text('Rental Specifics', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minLeaseController,
                        decoration: const InputDecoration(labelText: 'Min Lease (Months)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _availableFrom ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                          );
                          if (date != null) {
                            setState(() => _availableFrom = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Available From'),
                          child: Text(
                            _availableFrom != null
                                ? '${_availableFrom!.year}-${_availableFrom!.month.toString().padLeft(2, '0')}-${_availableFrom!.day.toString().padLeft(2, '0')}'
                                : 'Select Date',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Location'),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeys[2],
          child: Column(
            children: [
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.my_location),
                    onPressed: _getCurrentLocation,
                    label: const Text('Current Location'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    onPressed: _pickLocationOnMap,
                    label: const Text('Pick on Map'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Media Gallery'),
        isActive: _currentStep >= 3,
        state: _currentStep == 3 ? StepState.indexed : StepState.complete,
        content: Form(
          key: _formKeys[3],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Upload photos of the property. The first photo will be the cover image.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
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
                          ImageHelper.fixUrl(image.thumbnailUrl ?? image.url ?? ''),
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
                              child: const Icon(Icons.close, color: Colors.white, size: 20),
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
                              child: const Icon(Icons.close, color: Colors.white, size: 20),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, color: Colors.grey, size: 32),
                          SizedBox(height: 8),
                          Text('Add Photo', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
