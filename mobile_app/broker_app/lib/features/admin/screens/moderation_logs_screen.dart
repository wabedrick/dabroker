import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:broker_app/features/admin/models/moderation_log.dart';
import 'package:broker_app/features/admin/providers/moderation_logs_provider.dart';

class ModerationLogsScreen extends ConsumerWidget {
  const ModerationLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moderationLogsNotifierProvider);
    final notifier = ref.read(moderationLogsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderation Logs'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: state.isLoading ? null : notifier.refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.logs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null && state.logs.isEmpty) {
              return _ErrorView(
                message: state.error!,
                onRetry: notifier.refresh,
              );
            }

            if (state.logs.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _LogsFilterPanel(state: state, notifier: notifier),
                  const SizedBox(height: 16),
                  const _EmptyState(),
                ],
              );
            }

            final hasLoader = state.hasMore;
            final itemCount = 1 + state.logs.length + (hasLoader ? 1 : 0);

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _LogsFilterPanel(state: state, notifier: notifier);
                }

                final logIndex = index - 1;

                if (hasLoader && logIndex == state.logs.length) {
                  notifier.fetchPage();
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final log = state.logs[logIndex];
                return _ModerationLogTile(log: log);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: itemCount,
            );
          },
        ),
      ),
    );
  }
}

class _LogsFilterPanel extends StatelessWidget {
  const _LogsFilterPanel({required this.state, required this.notifier});

  final ModerationLogsState state;
  final ModerationLogsNotifier notifier;

  static const _entityOptions = [
    (label: 'All entities', value: 'all'),
    (label: 'Properties', value: 'property'),
    (label: 'Lodgings', value: 'lodging'),
    (label: 'Users', value: 'user'),
  ];

  static const _actionOptions = [
    (label: 'All actions', value: 'all'),
    (label: 'Property approved', value: 'property_approved'),
    (label: 'Property rejected', value: 'property_rejected'),
    (label: 'Lodging approved', value: 'lodging_approved'),
    (label: 'Lodging rejected', value: 'lodging_rejected'),
    (label: 'User banned', value: 'user_banned'),
    (label: 'User activated', value: 'user_activated'),
    (label: 'User status updated', value: 'user_status_updated'),
    (label: 'User roles updated', value: 'user_roles_updated'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entityValue = state.filter.entityType ?? 'all';
    final actionValue = state.filter.action ?? 'all';
    final dateLabel = _buildDateLabel();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: theme.textTheme.titleMedium),
              if (state.filter.isActive)
                TextButton.icon(
                  onPressed: state.isLoading
                      ? null
                      : () => notifier.clearFilters(),
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text('Clear filters'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: entityValue,
                  decoration: const InputDecoration(labelText: 'Entity'),
                  items: _entityOptions
                      .map(
                        (opt) => DropdownMenuItem<String>(
                          value: opt.value,
                          child: Text(
                            opt.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: state.isLoading
                      ? null
                      : (value) {
                          if (value == null) return;
                          notifier.applyFilter(
                            state.filter.copyWith(
                              entityType: value == 'all' ? null : value,
                              clearEntity: value == 'all',
                            ),
                          );
                        },
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: actionValue,
                  decoration: const InputDecoration(labelText: 'Action'),
                  items: _actionOptions
                      .map(
                        (opt) => DropdownMenuItem<String>(
                          value: opt.value,
                          child: Text(
                            opt.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: state.isLoading
                      ? null
                      : (value) {
                          if (value == null) return;
                          notifier.applyFilter(
                            state.filter.copyWith(
                              action: value == 'all' ? null : value,
                              clearAction: value == 'all',
                            ),
                          );
                        },
                ),
              ),
              OutlinedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () => _pickDateRange(context),
                icon: const Icon(Icons.date_range),
                label: Text(dateLabel),
              ),
              if (state.filter.dateFrom != null || state.filter.dateTo != null)
                IconButton(
                  tooltip: 'Clear date range',
                  onPressed: state.isLoading
                      ? null
                      : () => notifier.applyFilter(
                          state.filter.copyWith(
                            clearDateFrom: true,
                            clearDateTo: true,
                          ),
                        ),
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildDateLabel() {
    if (state.filter.dateFrom == null || state.filter.dateTo == null) {
      return 'Date range';
    }

    final formatter = DateFormat('MMM d, y');
    return '${formatter.format(state.filter.dateFrom!)} – ${formatter.format(state.filter.dateTo!)}';
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final initialRange =
        (state.filter.dateFrom != null && state.filter.dateTo != null)
        ? DateTimeRange(
            start: state.filter.dateFrom!,
            end: state.filter.dateTo!,
          )
        : null;

    final today = DateTime.now();
    final firstDate = DateTime(today.year - 5);

    final range = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: today,
      initialDateRange: initialRange,
    );

    if (range == null) return;

    await notifier.applyFilter(
      state.filter.copyWith(dateFrom: range.start, dateTo: range.end),
    );
  }
}

class _ModerationLogTile extends StatelessWidget {
  const _ModerationLogTile({required this.log});

  final ModerationLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('MMM d, y • h:mm a');
    final subtitle = _buildSubtitle();

    return InkWell(
      onTap: () => _showDetails(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: const Icon(Icons.gavel, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    log.action.replaceAll('_', ' '),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatter.format(log.createdAt.toLocal()),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: theme.textTheme.bodyMedium),
            if (log.reason != null) ...[
              const SizedBox(height: 8),
              Text(
                'Reason: ${log.reason}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final buffer = StringBuffer(log.entity.type);
    if (log.entity.publicId != null) {
      buffer.write(' • ${log.entity.publicId}');
    }
    if (log.previousStatus != null || log.newStatus != null) {
      buffer.write(' • ');
      buffer.write(log.previousStatus ?? 'unknown');
      buffer.write(' → ');
      buffer.write(log.newStatus ?? 'unknown');
    }
    return buffer.toString();
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ModerationLogDetail(log: log),
    );
  }
}

class _ModerationLogDetail extends StatelessWidget {
  const _ModerationLogDetail({required this.log});

  final ModerationLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('MMM d, y h:mm a');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  log.action.replaceAll('_', ' '),
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  formatter.format(log.createdAt.toLocal()),
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                _DetailSection(
                  title: 'Entity',
                  content:
                      '${log.entity.type} (${log.entity.publicId ?? 'n/a'})',
                ),
                if (log.reason != null)
                  _DetailSection(title: 'Reason', content: log.reason!),
                _DetailSection(
                  title: 'Status change',
                  content:
                      '${log.previousStatus ?? 'unknown'} → ${log.newStatus ?? 'unknown'}',
                ),
                _JsonSection(title: 'Old values', data: log.oldValues),
                _JsonSection(title: 'New values', data: log.newValues),
                _DetailSection(
                  title: 'Performed by',
                  content: log.performedBy?.name ?? 'System',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(content, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _JsonSection extends StatelessWidget {
  const _JsonSection({required this.title, required this.data});

  final String title;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final theme = Theme.of(context);

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('${entry.key}: ${entry.value}'),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Failed to load logs',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 48),
            const SizedBox(height: 12),
            Text(
              'No moderation activity yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
