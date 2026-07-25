import 'package:broker_app/data/models/consultation.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/consultations/providers/consultation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class ConsultationListScreen extends ConsumerWidget {
  const ConsultationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(consultationListProvider);
    final currentUser = ref.watch(authStateProvider).user;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(consultationListProvider.notifier).loadConsultations(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverAppBar(
              title: Text(
                'My Consultations',
                style: TextStyle(
                  fontFamily: 'DM Serif Display',
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              floating: true,
              pinned: true,
            ),
            state.when(
              data: (consultations) {
                if (consultations.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
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
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.separated(
                    itemCount: consultations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final consultation = consultations[index];
                      final isMeProfessional = currentUser?.id == consultation.professionalId;
                      final otherParty = isMeProfessional ? consultation.user : consultation.professional;

                      return _ConsultationCard(
                        consultation: consultation,
                        otherPartyName: otherParty?.name ?? 'Unknown',
                        isMeProfessional: isMeProfessional,
                      ).animate(delay: (index * 50).ms).fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
                    },
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => SliverFillRemaining(
                child: Center(
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
            ),
          ],
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

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColors.bg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColors.border.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: statusColors.fg),
                      const SizedBox(width: 6),
                      Text(
                        consultation.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColors.fg,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(consultation.scheduledAt),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      otherPartyName.isNotEmpty ? otherPartyName[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherPartyName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isMeProfessional ? 'Client' : 'Professional',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (consultation.notes != null && consultation.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.notes, size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        consultation.notes!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (isMeProfessional && consultation.status == 'pending') ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _updateStatus(context, ref, 'rejected'),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () => _updateStatus(context, ref, 'confirmed'),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Confirm'),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
            if (isMeProfessional && consultation.status == 'confirmed') ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.icon(
                    onPressed: () => _updateStatus(context, ref, 'completed'),
                    icon: const Icon(Icons.done_all, size: 18),
                    label: const Text('Mark Completed'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.tertiary,
                      foregroundColor: colorScheme.onTertiary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
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
