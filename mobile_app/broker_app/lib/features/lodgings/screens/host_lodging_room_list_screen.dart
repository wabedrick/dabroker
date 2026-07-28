import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/data/models/lodging_room.dart';
import 'package:broker_app/features/lodgings/providers/lodging_management_provider.dart';
import 'package:broker_app/features/lodgings/repositories/lodging_repository.dart';
import 'package:broker_app/features/lodgings/providers/lodging_list_provider.dart';

class HostLodgingRoomListScreen extends ConsumerStatefulWidget {
  final Lodging lodging;

  const HostLodgingRoomListScreen({super.key, required this.lodging});

  @override
  ConsumerState<HostLodgingRoomListScreen> createState() => _HostLodgingRoomListScreenState();
}

class _HostLodgingRoomListScreenState extends ConsumerState<HostLodgingRoomListScreen> {
  bool _isLoading = true;
  List<LodgingRoom> _rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(lodgingRepositoryProvider);
      final rooms = await repository.fetchHostLodgingRooms(widget.lodging.id);
      if (mounted) {
        setState(() {
          _rooms = rooms;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load rooms: $e')),
        );
      }
    }
  }

  Future<void> _deleteRoom(LodgingRoom room) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Room'),
        content: Text('Are you sure you want to delete ${room.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final notifier = ref.read(lodgingManagementProvider.notifier);
      await notifier.deleteLodgingRoom(widget.lodging.id, room.id);
      await _loadRooms();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete room: $e')),
        );
      }
    }
  }

  void _showRoomDialog({LodgingRoom? room}) {
    showDialog(
      context: context,
      builder: (context) => _RoomDialog(
        lodging: widget.lodging,
        room: room,
        onSaved: _loadRooms,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms - ${widget.lodging.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showRoomDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.meeting_room, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('No rooms added yet'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showRoomDialog(),
                        child: const Text('Add First Room'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (room.media != null && room.media!.isNotEmpty)
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                image: DecorationImage(
                                  image: NetworkImage(room.media!.first.url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        room.name,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => _showRoomDialog(room: room),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _deleteRoom(room),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Price: ${room.price} ${room.currency} / night',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (room.capacity != null) ...[
                                      const Icon(Icons.person, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('Sleeps ${room.capacity}', style: const TextStyle(color: Colors.grey)),
                                      const SizedBox(width: 16),
                                    ],
                                    if (room.quantity != null) ...[
                                      const Icon(Icons.hotel, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('${room.quantity} Available', style: const TextStyle(color: Colors.grey)),
                                    ],
                                  ],
                                ),
                                if (room.description != null && room.description!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    room.description!,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class _RoomDialog extends ConsumerStatefulWidget {
  final Lodging lodging;
  final LodgingRoom? room;
  final VoidCallback onSaved;

  const _RoomDialog({
    required this.lodging,
    this.room,
    required this.onSaved,
  });

  @override
  ConsumerState<_RoomDialog> createState() => _RoomDialogState();
}

class _RoomDialogState extends ConsumerState<_RoomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _capacityController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _isLoading = false;
  File? _selectedImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.room != null) {
      _nameController.text = widget.room!.name;
      _priceController.text = widget.room!.price?.toString() ?? '';
      _capacityController.text = widget.room!.capacity?.toString() ?? '';
      _quantityController.text = widget.room!.quantity?.toString() ?? '';
      _descriptionController.text = widget.room!.description ?? '';
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      'name': _nameController.text,
      'price': double.tryParse(_priceController.text),
      'currency': 'USD',
      'capacity': int.tryParse(_capacityController.text),
      'quantity': int.tryParse(_quantityController.text),
      'description': _descriptionController.text,
    };

    try {
      final notifier = ref.read(lodgingManagementProvider.notifier);
      final images = _selectedImage != null ? [_selectedImage!] : <File>[];

      bool success;
      if (widget.room == null) {
        success = await notifier.createLodgingRoom(
          widget.lodging.id,
          data,
          images: images,
        );
      } else {
        success = await notifier.updateLodgingRoom(
          widget.lodging.id,
          widget.room!.id,
          data,
          newImages: images,
        );
      }

      if (success && mounted) {
        Navigator.pop(context);
        widget.onSaved();
      } else if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save room')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving room: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.room == null ? 'Add Room' : 'Edit Room',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : widget.room?.media != null && widget.room!.media!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(widget.room!.media!.first.url),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: _selectedImage == null && 
                           (widget.room?.media == null || widget.room!.media!.isEmpty)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text('Add Photo', style: TextStyle(color: Colors.grey[600])),
                            ],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Room Name',
                    hintText: 'e.g. Deluxe Double Room',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price per night',
                          prefixText: '\$ ',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          hintText: 'Number of these rooms',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacity (Guests)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(widget.room == null ? 'Add Room' : 'Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
