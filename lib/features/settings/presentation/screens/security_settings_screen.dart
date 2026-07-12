import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../authentication/presentation/providers/auth_controller.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {
  bool _sending = false;

  Future<void> _sendVerification() async {
    setState(() => _sending = true);
    final controller = ref.read(authControllerProvider.notifier);
    await controller.sendEmailVerification();
    if (!mounted) return;
    setState(() => _sending = false);
    final error = controller.getErrorMessage();
    if (error != null) {
      AppSnackBar.showError(context, error);
    } else {
      AppSnackBar.showSuccess(context, 'Verification email sent.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final colors = context.colors;
    final isVerified = ref.read(authControllerProvider.notifier).isEmailVerified;

    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: user == null
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isVerified ? Icons.verified_outlined : Icons.warning_amber_outlined,
                        color: isVerified ? colors.success : colors.warning,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isVerified ? 'Email verified' : 'Email not verified',
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(user.email, style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isVerified) ...[
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: _sending ? null : _sendVerification,
                    icon: _sending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.email_outlined),
                    label: Text(_sending ? 'Sending…' : 'Resend verification email'),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                Text('Login & Access', style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.password_outlined),
                    title: const Text('Change password'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: colors.textHint),
                    onTap: () => context.push('/settings/password'),
                  ),
                ),
              ],
            ),
    );
  }
}
