import 'package:broker_app/features/lodgings/screens/lodging_list_screen.dart';

import 'package:broker_app/features/profile/screens/profile_screen.dart';
import 'package:broker_app/features/properties/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:broker_app/features/auth/providers/auth_provider.dart';
import 'package:broker_app/features/auth/screens/login_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    LodgingListScreen(),
    ProfileScreen(),
  ];

  void _onTabSelected(int index) {
    if (index == 2) {
      final authState = ref.read(authStateProvider);
      if (authState.user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        return;
      }
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Properties',
          ),
          NavigationDestination(
            icon: Icon(Icons.hotel_outlined),
            selectedIcon: Icon(Icons.hotel),
            label: 'Lodgings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
