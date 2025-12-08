import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/data/models/user.dart';
import 'package:broker_app/features/inquiries/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalDetailScreen extends StatelessWidget {
  final User professional;

  const ProfessionalDetailScreen({super.key, required this.professional});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: professional.email,
      query: 'subject=Consultation Inquiry',
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $emailLaunchUri');
    }
  }

  Future<void> _launchPhone() async {
    if (professional.phone == null) return;
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: professional.phone,
    );
    if (!await launchUrl(phoneLaunchUri)) {
      throw Exception('Could not launch $phoneLaunchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = professional.professionalProfile;

    return Scaffold(
      appBar: AppBar(title: const Text('Professional Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                    child: Text(
                      professional.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    professional.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      professional.preferredRole.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (profile != null) ...[
              _SectionHeader(title: 'About'),
              const SizedBox(height: 8),
              Text(
                profile.bio,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: 'Specialties'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (profile.specialties ?? []).map((specialty) {
                  return Chip(
                    label: Text(specialty),
                    backgroundColor: Colors.grey[100],
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: 'Details'),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.attach_money,
                label: 'Hourly Rate',
                value: '\$${profile.hourlyRate}/hr',
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.verified_user,
                label: 'License Number',
                value: profile.licenseNumber,
              ),
              const SizedBox(height: 24),
            ],
            _SectionHeader(title: 'Contact'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement chat with professional
                      // For now, we can reuse ChatScreen if we have an inquiry ID,
                      // but creating a new inquiry for professional is different.
                      // We might need a "start consultation" flow.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Chat feature coming soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Chat'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _launchEmail,
                    icon: const Icon(Icons.email),
                    label: const Text('Email'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
