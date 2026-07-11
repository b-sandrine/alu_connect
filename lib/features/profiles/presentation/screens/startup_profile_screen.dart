import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/authentication/presentation/providers/auth_controller.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../domain/entities/startup_profile_entity.dart';
import '../providers/startup_profile_providers.dart';

String _galleryCategoryLabel(GalleryCategory c) {
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

class StartupProfileScreen extends ConsumerWidget {
  const StartupProfileScreen({super.key, required this.ownerId});

  final String ownerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateProvider).value;
    final isOwner = currentUser?.id == ownerId;
    final profileAsync = ref.watch(startupProfileByOwnerProvider(ownerId));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(startupProfileByOwnerProvider(ownerId)),
        child: profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return isOwner
                  ? _NoProfileYet(ownerId: ownerId)
                  : const Center(child: Text('No profile found.'));
            }
            return _ProfileContent(profile: profile, isOwner: isOwner);
          },
          loading: () => const LoadingIndicator(),
          error: (e, _) => ErrorView(message: e.toString()),
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.profile, required this.isOwner});

  final StartupProfileEntity profile;
  final bool isOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(profile: profile, isOwner: isOwner),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _AboutSection(profile: profile),
              const SizedBox(height: AppSpacing.xxl),
              _FoundersSection(profile: profile, isOwner: isOwner),
              const SizedBox(height: AppSpacing.xxl),
              _TeamSection(profile: profile, isOwner: isOwner),
              const SizedBox(height: AppSpacing.xxl),
              _GallerySection(profile: profile, isOwner: isOwner),
            ]),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onManage});

  final String title;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.titleSmall),
        if (onManage != null)
          TextButton.icon(
            onPressed: onManage,
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text('Manage'),
          ),
      ],
    );
  }
}

class _FoundersSection extends StatelessWidget {
  const _FoundersSection({required this.profile, required this.isOwner});

