import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Brightness-aware semantic tokens layered on top of [AppColors].
///
/// [AppColors] stays untouched (143 existing call sites across the app) —
/// this extension only backs the newly-redesigned screens, so it's safe to
/// register on both light and dark [ThemeData] without affecting anything
/// that isn't opted in via `context.colors`.
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.divider,
    required this.border,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.studentAccent,
    required this.startupAccent,
    required this.glassFill,
    required this.glassBorder,
    required this.heroGradient,
  });

  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color divider;
  final Color border;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color studentAccent;
  final Color startupAccent;
  final Color glassFill;
  final Color glassBorder;
  final List<Color> heroGradient;

  static const light = AppColorTokens(
    background: AppColors.backgroundLight,
    surface: AppColors.surface,
    surfaceElevated: Color(0xFFFFFFFF),
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textHint: AppColors.textHint,
    divider: AppColors.divider,
    border: AppColors.border,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    studentAccent: AppColors.studentBadge,
    startupAccent: AppColors.startupBadge,
    glassFill: Color(0x99FFFFFF),
    glassBorder: Color(0x4DFFFFFF),
    heroGradient: [AppColors.primary, AppColors.primaryDark],
  );

  static const dark = AppColorTokens(
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    surfaceElevated: Color(0xFF2A2A2A),
    textPrimary: Colors.white,
    textSecondary: Colors.white70,
    textHint: Colors.white38,
    divider: Colors.white12,
    border: Colors.white24,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    studentAccent: Color(0xFF7BA7F9),
    startupAccent: Color(0xFF6FCF97),
    glassFill: Color(0x14FFFFFF),
    glassBorder: Color(0x26FFFFFF),
    heroGradient: [Color(0xFF1557B0), Color(0xFF0D2B4E)],
  );

  @override
  AppColorTokens copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? divider,
    Color? border,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? studentAccent,
    Color? startupAccent,
    Color? glassFill,
    Color? glassBorder,
    List<Color>? heroGradient,
  }) {
    return AppColorTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      studentAccent: studentAccent ?? this.studentAccent,
      startupAccent: startupAccent ?? this.startupAccent,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) return this;
    return AppColorTokens(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      studentAccent: Color.lerp(studentAccent, other.studentAccent, t)!,
      startupAccent: Color.lerp(startupAccent, other.startupAccent, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      heroGradient: [
        Color.lerp(heroGradient[0], other.heroGradient[0], t)!,
        Color.lerp(heroGradient[1], other.heroGradient[1], t)!,
      ],
    );
  }
}
