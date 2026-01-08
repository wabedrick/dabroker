import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/features/professionals/repositories/professional_repository.dart';
import 'package:broker_app/features/professionals/screens/professional_portfolio_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final portfolioProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.watch(professionalRepositoryProvider);
  return repository.getPortfolio();
});

class ProfessionalPortfolioScreen extends ConsumerWidget {
  const ProfessionalPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAsync = ref.watch(portfolioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Portfolio'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfessionalPortfolioFormScreen(),
            ),
          ).then((_) => ref.invalidate(portfolioProvider));
        },
        child: const Icon(Icons.add),
      ),
      body: portfolioAsync.when(
        data: (portfolio) {
          if (portfolio.isEmpty) {
            return const Center(child: Text('No portfolio items yet.'));
          }
          return ListView.builder(
            itemCount: portfolio.length,
            itemBuilder: (context, index) {
              final item = portfolio[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: item['media'] != null && (item['media'] as List).isNotEmpty
                      ? Image.network(
                          item['media'][0]['original_url'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 50),
                  title: Text(item['title'] ?? 'Untitled'),
                  subtitle: Text(item['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.primaryBlue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfessionalPortfolioFormScreen(portfolioItem: item),
                            ),
                          ).then((_) => ref.invalidate(portfolioProvider));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Item'),
                              content: const Text('Are you sure you want to delete this item?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await ref.read(professionalRepositoryProvider).deletePortfolioItem(item['id']);
                              ref.invalidate(portfolioProvider);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error deleting item: $e')),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
