import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/context_theme_x.dart';

/// A frosted-glass surface: blurred backdrop + a translucent tinted fill.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = AppRadius.xl,
    this.blurSigma = 16,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: colors.glassFill,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: colors.glassBorder),
          ),
          child: child,
        ),
      ),
    );
  }
}
