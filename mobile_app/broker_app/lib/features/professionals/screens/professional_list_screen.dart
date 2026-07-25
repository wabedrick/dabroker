import 'package:broker_app/data/models/user.dart';
import 'package:broker_app/features/professionals/providers/professional_provider.dart';
import 'package:broker_app/features/professionals/screens/professional_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(professionalListProvider.notifier)
            .loadProfessionals(
              refresh: true,
              type: _selectedType,
              showLoading: false,
            ),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: const Text('Professionals'),
              floating: true,
              pinned: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              ),
            ),
            state.when(
              data: (professionals) {
                if (professionals.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No professionals found',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try changing your filters',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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
                    itemCount: professionals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final professional = professionals[index];
                      return _ProfessionalCard(professional: professional)
                          .animate(delay: (index * 50).ms)
                          .fade(duration: 400.ms)
                          .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
                    },
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
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
        color: isSelected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurface,
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final specialties = professional.professionalProfile?.specialties ?? [];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfessionalDetailScreen(professional: professional),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'professional_avatar_${professional.id}',
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.transparent,
                      backgroundImage: professional.avatar != null && professional.avatar!.isNotEmpty
                          ? NetworkImage(professional.avatar!)
                          : null,
                      child: professional.avatar == null || professional.avatar!.isEmpty
                          ? Text(
                              professional.name[0].toUpperCase(),
                              style: textTheme.headlineSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Hero(
                              tag: 'professional_name_${professional.id}',
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  professional.name,
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          if (professional.professionalProfile != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star_rounded, size: 16, color: Colors.amber.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    professional.averageRating.toStringAsFixed(1),
                                    style: textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        professional.formattedRole,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (specialties.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: specialties.take(3).map((s) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                                ),
                                child: Text(
                                  s,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              )).toList(),
                        ),
                      ],
                      if (professional.professionalProfile != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.payments_outlined, size: 16, color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              '\$${professional.professionalProfile!.hourlyRate ?? 0}/hr',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
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
