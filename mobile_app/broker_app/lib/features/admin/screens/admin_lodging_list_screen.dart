import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/features/admin/providers/admin_lodging_provider.dart';
import 'package:broker_app/features/lodgings/screens/lodging_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/core/utils/image_helper.dart';

class AdminLodgingListScreen extends ConsumerStatefulWidget {
  const AdminLodgingListScreen({super.key});

  @override
  ConsumerState<AdminLodgingListScreen> createState() =>
      _AdminLodgingListScreenState();
}

class _AdminLodgingListScreenState extends ConsumerState<AdminLodgingListScreen>
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
        title: const Text('Manage Lodgings'),
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
          _LodgingList(status: 'pending'),
          _LodgingList(status: 'approved'),
          _LodgingList(status: 'rejected'),
        ],
      ),
    );
  }
}

class _LodgingList extends ConsumerWidget {
  const _LodgingList({required this.status});

  final String status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminLodgingsProvider(status));

    return state.when(
      data: (lodgings) {
        if (lodgings.isEmpty) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(adminLodgingsProvider(status).notifier).load(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 100),
                Center(child: Text('No lodgings found')),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(adminLodgingsProvider(status).notifier).load(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: lodgings.length,
            itemBuilder: (context, index) {
              final lodging = lodgings[index];
              return _AdminLodgingTile(lodging: lodging, status: status);
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
              Text('Error: $e'),
              ElevatedButton(
                onPressed: () =>
                    ref.read(adminLodgingsProvider(status).notifier).load(),
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

class _AdminLodgingTile extends ConsumerWidget {
  const _AdminLodgingTile({required this.lodging, required this.status});

  final Lodging lodging;
  final String status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                ImageHelper.fixUrl(lodging.media?.firstOrNull?.url ?? ''),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            title: Text(lodging.title),
            subtitle: Text(
              '${lodging.type} • ${lodging.city}, ${lodging.country}\nHost: ${lodging.host?.name ?? "Unknown"}',
            ),
            isThreeLine: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LodgingDetailScreen(lodgingId: lodging.id),
                ),
              );
            },
          ),
          if (status == 'pending')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _showRejectDialog(context, ref),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(adminLodgingsProvider(status).notifier)
                          .approve(lodging.id);
                    },
                    child: const Text('Approve'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Lodging'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Reason',
            hintText: 'Enter rejection reason',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(adminLodgingsProvider(status).notifier)
                    .reject(lodging.id, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}
