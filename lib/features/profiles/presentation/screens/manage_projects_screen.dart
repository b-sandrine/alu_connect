import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import '../../domain/entities/student_profile_entity.dart';
import '../providers/student_profile_providers.dart';

class ManageProjectsScreen extends ConsumerWidget {
  const ManageProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final profileAsync = ref.watch(studentProfileByOwnerProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Set up your profile first.'));
          }
          return _ProjectsList(profile: profile);
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

class _ProjectsList extends ConsumerWidget {
  const _ProjectsList({required this.profile});

  final StudentProfileEntity profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = profile.projects;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openProjectForm(context, ref, profile),
        icon: const Icon(Icons.add),
        label: const Text('Add project'),
      ),
      body: projects.isEmpty
          ? _EmptyProjects(onAdd: () => _openProjectForm(context, ref, profile))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: projects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _ProjectListCard(
                project: projects[i],
                onEdit: () =>
                    _openProjectForm(context, ref, profile, existing: projects[i]),
                onRemove: () => _removeProject(ref, profile, projects[i].id),
              ),
            ),
    );
  }

  void _removeProject(WidgetRef ref, StudentProfileEntity profile, String id) {
    final updated = profile.projects.where((p) => p.id != id).toList();
    ref.read(studentProfileControllerProvider.notifier).updateProjects(profile, updated);
  }

  Future<void> _openProjectForm(
    BuildContext context,
    WidgetRef ref,
    StudentProfileEntity profile, {
    ProjectEntity? existing,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ProjectFormScreen(profile: profile, existing: existing),
      ),
    );
  }
}

class _ProjectListCard extends StatelessWidget {
  const _ProjectListCard({
    required this.project,
    required this.onEdit,
    required this.onRemove,
  });

  final ProjectEntity project;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (project.imageUrls.isNotEmpty)
            SizedBox(
              height: 140,
              child: CachedNetworkImage(
                imageUrl: project.imageUrls.first,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => const ColoredBox(color: Colors.black12),
                errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(project.name, style: AppTextStyles.titleSmall),
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
                if (project.technologies.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: project.technologies
                        .map((t) => Chip(
                              label: Text(t),
                              labelStyle: AppTextStyles.labelSmall,
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects({required this.onAdd});

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
            Icon(Icons.work_history_outlined, size: 56, color: colors.textHint),
            const SizedBox(height: AppSpacing.lg),
            Text('No projects yet', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Showcase what you\'ve built so startups can see your work.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add project'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectFormScreen extends ConsumerStatefulWidget {
  const _ProjectFormScreen({required this.profile, this.existing});

  final StudentProfileEntity profile;
  final ProjectEntity? existing;

  @override
  ConsumerState<_ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends ConsumerState<_ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.existing?.name ?? '');
  late final _descriptionController =
      TextEditingController(text: widget.existing?.description ?? '');
  late final _githubController =
      TextEditingController(text: widget.existing?.githubUrl ?? '');
  late final _liveDemoController =
      TextEditingController(text: widget.existing?.liveDemoUrl ?? '');
  final _techController = TextEditingController();

  late final List<String> _technologies = [...?widget.existing?.technologies];
  late final List<String> _existingImageUrls = [...?widget.existing?.imageUrls];
  final List<Uint8List> _pickedImages = [];
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _githubController.dispose();
    _liveDemoController.dispose();
    _techController.dispose();
    super.dispose();
  }

  void _addTech() {
    final tech = _techController.text.trim();
    if (tech.isEmpty || _technologies.contains(tech)) return;
    setState(() => _technologies.add(tech));
    _techController.clear();
  }

  void _removeTech(String tech) => setState(() => _technologies.remove(tech));

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 85, maxWidth: 1600);
    if (picked.isEmpty) return;
    final bytesList = await Future.wait(picked.map((f) => f.readAsBytes()));
    setState(() => _pickedImages.addAll(bytesList));
  }

  void _removeExistingImage(String url) => setState(() => _existingImageUrls.remove(url));

  void _removePickedImage(int index) => setState(() => _pickedImages.removeAt(index));

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final controller = ref.read(studentProfileControllerProvider.notifier);
    final projectId = widget.existing?.id ?? const Uuid().v4();

    final uploadedUrls = <String>[];
    for (final bytes in _pickedImages) {
      try {
        final url = await controller.uploadProjectImage(
          widget.profile.id,
          projectId,
          const Uuid().v4(),
          bytes,
        );
        uploadedUrls.add(url);
      } catch (_) {
        // Skip a failed image rather than blocking the whole save.
      }
    }

    final project = ProjectEntity(
      id: projectId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      technologies: List.unmodifiable(_technologies),
      githubUrl: _orNull(_githubController),
      liveDemoUrl: _orNull(_liveDemoController),
      imageUrls: [..._existingImageUrls, ...uploadedUrls],
    );

    final projects = [...widget.profile.projects];
    final existingIndex = projects.indexWhere((p) => p.id == projectId);
    if (existingIndex >= 0) {
      projects[existingIndex] = project;
    } else {
      projects.add(project);
    }

    await controller.updateProjects(widget.profile, projects);

    if (!mounted) return;
    setState(() => _saving = false);
    final error = ref.read(studentProfileControllerProvider.notifier).getErrorMessage();
    if (error != null) {
      AppSnackBar.showError(context, error);
      return;
    }
    Navigator.of(context).pop();
  }

  String? _orNull(TextEditingController controller) =>
      controller.text.trim().isEmpty ? null : controller.text.trim();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'Add project' : 'Edit project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Project name',
                controller: _nameController,
                prefixIcon: Icons.workspaces_outline,
                validator: (v) => Validators.required(v, fieldName: 'Project name'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 4,
                validator: (v) => Validators.minLength(v, 20, fieldName: 'Description'),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Technologies', style: AppTextStyles.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Add a technology',
                      hint: 'e.g. Flutter, Node.js, PostgreSQL',
                      controller: _techController,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _addTech(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(onPressed: _addTech, icon: const Icon(Icons.add)),
                ],
              ),
              if (_technologies.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _technologies
                      .map((t) => Chip(
                            label: Text(t),
                            onDeleted: () => _removeTech(t),
                            deleteIcon: const Icon(Icons.close, size: 16),
                          ))
                      .toList(),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'GitHub link (optional)',
                controller: _githubController,
                prefixIcon: FontAwesomeIcons.github,
                keyboardType: TextInputType.url,
                validator: Validators.url,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Live demo link (optional)',
                controller: _liveDemoController,
                prefixIcon: Icons.launch,
                keyboardType: TextInputType.url,
                validator: Validators.url,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Images', style: AppTextStyles.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final url in _existingImageUrls)
                    _ImageThumb(
                      image: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
                      onRemove: () => _removeExistingImage(url),
                    ),
                  for (var i = 0; i < _pickedImages.length; i++)
                    _ImageThumb(
                      image: Image.memory(_pickedImages[i], fit: BoxFit.cover),
                      onRemove: () => _removePickedImage(i),
                    ),
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: colors.border),
                        color: colors.background,
                      ),
                      child: Icon(Icons.add_photo_alternate_outlined, color: colors.textHint),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: 'Save project', onPressed: _save, isLoading: _saving),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({required this.image, required this.onRemove});

  final Widget image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(AppRadius.md), child: image),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
