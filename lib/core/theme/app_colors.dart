import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF5B21B6);
  static const Color primaryDark = Color(0xFF4C1D95);
  static const Color primaryLight = Color(0xFF8B5CF6);

  static const Color secondary = Color(0xFF2563EB);
  static const Color secondaryDark = Color(0xFF1D4ED8);

  // Accent
  static const Color accent = Color(0xFFF59E0B);

  // Neutrals
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);

  static const Color divider = Color(0xFFE2E8F0);
  static const Color border = Color(0xFFE2E8F0);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF97316);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF2563EB);

  // Role badges
  static const Color studentBadge = Color(0xFF2563EB);
  static const Color startupBadge = Color(0xFF22C55E);
  static const Color verifiedBadge = Color(0xFF5B21B6);

  // Application status — ordered along the pipeline, each stage visually distinct
  static const Color statusPending = Color(0xFF2563EB);
  static const Color statusScreening = Color(0xFFF59E0B);
  static const Color statusInterview = Color(0xFF5B21B6);
  static const Color statusTechnicalAssessment = Color(0xFF0891B2);
  static const Color statusOffer = Color(0xFFF97316);
  static const Color statusAccepted = Color(0xFF22C55E);
  static const Color statusRejected = Color(0xFFEF4444);
}
