import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/context_theme_x.dart';

/// A gradient banner with a couple of soft decorative blurred circles,
/// used behind headlines on splash / onboarding / auth screens.
class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.child,
    this.height,
    this.gradientColors,
    this.roundedBottom = true,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final double? height;
  final List<Color>? gradientColors;
  final bool roundedBottom;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? context.colors.heroGradient;

    return ClipRRect(
      borderRadius: roundedBottom
          ? const BorderRadius.only(
              bottomLeft: Radius.circular(AppRadius.xxl),
              bottomRight: Radius.circular(AppRadius.xxl),
            )
          : BorderRadius.zero,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -60,
              right: -40,
              child: _blurCircle(140),
            ),
            Positioned(
              bottom: -50,
              left: -30,
              child: _blurCircle(110),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }

  Widget _blurCircle(double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
    );
  }
}
