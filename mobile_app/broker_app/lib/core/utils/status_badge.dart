import 'package:flutter/material.dart';

class StatusBadgeColors {
  const StatusBadgeColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

StatusBadgeColors bookingStatusBadgeColors(ColorScheme scheme, String status) {
  switch (status.toLowerCase()) {
    case 'confirmed':
      return StatusBadgeColors(
        background: scheme.tertiaryContainer,
        foreground: scheme.onTertiaryContainer,
        border: scheme.tertiary,
      );
    case 'pending':
      return StatusBadgeColors(
        background: scheme.secondaryContainer,
        foreground: scheme.onSecondaryContainer,
        border: scheme.secondary,
      );
    case 'cancelled':
      return StatusBadgeColors(
        background: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
        border: scheme.error,
      );
    case 'completed':
      return StatusBadgeColors(
        background: scheme.primaryContainer,
        foreground: scheme.onPrimaryContainer,
        border: scheme.primary,
      );
    default:
      return StatusBadgeColors(
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurfaceVariant,
        border: scheme.outlineVariant,
      );
  }
}
