import 'dart:io';

import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/professionals/repositories/professional_repository.dart';
import 'package:broker_app/features/professionals/screens/professional_portfolio_screen.dart';
import 'package:broker_app/features/professionals/widgets/certification_list_editor.dart';
import 'package:broker_app/features/professionals/widgets/education_list_editor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfessionalProfileScreen extends ConsumerStatefulWidget {
  const ProfessionalProfileScreen({super.key});

  @override
  ConsumerState<ProfessionalProfileScreen> createState() =>
      _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState
    extends ConsumerState<ProfessionalProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _hourlyRateController;
  late TextEditingController _licenseController;
  late TextEditingController _specialtiesController;
  late TextEditingController _languagesController;
  late TextEditingController _experienceController;
  late TextEditingController _linkedinController;
  late TextEditingController _websiteController;
  List<Map<String, dynamic>> _education = [];
  List<Map<String, dynamic>> _certifications = [];
  bool _isAvailable = true;
  bool _isLoading = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Defer state initialization to allow context access if needed,
    // but mainly to ensure we have the latest data.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final user = ref.read(authStateProvider).user;
    if (user == null) return;

    final profile = user.professionalProfile;

    setState(() {
      _nameController = TextEditingController(text: user.name);
      _phoneController = TextEditingController(text: user.phone ?? '');
      _bioController = TextEditingController(text: profile?.bio ?? '');
      _hourlyRateController = TextEditingController(
        text: profile?.hourlyRate?.toString() ?? '',
      );
      _licenseController = TextEditingController(
        text: profile?.licenseNumber ?? '',
      );
      _specialtiesController = TextEditingController(
        text: profile?.specialties?.join(', ') ?? '',
      );
      _languagesController = TextEditingController(
        text: profile?.languages?.join(', ') ?? '',
      );
      _experienceController = TextEditingController(
        text: profile?.experienceYears?.toString() ?? '',
      );
      _linkedinController = TextEditingController(
        text: profile?.socialLinks?['linkedin'] ?? '',
      );
      _websiteController = TextEditingController(
        text: profile?.socialLinks?['website'] ?? '',
      );
      _education = List.from(profile?.education ?? []);
      _certifications = List.from(profile?.certifications ?? []);
      _isAvailable = profile?.isAvailable ?? true;
    });

    // If profile is missing but user is a professional, try to refresh
    if (profile == null && user.roles.contains('real_estate_agent')) {
      ref.read(authStateProvider.notifier).refreshProfile().then((_) {
        if (mounted) {
          _loadUserData(); // Reload after refresh
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _hourlyRateController.dispose();
    _licenseController.dispose();
    _specialtiesController.dispose();
    _languagesController.dispose();
    _experienceController.dispose();
    _linkedinController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final specialties = _specialtiesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final languages = _languagesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final Map<String, dynamic> data = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'bio': _bioController.text,
        'hourly_rate': double.parse(_hourlyRateController.text),
        'license_number': _licenseController.text,
        'specialties': specialties,
        'languages': languages,
        'experience_years': int.tryParse(_experienceController.text),
        'social_links': {
          'linkedin': _linkedinController.text,
          'website': _websiteController.text,
        },
        'education': _education,
        'certifications': _certifications,
        'is_available': _isAvailable,
      };

      if (_imageFile != null) {
        data['avatar'] = await MultipartFile.fromFile(_imageFile!.path);
      }

      await ref.read(professionalRepositoryProvider).updateProfile(data);

      // Refresh user profile
      await ref.read(authStateProvider.notifier).refreshProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Professional Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (user?.avatar?.isNotEmpty == true
                                    ? NetworkImage(user!.avatar!)
                                    : null)
                                as ImageProvider?,
                      child:
                          _imageFile == null &&
                              (user?.avatar == null || user!.avatar!.isEmpty)
                          ? Text(
                              (user?.name ?? 'U')[0].toUpperCase(),
                              style: const TextStyle(fontSize: 40),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildAvailabilitySwitch(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfessionalPortfolioScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Manage Portfolio'),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Phone number is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _licenseController,
                decoration: const InputDecoration(
                  labelText: 'License Number',
                  helperText: 'Changing this may require re-verification',
                ),
                validator: (v) => v == null || v.isEmpty
                    ? 'License number is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hourlyRateController,
                decoration: const InputDecoration(
                  labelText: 'Hourly Rate (\$)',
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Hourly rate is required';
                  if (double.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: 'Years of Experience',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialtiesController,
                decoration: const InputDecoration(
                  labelText: 'Specialties',
                  helperText: 'Comma separated (e.g. Residential, Commercial)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _languagesController,
                decoration: const InputDecoration(
                  labelText: 'Languages',
                  helperText: 'Comma separated (e.g. English, Spanish)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Bio is required' : null,
              ),
              const SizedBox(height: 24),
              EducationListEditor(
                initialEducation: _education,
                onChanged: (edu) => _education = edu,
              ),
              const SizedBox(height: 24),
              CertificationListEditor(
                initialCertifications: _certifications,
                onChanged: (certs) => _certifications = certs,
              ),
              const SizedBox(height: 24),
              const Text('Social Links', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _linkedinController,
                decoration: const InputDecoration(
                  labelText: 'LinkedIn URL',
                  prefixIcon: Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website URL',
                  prefixIcon: Icon(Icons.language),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailabilitySwitch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available for Consultations',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isAvailable
                      ? 'You are currently visible to clients'
                      : 'You are currently hidden from clients',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: _isAvailable,
            onChanged: (value) => setState(() => _isAvailable = value),
            activeTrackColor: AppColors.success,
          ),
        ],
      ),
    );
  }
}
