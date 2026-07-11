import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_spacing.dart';
import '../theme/context_theme_x.dart';

class AppSkeleton {
  AppSkeleton._();

  static Widget box({
    required BuildContext context,
    double width = double.infinity,
    double height = 16,
    double radius = AppRadius.sm,
  }) {
    final colors = context.colors;
    return Shimmer.fromColors(
      baseColor: colors.divider,
      highlightColor: colors.surfaceElevated,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.divider,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
