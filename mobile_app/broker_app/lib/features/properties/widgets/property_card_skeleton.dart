import 'package:flutter/material.dart';
import '../../../../core/widgets/shimmer_loading.dart';

class PropertyCardSkeleton extends StatelessWidget {
  const PropertyCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(128),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          const ShimmerLoading(
            height: 220,
            width: double.infinity,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row (Category + rating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerLoading(height: 20, width: 80, borderRadius: BorderRadius.circular(8)),
                    ShimmerLoading(height: 20, width: 40, borderRadius: BorderRadius.circular(8)),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Title
                ShimmerLoading(height: 24, width: 200, borderRadius: BorderRadius.circular(8)),
                const SizedBox(height: 8),
                
                // Location
                ShimmerLoading(height: 16, width: 140, borderRadius: BorderRadius.circular(8)),
                const SizedBox(height: 16),
                
                // Details row (Beds, Baths, Sqft)
                Row(
                  children: [
                    ShimmerLoading(height: 24, width: 60, borderRadius: BorderRadius.circular(8)),
                    const SizedBox(width: 12),
                    ShimmerLoading(height: 24, width: 60, borderRadius: BorderRadius.circular(8)),
                    const SizedBox(width: 12),
                    ShimmerLoading(height: 24, width: 60, borderRadius: BorderRadius.circular(8)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Bottom row (Price)
                ShimmerLoading(height: 28, width: 120, borderRadius: BorderRadius.circular(8)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
