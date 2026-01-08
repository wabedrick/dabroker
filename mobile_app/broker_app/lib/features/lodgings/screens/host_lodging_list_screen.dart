import 'package:broker_app/core/utils/image_helper.dart';
import 'package:broker_app/core/utils/money_format.dart';
import 'package:broker_app/data/models/lodging.dart';
import 'package:broker_app/features/lodgings/providers/lodging_list_provider.dart';
import 'package:broker_app/features/lodgings/screens/add_lodging_screen.dart';
import 'package:broker_app/features/bookings/screens/host_booking_list_screen.dart';
import 'package:broker_app/features/lodgings/screens/lodging_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HostLodgingListScreen extends ConsumerWidget {
  const HostLodgingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lodgingsAsync = ref.watch(hostLodgingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lodgings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddLodgingScreen()),
              );
              ref.invalidate(hostLodgingListProvider);
            },
          ),
        ],
      ),
      body: lodgingsAsync.when(
        data: (lodgings) {
          if (lodgings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You have no lodgings yet'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddLodgingScreen(),
                        ),
                      );
                      ref.invalidate(hostLodgingListProvider);
                    },
                    child: const Text('Add Lodging'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: lodgings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final lodging = lodgings[index];
              return _HostLodgingCard(lodging: lodging);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _HostLodgingCard extends ConsumerWidget {
  const _HostLodgingCard({required this.lodging});

  final Lodging lodging;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isApproved = (lodging.status ?? '').toLowerCase() == 'approved';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LodgingDetailScreen(
                lodgingId: lodging.id,
                initialLodging: lodging,
              ),
            ),
          );
          ref.invalidate(hostLodgingListProvider);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lodging.media?.isNotEmpty == true)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  ImageHelper.fixUrl(lodging.media!.first.url),
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lodging.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isApproved
                              ? colorScheme.primaryContainer
                              : colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          lodging.status?.toUpperCase() ?? 'UNKNOWN',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: isApproved
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${lodging.city}, ${lodging.country}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        formatMoney(
                          lodging.pricePerNight,
                          lodging.currency,
                          fractionDigits: 0,
                        ),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        lodging.isAvailable == true
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.book_online),
                        tooltip: 'View bookings',
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HostBookingListScreen(
                                lodgingId: lodging.id,
                                lodgingTitle: lodging.title,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
