import 'dart:io';

import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/features/professionals/repositories/professional_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfessionalPortfolioFormScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? portfolioItem;

  const ProfessionalPortfolioFormScreen({super.key, this.portfolioItem});

  @override
  ConsumerState<ProfessionalPortfolioFormScreen> createState() => _ProfessionalPortfolioFormScreenState();
}

class _ProfessionalPortfolioFormScreenState extends ConsumerState<ProfessionalPortfolioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;
  DateTime? _projectDate;
  final List<File> _newImages = [];
  final List<dynamic> _existingImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.portfolioItem?['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.portfolioItem?['description'] ?? '');
    _urlController = TextEditingController(text: widget.portfolioItem?['url'] ?? '');
    if (widget.portfolioItem?['project_date'] != null) {
      _projectDate = DateTime.tryParse(widget.portfolioItem!['project_date']);
    }
    if (widget.portfolioItem?['media'] != null) {
      _existingImages.addAll(widget.portfolioItem!['media']);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _newImages.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> data = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'url': _urlController.text,
        if (_projectDate != null) 'project_date': DateFormat('yyyy-MM-dd').format(_projectDate!),
      };

      if (_newImages.isNotEmpty) {
        data['images'] = _newImages.map((file) => MultipartFile.fromFileSync(file.path)).toList();
      }

      if (widget.portfolioItem == null) {
        await ref.read(professionalRepositoryProvider).addPortfolioItem(data);
      } else {
        // For now, we don't handle deleting individual existing images in this simple form,
        // but we could add a list of IDs to delete.
        await ref.read(professionalRepositoryProvider).updatePortfolioItem(widget.portfolioItem!['id'], data);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving portfolio: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.portfolioItem == null ? 'Add Portfolio Item' : 'Edit Portfolio Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'Project URL (Optional)'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_projectDate == null
                  ? 'Select Project Date'
                  : 'Date: ${DateFormat('yyyy-MM-dd').format(_projectDate!)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _projectDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _projectDate = date;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._existingImages.map((img) => Stack(
                      children: [
                        Image.network(
                          img['original_url'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        // Add delete button for existing images if needed
                      ],
                    )),
                ..._newImages.map((file) => Stack(
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
                            onTap: () {
                              setState(() {
                                _newImages.remove(file);
                              });
                            },
                            child: const Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ],
                    )),
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save Portfolio Item'),
            ),
          ],
        ),
      ),
    );
  }
}
