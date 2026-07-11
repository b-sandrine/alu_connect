import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../domain/entities/startup_profile_entity.dart';
import '../providers/startup_profile_providers.dart';

class ManageFoundersScreen extends ConsumerWidget {
  const ManageFoundersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final profileAsync = ref.watch(startupProfileByOwnerProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Founders')),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Set up your company profile first.'));
          }
          return _FoundersList(profile: profile);
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

class _FoundersList extends ConsumerWidget {
  const _FoundersList({required this.profile});

  final StartupProfileEntity profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final founders = profile.founders;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openFounderForm(context, ref, profile),
        icon: const Icon(Icons.add),
        label: const Text('Add founder'),
      ),
      body: founders.isEmpty
          ? _EmptyFounders(onAdd: () => _openFounderForm(context, ref, profile))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: founders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _FounderCard(
                founder: founders[i],
                onEdit: () => _openFounderForm(context, ref, profile, existing: founders[i]),
                onRemove: () => _removeFounder(ref, profile, founders[i].id),
              ),
            ),
    );
  }

  void _removeFounder(WidgetRef ref, StartupProfileEntity profile, String id) {
    final updated = profile.founders.where((f) => f.id != id).toList();
    ref.read(startupProfileControllerProvider.notifier).updateFounders(profile, updated);
  }

  Future<void> _openFounderForm(
    BuildContext context,
    WidgetRef ref,
    StartupProfileEntity profile, {
    FounderEntity? existing,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FounderFormSheet(profile: profile, existing: existing),
    );
  }
}

class _FounderCard extends StatelessWidget {
  const _FounderCard({
    required this.founder,
    required this.onEdit,
    required this.onRemove,
  });

  final FounderEntity founder;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colors.info.withValues(alpha: 0.12),
            backgroundImage:
                founder.photoUrl != null ? NetworkImage(founder.photoUrl!) : null,
            child: founder.photoUrl == null
                ? Text(
                    founder.name.isNotEmpty ? founder.name[0].toUpperCase() : '?',
                    style: AppTextStyles.titleMedium.copyWith(color: colors.info),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(founder.name, style: AppTextStyles.titleSmall),
                const SizedBox(height: 2),
                Text(founder.role, style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary)),
                if (founder.linkedinUrl != null || founder.email != null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      if (founder.linkedinUrl != null)
                        const _ContactChip(icon: Icons.link, label: 'LinkedIn'),
                      if (founder.email != null)
                        _ContactChip(icon: Icons.email_outlined, label: founder.email!),
                    ],
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'remove', child: Text('Remove')),
            ],
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'remove') onRemove();
            },
          ),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: colors.textHint),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _EmptyFounders extends StatelessWidget {
  const _EmptyFounders({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.groups_2_outlined, size: 56, color: colors.textHint),
            const SizedBox(height: AppSpacing.lg),
            Text('No founders added yet', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Introduce the people behind the startup to students browsing your profile.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add founder'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FounderFormSheet extends ConsumerStatefulWidget {
  const _FounderFormSheet({required this.profile, this.existing});

  final StartupProfileEntity profile;
  final FounderEntity? existing;

  @override
  ConsumerState<_FounderFormSheet> createState() => _FounderFormSheetState();
}

class _FounderFormSheetState extends ConsumerState<_FounderFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController =
      TextEditingController(text: widget.existing?.name ?? '');
  late final _roleController =
      TextEditingController(text: widget.existing?.role ?? '');
  late final _linkedinController =
      TextEditingController(text: widget.existing?.linkedinUrl ?? '');
  late final _emailController =
      TextEditingController(text: widget.existing?.email ?? '');

  Uint8List? _pickedPhotoBytes;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _linkedinController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _pickedPhotoBytes = bytes);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final controller = ref.read(startupProfileControllerProvider.notifier);
    final id = widget.existing?.id ?? const Uuid().v4();

    String? photoUrl = widget.existing?.photoUrl;
    if (_pickedPhotoBytes != null) {
      try {
        photoUrl = await controller.uploadFounderPhoto(
          widget.profile.id,
          id,
          _pickedPhotoBytes!,
        );
      } catch (_) {
        // Keep going without a photo rather than blocking the whole save.
      }
    }

    final founder = FounderEntity(
      id: id,
      name: _nameController.text.trim(),
      role: _roleController.text.trim(),
      photoUrl: photoUrl,
      linkedinUrl: _linkedinController.text.trim().isEmpty
          ? null
          : _linkedinController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
    );

    final founders = [...widget.profile.founders];
    final existingIndex = founders.indexWhere((f) => f.id == id);
    if (existingIndex >= 0) {
      founders[existingIndex] = founder;
    } else {
      founders.add(founder);
    }

    await controller.updateFounders(widget.profile, founders);

    if (!mounted) return;
    setState(() => _saving = false);
    final error = ref.read(startupProfileControllerProvider.notifier).getErrorMessage();
    if (error != null) {
      AppSnackBar.showError(context, error);
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.existing == null ? 'Add founder' : 'Edit founder',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: CircleAvatar(
                    radius: 36,
                    backgroundImage: _pickedPhotoBytes != null
                        ? MemoryImage(_pickedPhotoBytes!)
                        : (widget.existing?.photoUrl != null
                            ? NetworkImage(widget.existing!.photoUrl!)
                            : null) as ImageProvider?,
                    child: _pickedPhotoBytes == null && widget.existing?.photoUrl == null
                        ? const Icon(Icons.add_a_photo_outlined)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Name',
                controller: _nameController,
                prefixIcon: Icons.person_outline,
                validator: (v) => Validators.required(v, fieldName: 'Name'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Role',
                hint: 'e.g. Co-Founder & CEO',
                controller: _roleController,
                prefixIcon: Icons.badge_outlined,
                validator: (v) => Validators.required(v, fieldName: 'Role'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'LinkedIn URL (optional)',
                controller: _linkedinController,
                prefixIcon: Icons.link,
                keyboardType: TextInputType.url,
                validator: Validators.url,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Email (optional)',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? null : Validators.email(v),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: 'Save', onPressed: _save, isLoading: _saving),
            ],
          ),
        ),
      ),
    );
  }
}
