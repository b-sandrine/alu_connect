import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../authentication/presentation/providers/auth_controller.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';

class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  ConsumerState<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  bool _busy = false;

  Future<void> _togglePushNotifications(bool enabled, String userId) async {
    setState(() => _busy = true);
    final controller = ref.read(authControllerProvider.notifier);
    if (enabled) {
      await controller.registerPushNotifications(userId);
    } else {
      await controller.disablePushNotifications(userId);
    }
    if (!mounted) return;
    setState(() => _busy = false);
    AppSnackBar.showSuccess(
      context,
      enabled ? 'Push notifications enabled.' : 'Push notifications disabled.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: user == null
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text('Notifications', style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border),
                  ),
                  child: SwitchListTile(
                    title: const Text('Push notifications'),
                    subtitle: const Text(
                      'Get notified about application updates, messages, and interviews on this device.',
                    ),
                    value: user.fcmToken != null,
                    onChanged: _busy ? null : (v) => _togglePushNotifications(v, user.id),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Your Data', style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border),
                  ),
                  child: Text(
                    'Your profile is visible to startups you apply to and, for students, to any startup reviewing your application. '
                    'You can permanently remove your data at any time from Delete Account in Account Settings.',
                    style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
                  ),
                ),
              ],
            ),
    );
  }
}
