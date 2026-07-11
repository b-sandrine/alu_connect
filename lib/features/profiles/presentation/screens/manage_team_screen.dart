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

class ManageTeamScreen extends ConsumerWidget {
  const ManageTeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final profileAsync = ref.watch(startupProfileByOwnerProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Team Members')),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Set up your company profile first.'));
          }
          return _TeamList(profile: profile);
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

class _TeamList extends ConsumerWidget {
  const _TeamList({required this.profile});

  final StartupProfileEntity profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = profile.teamMembers;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openMemberForm(context, ref, profile),
        icon: const Icon(Icons.add),
        label: const Text('Add member'),
      ),
      body: members.isEmpty
          ? _EmptyTeam(onAdd: () => _openMemberForm(context, ref, profile))
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: members.length,
              itemBuilder: (_, i) => _TeamMemberCard(
                member: members[i],
                onEdit: () => _openMemberForm(context, ref, profile, existing: members[i]),
                onRemove: () => _removeMember(ref, profile, members[i].id),
              ),
            ),
    );
  }

  void _removeMember(WidgetRef ref, StartupProfileEntity profile, String id) {
    final updated = profile.teamMembers.where((m) => m.id != id).toList();
    ref.read(startupProfileControllerProvider.notifier).updateTeamMembers(profile, updated);
  }

  Future<void> _openMemberForm(
    BuildContext context,
    WidgetRef ref,
    StartupProfileEntity profile, {
    TeamMemberEntity? existing,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _TeamMemberFormSheet(profile: profile, existing: existing),
    );
  }
}

class _TeamMemberCard extends StatelessWidget {
  const _TeamMemberCard({
    required this.member,
    required this.onEdit,
    required this.onRemove,
  });

  final TeamMemberEntity member;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: colors.startupAccent.withValues(alpha: 0.14),
                  backgroundImage:
                      member.photoUrl != null ? NetworkImage(member.photoUrl!) : null,
                  child: member.photoUrl == null
                      ? Text(
                          member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                          style: AppTextStyles.titleMedium.copyWith(color: colors.startupAccent),
                        )
                      : null,
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
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
          const SizedBox(height: AppSpacing.sm),
          Text(member.name, style: AppTextStyles.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(member.role, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: colors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              member.department,
              style: AppTextStyles.labelSmall.copyWith(color: colors.info),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTeam extends StatelessWidget {
  const _EmptyTeam({required this.onAdd});

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
            Icon(Icons.people_alt_outlined, size: 56, color: colors.textHint),
            const SizedBox(height: AppSpacing.lg),
            Text('No team members yet', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Showcase the people building your startup.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add team member'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamMemberFormSheet extends ConsumerStatefulWidget {
  const _TeamMemberFormSheet({required this.profile, this.existing});

  final StartupProfileEntity profile;
  final TeamMemberEntity? existing;

  @override
  ConsumerState<_TeamMemberFormSheet> createState() => _TeamMemberFormSheetState();
}

class _TeamMemberFormSheetState extends ConsumerState<_TeamMemberFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController =
      TextEditingController(text: widget.existing?.name ?? '');
  late final _roleController =
      TextEditingController(text: widget.existing?.role ?? '');
  late final _departmentController =
      TextEditingController(text: widget.existing?.department ?? '');

  Uint8List? _pickedPhotoBytes;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _departmentController.dispose();
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
        photoUrl = await controller.uploadTeamMemberPhoto(
          widget.profile.id,
          id,
          _pickedPhotoBytes!,
        );
      } catch (_) {
        // Keep going without a photo rather than blocking the whole save.
      }
    }

    final member = TeamMemberEntity(
      id: id,
      name: _nameController.text.trim(),
      role: _roleController.text.trim(),
      department: _departmentController.text.trim(),
      photoUrl: photoUrl,
    );

    final members = [...widget.profile.teamMembers];
    final existingIndex = members.indexWhere((m) => m.id == id);
    if (existingIndex >= 0) {
      members[existingIndex] = member;
    } else {
      members.add(member);
    }

    await controller.updateTeamMembers(widget.profile, members);

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
                widget.existing == null ? 'Add team member' : 'Edit team member',
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
                hint: 'e.g. Product Designer',
                controller: _roleController,
                prefixIcon: Icons.badge_outlined,
                validator: (v) => Validators.required(v, fieldName: 'Role'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Department',
                hint: 'e.g. Design, Engineering, Growth',
                controller: _departmentController,
                prefixIcon: Icons.apartment_outlined,
                validator: (v) => Validators.required(v, fieldName: 'Department'),
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
