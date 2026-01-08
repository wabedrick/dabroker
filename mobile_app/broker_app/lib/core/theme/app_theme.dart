import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Color Palette - Modern Luxury Real Estate Theme
/// Based on 2024 design trends for premium property apps
class AppColors {
  // Brand colors (see docs/ui_design_system.md)
  static const Color brandPrimary = Color(0xFF0B8A6E); // Emerald Rise
  static const Color brandPrimaryDark = Color(0xFF06604D); // Deep Canopy
  static const Color brandSecondary = Color(0xFFF5A524); // Amber Dawn

  // Back-compat aliases (used throughout the app)
  static const Color primaryBlue = brandPrimary;
  static const Color primaryLight = brandPrimary;
  static const Color primaryDark = brandPrimaryDark;

  static const Color secondaryGreen = brandSecondary;
  static const Color secondaryLight = brandSecondary;
  static const Color secondaryDark = Color(0xFFF29D38); // Saffron Ember

  // Neutral Palette - Sophisticated Minimalism
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFFDFCF9); // Ivory Glow
  static const Color backgroundGray = Color(0xFFF5F5F5); // Light Gray
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2428); // Midnight Slate
  static const Color textSecondary = Color(0xFF4A545E); // Graphite Mist
  static const Color textHint = Color(0xFF9E9E9E); // Light Gray

  // Elegant Dark Tones
  static const Color darkBackground = Color(0xFF111315);
  static const Color darkSurface = Color(0xFF1A1F22);
  static const Color darkAccent = Color(0xFF232A2E);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFD94343); // Crimson Gate
  static const Color info = Color(0xFF29B6F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [brandPrimaryDark, brandPrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBackground, darkSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// App Theme Configuration
class AppTheme {
  static const String _fontFamily = 'Inter';

  static TextTheme _buildTextTheme({required Brightness brightness}) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

    final inter = GoogleFonts.interTextTheme(base).apply(
      fontFamily: _fontFamily,
    );

    // Keep a small, consistent scale (matches docs/ui_design_system.md intent)
    return inter.copyWith(
      displayLarge: inter.displayLarge?.copyWith(
        fontSize: 40,
        height: 48 / 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displayMedium: inter.displayMedium?.copyWith(
        fontSize: 32,
        height: 40 / 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      displaySmall: inter.displaySmall?.copyWith(
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineMedium: inter.headlineMedium?.copyWith(
        fontSize: 22,
        height: 30 / 22,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: inter.titleLarge?.copyWith(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: inter.titleMedium?.copyWith(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: inter.bodyLarge?.copyWith(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: inter.bodyMedium?.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: inter.bodySmall?.copyWith(
        fontSize: 13,
        height: 18 / 13,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: inter.labelLarge?.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static ColorScheme _scheme(Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.brandPrimary,
      brightness: brightness,
    );

    return base.copyWith(
      primary: AppColors.brandPrimary,
      secondary: AppColors.brandSecondary,
      error: AppColors.error,
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = _scheme(Brightness.light);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _buildTextTheme(brightness: Brightness.light),

      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shadowColor: colorScheme.shadow.withAlpha((0.08 * 255).round()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: _buildTextTheme(brightness: Brightness.light).labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          textStyle: _buildTextTheme(brightness: Brightness.light).labelLarge,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: _buildTextTheme(brightness: Brightness.light).labelLarge,
        unselectedLabelStyle: _buildTextTheme(brightness: Brightness.light).bodySmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        // Use ThemeData defaults; most screens should take primary
        elevation: 4,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        labelStyle: _buildTextTheme(brightness: Brightness.light).labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        selectedColor: colorScheme.secondaryContainer,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = _scheme(Brightness.dark);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _buildTextTheme(brightness: Brightness.dark),

      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        labelStyle: _buildTextTheme(brightness: Brightness.dark).labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        selectedColor: colorScheme.secondaryContainer,
      ),
    );
  }
}

/// App Spacing Constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
}

/// App Border Radius Constants
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double round = 999.0;
}
