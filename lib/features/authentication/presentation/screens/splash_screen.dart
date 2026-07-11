import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/app_skeleton.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final gradient = context.colors.heroGradient;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(top: -80, right: -60, child: _blurCircle(220)),
          Positioned(bottom: -100, left: -70, child: _blurCircle(260)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app-logo',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.connect_without_contact,
                      size: 48,
                      color: Color(0xFF1A73E8),
                    ),
                  ),
                ).animate().scale(
                      duration: 500.ms,
                      curve: Curves.easeOutBack,
                      begin: const Offset(0.6, 0.6),
                      end: const Offset(1, 1),
                    ).fadeIn(duration: 400.ms),
                const SizedBox(height: 24),
                Text(
                  'ALU Connect',
                  style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Where talent meets opportunity',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 250.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 48),
                AppSkeleton.box(context: context, width: 120, height: 6, radius: 3)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
    );
  }
}
