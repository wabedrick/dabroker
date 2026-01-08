import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/data/models/consultation.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/consultations/providers/consultation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ConsultationListScreen extends ConsumerWidget {
  const ConsultationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(consultationListProvider);
    final currentUser = ref.watch(authStateProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Consultations')),
      body: state.when(
        data: (consultations) {
          if (consultations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No consultations scheduled',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref
                .read(consultationListProvider.notifier)
                .loadConsultations(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: consultations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final consultation = consultations[index];
                final isMeProfessional =
                    currentUser?.id == consultation.professionalId;
                final otherParty =
                    isMeProfessional
                        ? consultation.user
                        : consultation.professional;

                return _ConsultationCard(
                  consultation: consultation,
                  otherPartyName: otherParty?.name ?? 'Unknown',
                  isMeProfessional: isMeProfessional,
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text('Error: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => ref
                            .read(consultationListProvider.notifier)
                            .loadConsultations(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

class _ConsultationCard extends ConsumerWidget {
  final Consultation consultation;
  final String otherPartyName;
  final bool isMeProfessional;

  const _ConsultationCard({
    required this.consultation,
    required this.otherPartyName,
    required this.isMeProfessional,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    String status,
  ) async {
    try {
      await ref
          .read(consultationListProvider.notifier)
          .updateStatus(consultation.publicId, status);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Consultation $status')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor(consultation.status);
    final dateFormat = DateFormat('MMM d, y • h:mm a');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    consultation.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  dateFormat.format(consultation.scheduledAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                  child: Text(
                    otherPartyName.isNotEmpty
                        ? otherPartyName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: AppColors.primaryBlue),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMeProfessional
                            ? 'Client: $otherPartyName'
                            : 'Professional: $otherPartyName',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (consultation.notes != null &&
                          consultation.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          consultation.notes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (isMeProfessional && consultation.status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed:
                        () => _updateStatus(context, ref, 'rejected'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed:
                        () => _updateStatus(context, ref, 'confirmed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
            if (isMeProfessional && consultation.status == 'confirmed') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed:
                        () => _updateStatus(context, ref, 'completed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Mark Completed'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
