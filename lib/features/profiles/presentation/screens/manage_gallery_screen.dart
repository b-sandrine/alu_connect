import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../domain/entities/startup_profile_entity.dart';
import '../providers/startup_profile_providers.dart';

String _categoryLabel(GalleryCategory c) {
  switch (c) {
    case GalleryCategory.office:
      return 'Office';
    case GalleryCategory.events:
      return 'Events';
    case GalleryCategory.products:
      return 'Products';
    case GalleryCategory.achievements:
      return 'Achievements';
  }
}

class ManageGalleryScreen extends ConsumerStatefulWidget {
  const ManageGalleryScreen({super.key});

  @override
  ConsumerState<ManageGalleryScreen> createState() => _ManageGalleryScreenState();
}

class _ManageGalleryScreenState extends ConsumerState<ManageGalleryScreen> {
  GalleryCategory? _filter;
  bool _uploading = false;

  Future<void> _addImage(StartupProfileEntity profile) async {
    final category = await showModalBottomSheet<GalleryCategory>(
      context: context,
      builder: (_) => const _CategoryPickerSheet(),
    );
    if (category == null || !mounted) return;

    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (picked == null || !mounted) return;

    setState(() => _uploading = true);
    final bytes = await picked.readAsBytes();
    final controller = ref.read(startupProfileControllerProvider.notifier);
    final id = const Uuid().v4();

    try {
      final url = await controller.uploadGalleryImage(profile.id, id, bytes);
      final image = GalleryImageEntity(
        id: id,
        url: url,
        category: category,
        uploadedAt: DateTime.now(),
      );
      await controller.updateGalleryImages(profile, [...profile.galleryImages, image]);
      if (!mounted) return;
      final error = ref.read(startupProfileControllerProvider.notifier).getErrorMessage();
      if (error != null) AppSnackBar.showError(context, error);
    } catch (e) {
      if (mounted) AppSnackBar.showError(context, 'Upload failed. Please try again.');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  void _removeImage(StartupProfileEntity profile, String id) {
    final updated = profile.galleryImages.where((g) => g.id != id).toList();
    ref.read(startupProfileControllerProvider.notifier).updateGalleryImages(profile, updated);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final profileAsync = ref.watch(startupProfileByOwnerProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Startup Gallery')),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Set up your company profile first.'));
          }
          final images = _filter == null
              ? profile.galleryImages
              : profile.galleryImages.where((g) => g.category == _filter).toList();

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(label: 'All', selected: _filter == null, onTap: () => setState(() => _filter = null)),
                          const SizedBox(width: 8),
                          for (final c in GalleryCategory.values) ...[
                            _FilterChip(
                              label: _categoryLabel(c),
                              selected: _filter == c,
                              onTap: () => setState(() => _filter = c),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: images.isEmpty
                        ? _EmptyGallery(onAdd: () => _addImage(profile))
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: images.length,
                            itemBuilder: (_, i) => _GalleryTile(
                              image: images[i],
                              onRemove: () => _removeImage(profile, images[i].id),
                            ),
                          ),
                  ),
                ],
              ),
              if (_uploading)
                Container(
                  color: Colors.black26,
                  child: const LoadingIndicator(),
                ),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
      floatingActionButton: profileAsync.maybeWhen(
        data: (profile) => profile == null
            ? null
            : FloatingActionButton.extended(
                onPressed: _uploading ? null : () => _addImage(profile),
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Add photo'),
              ),
        orElse: () => null,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: colors.info.withValues(alpha: 0.15),
      labelStyle: AppTextStyles.labelSmall.copyWith(color: selected ? colors.info : colors.textSecondary),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({required this.image, required this.onRemove});

  final GalleryImageEntity image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: image.url,
            fit: BoxFit.cover,
            placeholder: (_, __) => const ColoredBox(color: Colors.black12),
            errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery({required this.onAdd});

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
            Icon(Icons.photo_library_outlined, size: 56, color: colors.textHint),
            const SizedBox(height: AppSpacing.lg),
            Text('No photos yet', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Add photos of your office, events, products, or achievements.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Add photo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPickerSheet extends StatelessWidget {
  const _CategoryPickerSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a category', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.md),
            for (final c in GalleryCategory.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(_categoryIcon(c)),
                title: Text(_categoryLabel(c)),
                onTap: () => Navigator.of(context).pop(c),
              ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(GalleryCategory c) {
    switch (c) {
      case GalleryCategory.office:
        return Icons.apartment_outlined;
      case GalleryCategory.events:
        return Icons.event_outlined;
      case GalleryCategory.products:
        return Icons.inventory_2_outlined;
      case GalleryCategory.achievements:
        return Icons.emoji_events_outlined;
    }
  }
}