  final StartupProfileEntity profile;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (profile.founders.isEmpty && !isOwner) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Founders',
          onManage: isOwner ? () => context.push('/startup-profile/founders') : null,
        ),
        const SizedBox(height: AppSpacing.md),
        if (profile.founders.isEmpty)
          Text(
            'No founders added yet.',
            style: AppTextStyles.bodySmall.copyWith(color: colors.textHint),
          )
        else
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: profile.founders.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) {
                final f = profile.founders[i];
                return SizedBox(
                  width: 96,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: colors.info.withValues(alpha: 0.12),
                        backgroundImage:
                            f.photoUrl != null ? CachedNetworkImageProvider(f.photoUrl!) : null,
                        child: f.photoUrl == null
                            ? Text(
                                f.name.isNotEmpty ? f.name[0].toUpperCase() : '?',
                                style: AppTextStyles.titleMedium.copyWith(color: colors.info),
                              )
                            : null,
                      ),
                      const SizedBox(height: 6),
                      Text(f.name, style: AppTextStyles.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                      Text(f.role, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _TeamSection extends StatelessWidget {
  const _TeamSection({required this.profile, required this.isOwner});

  final StartupProfileEntity profile;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (profile.teamMembers.isEmpty && !isOwner) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Team',
          onManage: isOwner ? () => context.push('/startup-profile/team') : null,
        ),
        const SizedBox(height: AppSpacing.md),
        if (profile.teamMembers.isEmpty)
          Text(
            'No team members added yet.',
            style: AppTextStyles.bodySmall.copyWith(color: colors.textHint),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: profile.teamMembers.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) {
                final m = profile.teamMembers[i];
                return Container(
                  width: 108,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: colors.startupAccent.withValues(alpha: 0.14),
                        backgroundImage:
                            m.photoUrl != null ? CachedNetworkImageProvider(m.photoUrl!) : null,
                        child: m.photoUrl == null
                            ? Text(
                                m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                                style: AppTextStyles.titleSmall.copyWith(color: colors.startupAccent),
                              )
                            : null,
                      ),
                      const SizedBox(height: 6),
                      Text(m.name, style: AppTextStyles.labelSmall, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                      Text(m.department, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.profile, required this.isOwner});

  final StartupProfileEntity profile;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (profile.galleryImages.isEmpty && !isOwner) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Gallery',
          onManage: isOwner ? () => context.push('/startup-profile/gallery') : null,
        ),
        const SizedBox(height: AppSpacing.md),
        if (profile.galleryImages.isEmpty)
          Text(
            'No photos added yet.',
            style: AppTextStyles.bodySmall.copyWith(color: colors.textHint),
          )
        else
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: profile.galleryImages.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) {
                final g = profile.galleryImages[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: g.url,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const ColoredBox(
                          color: Colors.black12,
                          child: SizedBox(width: 90, height: 90),
                        ),
                        errorWidget: (_, __, ___) =>
                            const SizedBox(width: 90, height: 90, child: Icon(Icons.broken_image_outlined)),
                      ),
                      Positioned(
                        left: 4,
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            _galleryCategoryLabel(g.category),
                            style: AppTextStyles.caption.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.profile, required this.isOwner});

  final StartupProfileEntity profile;
  final bool isOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = <String>[
      if (profile.industry.isNotEmpty) profile.industry,
      if (profile.location.isNotEmpty) profile.location,
      if (profile.founded != null) 'Founded ${profile.founded}',
    ].join(' • ');

    return GradientHeader(
      padding: const EdgeInsets.fromLTRB(20, 56, 12, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Logo(logoUrl: profile.logoUrl, name: profile.companyName),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile.companyName,
                            style: AppTextStyles.titleLarge
                                .copyWith(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (profile.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified,
                              color: Colors.white, size: 18),
                        ],
                      ],
                    ),
                    if (profile.tagline.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        profile.tagline,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white.withValues(alpha: 0.85)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (details.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        details,
                        style: AppTextStyles.labelSmall
                            .copyWith(color: Colors.white.withValues(alpha: 0.75)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (isOwner) ...[
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () => context.push('/startup-profile/edit'),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit profile')),
                    PopupMenuItem(value: 'analytics', child: Text('View analytics')),
                    PopupMenuItem(value: 'signout', child: Text('Sign out')),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.push('/startup-profile/edit');
                    } else if (value == 'analytics') {
                      context.push('/startup-analytics');
                    } else if (value == 'signout') {
                      ref.read(authControllerProvider.notifier).signOut();
                    }
                  },
                ),
              ],
            ],
          ),
          if (profile.startupStage.isNotEmpty ||
              profile.companySize.isNotEmpty ||
              profile.website != null) ...[
            const SizedBox(height: 20),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (profile.startupStage.isNotEmpty)
                  _HeaderChip(
                      icon: Icons.rocket_launch_outlined,
                      label: profile.startupStage),
                if (profile.companySize.isNotEmpty)
                  _HeaderChip(
                      icon: Icons.groups_outlined,
                      label: '${profile.companySize} employees'),
                if (profile.website != null)
                  _HeaderChip(icon: Icons.language, label: profile.website!),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.logoUrl, required this.name});

  final String? logoUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    const size = 72.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: logoUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: CachedNetworkImage(
                imageUrl: logoUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.business, color: AppColors.primary),
              ),
            )
          : Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: AppTextStyles.titleLarge
                    .copyWith(color: AppColors.primary),
              ),
            ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.profile});

  final StartupProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About', style: AppTextStyles.titleSmall),
        const SizedBox(height: AppSpacing.md),
        if (profile.description.isNotEmpty) ...[
          Text(profile.description, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (profile.mission.isNotEmpty)
          _AboutBlock(
            icon: Icons.flag_outlined,
            label: 'Mission',
            text: profile.mission,
          ),
        if (profile.vision.isNotEmpty)
          _AboutBlock(
            icon: Icons.visibility_outlined,
            label: 'Vision',
            text: profile.vision,
          ),
        if (profile.culture.isNotEmpty)
          _AboutBlock(
            icon: Icons.diversity_3_outlined,
            label: 'Culture',
            text: profile.culture,
          ),
        if (profile.description.isEmpty && !profile.hasAboutContent)
          Text(
            'Add a description, mission, vision, or culture statement to tell students about your startup.',
            style: AppTextStyles.bodySmall.copyWith(color: colors.textHint),
          ),
      ],
    );
  }
}

class _AboutBlock extends StatelessWidget {
  const _AboutBlock({
    required this.icon,
    required this.label,
    required this.text,
  });

  final IconData icon;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: colors.textSecondary),
              const SizedBox(width: 6),
              Text(label, style: AppTextStyles.labelLarge),
            ],
          ),
          const SizedBox(height: 4),
          Text(text, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _NoProfileYet extends StatelessWidget {
  const _NoProfileYet({required this.ownerId});

  final String ownerId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.business_outlined, size: 56, color: colors.textHint),
            const SizedBox(height: AppSpacing.lg),
            Text('Set up your company profile', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Add your company details so students can learn about your startup.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => context.push('/startup-profile/edit'),
              child: const Text('Set up profile'),
            ),
          ],
        ),
      ),
    );
  }
}
