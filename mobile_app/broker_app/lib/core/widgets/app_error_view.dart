import 'package:flutter/material.dart';

class AppErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final String? retryLabel;

  const AppErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    final isNetworkError = error.toLowerCase().contains('internet') || 
                           error.toLowerCase().contains('connection') ||
                           error.toLowerCase().contains('offline');
    final isTimeoutError = error.toLowerCase().contains('timed out') || 
                           error.toLowerCase().contains('timeout');
    
    final String title;
    final IconData icon;
    
    if (isTimeoutError) {
      title = 'Slow Connection';
      icon = Icons.wifi_tethering_error_rounded;
    } else if (isNetworkError) {
      title = 'No Internet Connection';
      icon = Icons.wifi_off_rounded;
    } else {
      title = 'Oops! Something went wrong';
      icon = Icons.error_outline_rounded;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: colorScheme.error),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(retryLabel ?? 'Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
