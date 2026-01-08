import 'package:broker_app/core/theme/theme_provider.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/auth/screens/login_screen.dart';
import 'package:broker_app/features/bookings/screens/booking_list_screen.dart';
import 'package:broker_app/features/bookings/screens/host_booking_list_screen.dart';
import 'package:broker_app/features/consultations/screens/consultation_list_screen.dart';
import 'package:broker_app/features/inquiries/screens/owner_inquiry_list_screen.dart';
import 'package:broker_app/features/lodgings/screens/host_lodging_list_screen.dart';
import 'package:broker_app/features/professionals/screens/professional_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            child: const Text('Login'),
          ),
        ),
      );
    }

    final isHost =
        user.roles.contains('host') ||
        user.roles.contains('admin') ||
        user.roles.contains('super_admin');

    final isOwner =
        user.roles.contains('owner') ||
        user.roles.contains('seller') ||
        user.roles.contains('admin') ||
        user.roles.contains('super_admin');

    final isProfessional =
        user.roles.contains('broker') ||
        user.roles.contains('surveyor') ||
        user.roles.contains('lawyer') ||
        user.roles.contains('real_estate_agent');

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              child: Text(
                user.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          if (isProfessional)
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Professional Profile'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfessionalProfileScreen(),
                  ),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('My Consultations'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ConsultationListScreen(),
                ),
              );
            },
          ),
          if (isHost) ...[
            ListTile(
              leading: const Icon(Icons.hotel),
              title: const Text('My Lodgings'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HostLodgingListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Reservations (Host)'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const HostBookingListScreen(),
                  ),
                );
              },
            ),
          ],
          if (isOwner || isProfessional) ...[
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('Inquiries & Messages'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const OwnerInquiryListScreen(),
                  ),
                );
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('My Bookings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BookingListScreen()),
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeModeProvider);
              return ListTile(
                leading: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                title: const Text('Theme'),
                subtitle: Text(
                  themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
                ),
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).toggle();
                  },
                ),
                onTap: () {
                  ref.read(themeModeProvider.notifier).toggle();
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
