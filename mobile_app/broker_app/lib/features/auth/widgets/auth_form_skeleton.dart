import 'package:broker_app/core/widgets/skeleton_box.dart';
import 'package:flutter/material.dart';

class AuthFormSkeleton extends StatelessWidget {
  const AuthFormSkeleton({
    super.key,
    this.fieldCount = 2,
    this.showRoleSelector = false,
    this.includeSubtitle = true,
  });

  final int fieldCount;
  final bool showRoleSelector;
  final bool includeSubtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const SkeletonBox(width: 200, height: 32),
        if (includeSubtitle) ...[
          const SizedBox(height: 8),
          const SkeletonBox(width: 240, height: 20),
        ],
        const SizedBox(height: 32),
        for (var i = 0; i < fieldCount; i++) ...[
          SizedBox(width: double.infinity, child: SkeletonBox(height: 56)),
          const SizedBox(height: 20),
        ],
        if (showRoleSelector) ...[
          SizedBox(width: double.infinity, child: SkeletonBox(height: 56)),
          const SizedBox(height: 20),
        ],
        SizedBox(width: double.infinity, child: SkeletonBox(height: 56)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SkeletonBox(width: 120, height: 16),
            SizedBox(width: 12),
            SkeletonBox(width: 80, height: 16),
          ],
        ),
      ],
    );
  }
}
