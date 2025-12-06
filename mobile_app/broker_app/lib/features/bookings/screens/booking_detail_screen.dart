import 'package:broker_app/data/models/booking.dart';
import 'package:broker_app/features/bookings/providers/booking_provider.dart';
import 'package:broker_app/features/inquiries/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailScreen extends ConsumerWidget {
  final Booking booking;
  final bool isHost;

  const BookingDetailScreen({
    super.key,
    required this.booking,
    this.isHost = false,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    String status,
  ) async {
    final success = await ref
        .read(bookingProvider.notifier)
        .updateStatus(booking.publicId, status);

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Booking $status successfully')));
        ref.invalidate(hostBookingsProvider);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update booking')),
        );
      }
    }
  }

  Future<void> _contactUser(BuildContext context) async {
    final name = isHost ? booking.user?.name : booking.lodging?.host?.name;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact ${name ?? 'User'}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat in App'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      bookingId: booking.publicId,
                      title: name ?? 'Chat',
                    ),
                  ),
                );
              },
            ),
            if (booking.user?.email != null)
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(booking.user!.email),
                onTap: () {
                  Navigator.pop(context);
                  _launchEmail(booking.user!.email);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Regarding Booking #${booking.publicId.substring(0, 8)}',
      }),
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $emailLaunchUri');
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor(booking.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getStatusColor(booking.status)),
              ),
              child: Column(
                children: [
                  Text(
                    booking.status.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _getStatusColor(booking.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (booking.createdAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Booked on ${DateFormat('MMM d, y h:mm a').format(booking.createdAt!.toLocal())}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (booking.status == 'pending' && isHost)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('Action Required'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Property Info
            Text(
              'Property',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              booking.lodging?.title ?? 'Unknown Property',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(booking.lodging?.address ?? ''),
            const Divider(height: 32),

            // Dates & Guests
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check-in',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEE, MMM d, y').format(booking.checkIn),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check-out',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEE, MMM d, y').format(booking.checkOut),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Guests',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              '${booking.guestsCount} guests, ${booking.roomsCount} rooms',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 32),

            // Guest/Host Info
            Text(
              isHost ? 'Guest' : 'Host',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                child: Text(
                  (isHost
                              ? booking.user?.name
                              : booking.lodging?.host?.name)?[0]
                          .toUpperCase() ??
                      '?',
                ),
              ),
              title: Text(
                isHost
                    ? booking.user?.name ?? 'Unknown'
                    : booking.lodging?.host?.name ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: isHost
                  ? Text(
                      'Member since ${DateFormat.y().format(DateTime.now())}',
                    )
                  : null, // Placeholder date
              trailing: IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () => _contactUser(context),
              ),
            ),
            const Divider(height: 32),

            // Payment Info
            Text(
              'Payment Details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Price'),
                Text(
                  '${booking.lodging?.currency ?? ''} ${booking.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // Host Actions
            if (isHost && booking.status == 'pending') ...[
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _updateStatus(context, ref, 'cancelled'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Reject Booking'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateStatus(context, ref, 'confirmed'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Confirm Booking'),
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
