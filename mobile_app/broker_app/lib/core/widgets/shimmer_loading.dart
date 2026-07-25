import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: margin,
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainerHighest.withAlpha(128),
        highlightColor: colorScheme.surfaceContainer,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
