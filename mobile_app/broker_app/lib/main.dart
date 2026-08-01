import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'core/config/app_config.dart';
import 'core/notifications/notification_service.dart';
import 'core/providers/app_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/security/biometric_service.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/screens/main_screen.dart';

import 'features/splash/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  await FirebaseBootstrapper.ensureInitialized();
  if (FirebaseBootstrapper.available) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  final appDocDir = await getApplicationDocumentsDirectory();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        cacheDirectoryProvider.overrideWithValue(appDocDir.path),
      ],
      child: const BrokerApp(),
    ),
  );
}

class BrokerApp extends ConsumerStatefulWidget {
  const BrokerApp({super.key});

  @override
  ConsumerState<BrokerApp> createState() => _BrokerAppState();
}

class _BrokerAppState extends ConsumerState<BrokerApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationServiceProvider).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Broker - Real Estate & Lodging',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
