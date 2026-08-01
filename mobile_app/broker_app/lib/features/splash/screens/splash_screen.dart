import 'package:flutter/material.dart';
import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/features/home/screens/main_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 2.5 seconds, then navigate to MainScreen
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/dabroker_icon.png',
              width: 120,
              height: 120,
            ).animate().fadeIn(duration: 800.ms).scale(curve: Curves.easeOutBack),
            
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'DaBroker',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, curve: Curves.easeOut),
            
            const SizedBox(height: 12),
            
            // Tagline
            Text(
              'Your Real Estate and Lodging Marketplace!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}
