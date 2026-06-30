import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../domain/entities/startup_profile_entity.dart';
import '../providers/startup_profile_providers.dart';

class StartupProfileScreen extends ConsumerWidget {
  const StartupProfileScreen({super.key, required this.ownerId});

  final String ownerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(startupProfileByOwnerProvider(ownerId));

    return Scaffold(
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found.'));
          }
          return _ProfileContent(profile: profile);
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final StartupProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push('/startup-profile/edit'),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _ProfileHero(profile: profile),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _InfoSection(profile: profile),
              const SizedBox(height: 24),
              _AboutSection(description: profile.description),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});

  final StartupProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _LogoWidget(logoUrl: profile.logoUrl, size: 72),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.companyName,
                            style: AppTextStyles.titleLarge
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        if (profile.isVerified)
                          const Icon(Icons.verified,
                              color: Colors.white, size: 20),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.tagline,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.profile});

  final StartupProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company details', style: AppTextStyles.titleSmall),
            const SizedBox(height: 12),
            _DetailRow(icon: Icons.category_outlined, label: profile.industry),
            const SizedBox(height: 8),
            _DetailRow(
                icon: Icons.location_on_outlined, label: profile.location),
            if (profile.website != null) ...[
              const SizedBox(height: 8),
              _DetailRow(icon: Icons.language, label: profile.website!),
            ],
          ],
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About', style: AppTextStyles.titleSmall),
            const SizedBox(height: 12),
            Text(description, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}

class _LogoWidget extends StatelessWidget {
  const _LogoWidget({required this.logoUrl, required this.size});

  final String? logoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: logoUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(size * 0.2),
              child: CachedNetworkImage(
                imageUrl: logoUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.business, color: AppColors.primary),
              ),
            )
          : const Icon(Icons.business, color: AppColors.primary),
    );
  }
}
