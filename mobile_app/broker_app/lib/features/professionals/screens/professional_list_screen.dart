import 'package:broker_app/data/models/user.dart';
import 'package:broker_app/features/professionals/providers/professional_provider.dart';
import 'package:broker_app/features/professionals/screens/professional_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfessionalListScreen extends ConsumerStatefulWidget {
  const ProfessionalListScreen({super.key});

  @override
  ConsumerState<ProfessionalListScreen> createState() =>
      _ProfessionalListScreenState();
}

class _ProfessionalListScreenState
    extends ConsumerState<ProfessionalListScreen> {
  final _scrollController = ScrollController();
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(professionalListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(professionalListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Find Professionals')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _selectedType == null,
                  onSelected: (_) {
                    setState(() => _selectedType = null);
                    ref
                        .read(professionalListProvider.notifier)
                        .filterByType(null);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Brokers',
                  isSelected: _selectedType == 'broker',
                  onSelected: (_) {
                    setState(() => _selectedType = 'broker');
                    ref
                        .read(professionalListProvider.notifier)
                        .filterByType('broker');
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Surveyors',
                  isSelected: _selectedType == 'surveyor',
                  onSelected: (_) {
                    setState(() => _selectedType = 'surveyor');
                    ref
                        .read(professionalListProvider.notifier)
                        .filterByType('surveyor');
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Lawyers',
                  isSelected: _selectedType == 'lawyer',
                  onSelected: (_) {
                    setState(() => _selectedType = 'lawyer');
                    ref
                        .read(professionalListProvider.notifier)
                        .filterByType('lawyer');
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Agents',
                  isSelected: _selectedType == 'real_estate_agent',
                  onSelected: (_) {
                    setState(() => _selectedType = 'real_estate_agent');
                    ref
                        .read(professionalListProvider.notifier)
                        .filterByType('real_estate_agent');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: state.when(
              data: (professionals) {
                if (professionals.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => ref
                        .read(professionalListProvider.notifier)
                        .loadProfessionals(
                          refresh: true,
                          type: _selectedType,
                          showLoading: false,
                        ),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: const Center(
                            child: Text('No professionals found'),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref
                      .read(professionalListProvider.notifier)
                      .loadProfessionals(
                        refresh: true,
                        type: _selectedType,
                        showLoading: false,
                      ),
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: professionals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final professional = professionals[index];
                      return _ProfessionalCard(professional: professional);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        ),
      ),
      showCheckmark: false,
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  final User professional;

  const _ProfessionalCard({required this.professional});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ProfessionalDetailScreen(professional: professional),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  professional.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      professional.professionalProfile?.specialties?.join(
                            ', ',
                          ) ??
                          professional.preferredRole.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (professional.professionalProfile != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '\$${professional.professionalProfile!.hourlyRate}/hr',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
