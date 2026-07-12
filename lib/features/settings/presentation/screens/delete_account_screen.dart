import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../authentication/presentation/providers/auth_controller.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _passwordController = TextEditingController();
  bool _understood = false;
  bool _deleting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (_passwordController.text.isEmpty) {
      AppSnackBar.showError(context, 'Enter your password to confirm.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete account permanently?'),
        content: const Text(
          'This will permanently delete your profile and account. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _deleting = true);
    final controller = ref.read(authControllerProvider.notifier);
    await controller.deleteAccount(password: _passwordController.text);

    if (!mounted) return;
    final error = controller.getErrorMessage();
    if (error != null) {
      setState(() => _deleting = false);
      AppSnackBar.showError(context, error);
      return;
    }
    // Account deletion signs the user out; the router's auth-state listener
    // redirects to /login automatically once authStateChanges() emits null.
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_outlined, color: colors.error),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Deleting your account permanently removes your profile, resume, portfolio, projects, and identity record. '
                    'This action cannot be undone.',
                    style: AppTextStyles.bodySmall.copyWith(color: colors.error),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Confirm your password', style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Password',
            controller: _passwordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
          ),
          const SizedBox(height: AppSpacing.lg),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _understood,
            onChanged: (v) => setState(() => _understood = v ?? false),
            title: const Text('I understand this action is permanent and cannot be undone.'),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colors.error),
              onPressed: (_understood && !_deleting) ? _delete : null,
              child: _deleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Delete my account'),
            ),
          ),
        ],
      ),
    );
  }
}
