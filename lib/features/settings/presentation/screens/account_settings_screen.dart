import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../authentication/presentation/providers/auth_controller.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          const _SectionLabel('Account'),
          _SettingsTile(
            icon: Icons.person_outline,
            label: 'Edit Profile',
            onTap: () => context.push(
              user.isStudent ? '/student-profile/edit' : '/startup-profile/edit',
            ),
          ),
          if (user.isStartup)
            _SettingsTile(
              icon: Icons.bar_chart_outlined,
              label: 'Analytics',
              onTap: () => context.push('/startup-analytics'),
            ),
          _SettingsTile(
            icon: Icons.lock_outline,
            label: 'Privacy',
            onTap: () => context.push('/settings/privacy'),
          ),
          _SettingsTile(
            icon: Icons.security_outlined,
            label: 'Security',
            onTap: () => context.push('/settings/security'),
          ),
          _SettingsTile(
            icon: Icons.password_outlined,
            label: 'Password',
            onTap: () => context.push('/settings/password'),
          ),
          const Divider(height: 32),
          const _SectionLabel('Preferences'),
          _SettingsTile(
            icon: Icons.language_outlined,
            label: 'Language',
            onTap: () => context.push('/settings/language'),
          ),
          const _ThemeTile(),
          const Divider(height: 32),
          const _SectionLabel('Support'),
          _SettingsTile(
            icon: Icons.help_outline,
            label: 'Help',
            onTap: () => context.push('/settings/help'),
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            label: 'About',
            onTap: () => context.push('/settings/about'),
          ),
          const Divider(height: 32),
          _SettingsTile(
            icon: Icons.logout,
            label: 'Logout',
            onTap: () => _confirmLogout(context, ref),
          ),
          _SettingsTile(
            icon: Icons.delete_forever_outlined,
            label: 'Delete Account',
            isDestructive: true,
            onTap: () => context.push('/settings/delete-account'),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You can sign back in anytime.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(color: colors.textHint, letterSpacing: 1),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = isDestructive ? colors.error : colors.textPrimary;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: color)),
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: colors.textHint),
      onTap: onTap,
    );
  }
}

class _ThemeTile extends ConsumerWidget {
  const _ThemeTile();

  String _label(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System default';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final colors = context.colors;

    return ListTile(
      leading: Icon(Icons.dark_mode_outlined, color: colors.textPrimary),
      title: Text('Theme', style: AppTextStyles.bodyMedium),
      trailing: Text(_label(mode), style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary)),
      onTap: () => _showThemePicker(context, ref, mode),
    );
  }

  Future<void> _showThemePicker(BuildContext context, WidgetRef ref, ThemeMode current) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final mode in ThemeMode.values)
              RadioListTile<ThemeMode>(
                value: mode,
                // ignore: deprecated_member_use
                groupValue: current,
                title: Text(_label(mode)),
                // ignore: deprecated_member_use
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value);
                  }
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
