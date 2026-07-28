import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/features/properties/providers/owner_property_provider.dart';
import 'package:broker_app/features/properties/screens/add_property_screen.dart';
import 'package:broker_app/features/properties/screens/manage_rooms_screen.dart';
import 'package:broker_app/features/properties/screens/property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OwnerPropertyListScreen extends ConsumerStatefulWidget {
  const OwnerPropertyListScreen({super.key});

  @override
  ConsumerState<OwnerPropertyListScreen> createState() =>
      _OwnerPropertyListScreenState();
}

class _OwnerPropertyListScreenState
    extends ConsumerState<OwnerPropertyListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Properties'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _OwnerPropertyList(status: null),
          _OwnerPropertyList(status: 'pending'),
          _OwnerPropertyList(status: 'approved'),
          _OwnerPropertyList(status: 'rejected'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPropertyScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _OwnerPropertyList extends ConsumerWidget {
  const _OwnerPropertyList({this.status});

  final String? status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ownerPropertiesProvider(status));

    return state.when(
      data: (properties) {
        if (properties.isEmpty) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(ownerPropertiesProvider(status).notifier).refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_work_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(90),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No properties found',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(ownerPropertiesProvider(status).notifier).refresh(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return _OwnerPropertyTile(property: property, status: status)
                  .animate(delay: (index * 50).ms)
                  .fade(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
            },
          ),
        );
      },
      error: (e, s) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(ownerPropertiesProvider(status).notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _OwnerPropertyTile extends ConsumerWidget {
  const _OwnerPropertyTile({required this.property, this.status});

  final Property property;
  final String? status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = property.gallery?.isNotEmpty == true
        ? (property.gallery!.first.thumbnailUrl ?? property.gallery!.first.url)
        : null;

    final location = [
      property.city,
      property.country,
    ].where((e) => e != null && e.isNotEmpty).join(', ');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  ImageHelper.fixUrl(imageUrl),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    );
                  },
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.home),
                ),
        ),
        title: Text(
          property.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              location.isNotEmpty ? location : 'No location',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _StatusBadge(status: property.status ?? 'draft'),
                if (property.category != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      property.category!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleAction(context, ref, value),
          itemBuilder: (context) {
            final items = <PopupMenuEntry<String>>[
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
            ];

            if (property.category == 'rent') {
              items.add(
                const PopupMenuItem(
                  value: 'rooms',
                  child: Row(
                    children: [
                      Icon(Icons.meeting_room, size: 20),
                      SizedBox(width: 8),
                      Text('Manage Rooms'),
                    ],
                  ),
                ),
              );
            }

            items.add(const PopupMenuDivider());
            items.add(
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Theme.of(context).colorScheme.error, size: 20),
                    const SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                ),
              ),
            );
            return items;
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PropertyDetailScreen(propertyId: property.id),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleAction(BuildContext context, WidgetRef ref, String action) async {
    switch (action) {
      case 'edit':
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddPropertyScreen(property: property),
          ),
        );
        ref.read(ownerPropertiesProvider(status).notifier).refresh();
        break;
      case 'rooms':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ManageRoomsScreen(property: property),
          ),
        );
        break;
      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Property'),
            content: const Text('Are you sure you want to delete this property? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );

        if (confirmed == true && context.mounted) {
          try {
            await ref.read(ownerPropertiesProvider(status).notifier).delete(property.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Property deleted successfully')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error deleting property: $e')),
              );
            }
          }
        }
        break;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = Colors.green.withAlpha(40);
        textColor = Colors.green[800]!;
        break;
      case 'pending':
        bgColor = Colors.orange.withAlpha(40);
        textColor = Colors.orange[800]!;
        break;
      case 'rejected':
        bgColor = Colors.red.withAlpha(40);
        textColor = Colors.red[800]!;
        break;
      default:
        bgColor = Colors.grey.withAlpha(40);
        textColor = Colors.grey[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
