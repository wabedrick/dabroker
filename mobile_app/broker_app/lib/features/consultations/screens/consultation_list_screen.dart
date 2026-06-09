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
    final colorScheme = Theme.of(context).colorScheme;

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
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No consultations scheduled',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(consultationListProvider.notifier).loadConsultations(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: consultations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final consultation = consultations[index];
                final isMeProfessional =
                    currentUser?.id == consultation.professionalId;
                final otherParty = isMeProfessional
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
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
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

  ({Color bg, Color fg, Color border}) _statusColors(
    ColorScheme scheme,
    String status,
  ) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return (
          bg: scheme.tertiaryContainer,
          fg: scheme.onTertiaryContainer,
          border: scheme.tertiary,
        );
      case 'pending':
        return (
          bg: scheme.secondaryContainer,
          fg: scheme.onSecondaryContainer,
          border: scheme.secondary,
        );
      case 'cancelled':
      case 'rejected':
        return (
          bg: scheme.errorContainer,
          fg: scheme.onErrorContainer,
          border: scheme.error,
        );
      case 'completed':
        return (
          bg: scheme.primaryContainer,
          fg: scheme.onPrimaryContainer,
          border: scheme.primary,
        );
      default:
        return (
          bg: scheme.surfaceContainerHighest,
          fg: scheme.onSurfaceVariant,
          border: scheme.outlineVariant,
        );
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Consultation $status')));
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
    final colorScheme = Theme.of(context).colorScheme;
    final statusColors = _statusColors(colorScheme, consultation.status);
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
                    color: statusColors.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColors.border),
                  ),
                  child: Text(
                    consultation.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColors.fg,
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
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    otherPartyName.isNotEmpty
                        ? otherPartyName[0].toUpperCase()
                        : '?',
                    style: TextStyle(color: colorScheme.onPrimaryContainer),
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
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
                    onPressed: () => _updateStatus(context, ref, 'rejected'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error),
                    ),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _updateStatus(context, ref, 'confirmed'),
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
                    onPressed: () => _updateStatus(context, ref, 'completed'),
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
