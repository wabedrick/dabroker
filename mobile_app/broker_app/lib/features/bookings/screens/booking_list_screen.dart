import 'package:broker_app/core/utils/money_format.dart';
import 'package:broker_app/core/utils/status_badge.dart';
import 'package:broker_app/data/models/booking.dart';
import 'package:broker_app/features/bookings/providers/booking_provider.dart';
import 'package:broker_app/features/bookings/screens/booking_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(myBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontFamily: 'DM Serif Display',
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(myBookingsProvider),
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
                            Icons.calendar_month_outlined,
                            size: 64,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'You have no bookings yet',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).disabledColor,
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
            onRefresh: () async => ref.invalidate(myBookingsProvider),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return _BookingCard(booking: booking)
                    .animate(delay: (index * 50).ms)
                    .fade(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColors = bookingStatusBadgeColors(colorScheme, booking.status);

    return Card(
      elevation: 8,
      shadowColor: Colors.black.withAlpha(50),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.outlineVariant.withAlpha(50)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailScreen(booking: booking),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.lodging?.title ?? 'Unknown Lodging',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColors.background,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusColors.foreground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (booking.createdAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Booked: ${DateFormat('MMM d, h:mm a').format(booking.createdAt!.toLocal())}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('MMM d').format(booking.checkIn)} - ${DateFormat('MMM d').format(booking.checkOut)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${booking.guestsCount} guests',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  formatMoney(
                    booking.totalPrice,
                    booking.lodging?.currency,
                    fractionDigits: 0,
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
