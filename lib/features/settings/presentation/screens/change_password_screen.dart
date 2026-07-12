import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../authentication/presentation/providers/auth_controller.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final controller = ref.read(authControllerProvider.notifier);
    await controller.changePassword(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
    );

    if (!mounted) return;
    setState(() => _saving = false);
    final error = controller.getErrorMessage();
    if (error != null) {
      AppSnackBar.showError(context, error);
      return;
    }
    AppSnackBar.showSuccess(context, 'Password updated.');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Current password',
                controller: _currentController,
                isPassword: true,
                prefixIcon: Icons.lock_outline,
                validator: (v) => Validators.required(v, fieldName: 'Current password'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'New password',
                controller: _newController,
                isPassword: true,
                prefixIcon: Icons.lock_outline,
                validator: Validators.password,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Confirm new password',
                controller: _confirmController,
                isPassword: true,
                prefixIcon: Icons.lock_outline,
                validator: (v) => Validators.confirmPassword(v, _newController.text),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: 'Update password', onPressed: _save, isLoading: _saving),
            ],
          ),
        ),
      ),
    );
  }
}
