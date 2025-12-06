import 'package:broker_app/core/widgets/skeleton_box.dart';
import 'package:flutter/material.dart';

class PropertyCardSkeleton extends StatelessWidget {
  const PropertyCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonBox(width: double.infinity, height: 180, borderRadius: 0),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 180, height: 16),
                SizedBox(height: 8),
                SkeletonBox(width: 140, height: 14),
                SizedBox(height: 16),
                SkeletonBox(width: 120, height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
