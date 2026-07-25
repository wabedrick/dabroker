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

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final storage = ref.read(storageServiceProvider);
      final isLoggedIn = await storage.isLoggedIn;

      if (isLoggedIn) {
        final biometricService = ref.read(biometricServiceProvider);
        final canAuthenticate = await biometricService.isBiometricAvailable();
        if (canAuthenticate) {
          final didAuthenticate = await biometricService.authenticate();
          if (!didAuthenticate) {
            // Biometric failed or cancelled, logout for security
            await storage.clearAuthToken();
            await storage.clearUser();
            if (mounted) {
               Navigator.of(context).pushReplacement(
                 MaterialPageRoute(builder: (_) => const WelcomeScreen()),
               );
            }
            return;
          }
        }
      }

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              isLoggedIn ? const MainScreen() : const WelcomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).shadowColor.withAlpha((0.2 * 255).round()),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.business,
                  size: 60,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'DaBROKER',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Real Estate & Lodging Marketplace',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary.withAlpha((0.9 * 255).round()),
                ),
              ),
              const SizedBox(height: 48),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Spacer(),
                        // Illustration
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: AppColors.primaryGradient,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.home_work,
                              size: 120,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Title
                        Text(
                          'Find Your Dream Home',
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Subtitle
                        Text(
                          'Discover the best properties and lodging options in your area',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        // Buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text('Sign In'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text('Create Account'),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
