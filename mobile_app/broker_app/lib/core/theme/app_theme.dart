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
///
/// Typography pairing (2026 premium real-estate standard):
///  • DM Sans   → UI text, body, labels, buttons  (geometric, legible, modern)
///  • DM Serif Display → display & headline styles  (editorial, luxury, trust)
class AppTheme {
  static TextTheme _buildTextTheme({required Brightness brightness}) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

    // Body & UI: DM Sans — clean, geometric, highly readable
    final dmSans = GoogleFonts.dmSansTextTheme(base);
    // Display headings: DM Serif Display — editorial, premium
    final dmSerif = GoogleFonts.dmSerifDisplayTextTheme(base);

    return dmSans.copyWith(
      // ── Display styles (hero headlines, property names) ──────────────────
      displayLarge: dmSerif.displayLarge?.copyWith(
        fontSize: 42,
        height: 1.1,
        fontWeight: FontWeight.w400, // Serif Display is inherently bold-looking
        letterSpacing: -1.0,
      ),
      displayMedium: dmSerif.displayMedium?.copyWith(
        fontSize: 34,
        height: 1.15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.8,
      ),
      displaySmall: dmSerif.displaySmall?.copyWith(
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.5,
      ),

      // ── Headline styles (section titles, screen titles) ──────────────────
      headlineLarge: dmSerif.headlineLarge?.copyWith(
        fontSize: 26,
        height: 1.25,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
      ),
      headlineMedium: dmSerif.headlineMedium?.copyWith(
        fontSize: 22,
        height: 1.3,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.2,
      ),
      headlineSmall: dmSans.headlineSmall?.copyWith(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),

      // ── Title styles (card titles, list headers) ─────────────────────────
      titleLarge: dmSans.titleLarge?.copyWith(
        fontSize: 18,
        height: 1.4,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: dmSans.titleMedium?.copyWith(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      titleSmall: dmSans.titleSmall?.copyWith(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),

      // ── Body styles (descriptions, notes) ────────────────────────────────
      bodyLarge: dmSans.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      bodyMedium: dmSans.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      bodySmall: dmSans.bodySmall?.copyWith(
        fontSize: 13,
        height: 1.5,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),

      // ── Label styles (buttons, chips, badges) ────────────────────────────
      labelLarge: dmSans.labelLarge?.copyWith(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelMedium: dmSans.labelMedium?.copyWith(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      labelSmall: dmSans.labelSmall?.copyWith(
        fontSize: 11,
        height: 1.4,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
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
        titleTextStyle: GoogleFonts.dmSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: colorScheme.onSurface,
        ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
        selectedLabelStyle: _buildTextTheme(
          brightness: Brightness.light,
        ).labelLarge,
        unselectedLabelStyle: _buildTextTheme(
          brightness: Brightness.light,
        ).bodySmall,
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

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: _buildTextTheme(brightness: Brightness.light).bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        elevation: 6,
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
        titleTextStyle: GoogleFonts.dmSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: colorScheme.onSurface,
        ),
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

      // SnackBar Theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: _buildTextTheme(brightness: Brightness.dark).bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        elevation: 6,
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
