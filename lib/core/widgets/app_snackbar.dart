import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/context_theme_x.dart';

class AppSnackBar {
  AppSnackBar._();

  static void showError(BuildContext context, String message) {
    _show(context, message, icon: Icons.error_outline, color: context.colors.error);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, icon: Icons.check_circle_outline, color: context.colors.success);
  }

  static void _show(
    BuildContext context,
    String message, {
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: AppConstants.snackBarDuration,
        backgroundColor: color,
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
