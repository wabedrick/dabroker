// ignore: unused_import
import 'package:broker_app/data/models/property.dart';
import 'package:broker_app/features/admin/providers/admin_property_provider.dart';
import 'package:broker_app/features/properties/screens/property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/core/utils/image_helper.dart';

class AdminPropertyListScreen extends ConsumerStatefulWidget {
  const AdminPropertyListScreen({super.key});

  @override
  ConsumerState<AdminPropertyListScreen> createState() =>
      _AdminPropertyListScreenState();
}

class _AdminPropertyListScreenState
    extends ConsumerState<AdminPropertyListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Manage Properties'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _PropertyList(status: 'pending'),
          _PropertyList(status: 'approved'),
          _PropertyList(status: 'rejected'),
        ],
      ),
    );
  }
}

class _PropertyList extends ConsumerWidget {
  const _PropertyList({required this.status});

  final String status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminPropertiesProvider(status));

    return state.when(
      data: (properties) {
        if (properties.isEmpty) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(adminPropertiesProvider(status).notifier).load(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 100),
                Center(child: Text('No properties found')),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(adminPropertiesProvider(status).notifier).load(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return _AdminPropertyTile(property: property, status: status);
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
                    ref.read(adminPropertiesProvider(status).notifier).load(),
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

class _AdminPropertyTile extends ConsumerWidget {
  const _AdminPropertyTile({required this.property, required this.status});

  final Property property;
  final String status;

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
        leading: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                ImageHelper.fixUrl(imageUrl),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  );
                },
              )
            : Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Icon(Icons.home),
              ),
        title: Text(
          property.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          location.isNotEmpty ? location : 'No location',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: status == 'pending'
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _approve(context, ref),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _reject(context, ref),
                  ),
                ],
              )
            : null,
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

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Property'),
        content: const Text('Are you sure you want to approve this property?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(adminPropertiesProvider(status).notifier)
            .approve(property.id);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Property approved')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Property'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection:'),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(hintText: 'Reason'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true && reasonController.text.isNotEmpty) {
      try {
        await ref
            .read(adminPropertiesProvider(status).notifier)
            .reject(property.id, reasonController.text);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Property rejected')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }
}
