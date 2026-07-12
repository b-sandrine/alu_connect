import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/gradient_header.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/authentication/domain/entities/user_entity.dart';
import '../../../../features/authentication/presentation/providers/auth_controller.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/applications/domain/entities/application_entity.dart';
import '../../../../features/applications/presentation/providers/application_providers.dart';
import '../../../../features/opportunities/presentation/providers/opportunity_providers.dart';
import '../../../../features/opportunities/presentation/providers/recommended_opportunities_provider.dart';
import '../../domain/entities/student_profile_entity.dart';
import '../providers/student_profile_providers.dart';
import '../providers/student_profile_stats_provider.dart';
import '../widgets/stat_card.dart';

class StudentProfileScreen extends ConsumerWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final profileAsync = ref.watch(studentProfileByOwnerProvider(user.id));
    final statsAsync = ref.watch(studentProfileStatsProvider(user.id));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(studentProfileByOwnerProvider(user.id));
          ref.invalidate(studentProfileStatsProvider(user.id));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: profileAsync.when(
                data: (profile) => _Header(user: user, profile: profile),
                loading: () => const SizedBox(height: 260, child: LoadingIndicator()),
                error: (e, _) => ErrorView(message: e.toString()),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text('Statistics', style: AppTextStyles.titleSmall),
                  const SizedBox(height: 12),
                  statsAsync.when(
                    data: (stats) => _StatsGrid(stats: stats),
                    loading: () => const LoadingIndicator(),
                    error: (e, _) => ErrorView(message: e.toString()),
                  ),
                  const SizedBox(height: 28),
                  _UpcomingInterviewsSection(studentId: user.id),
                  const SizedBox(height: 28),
                  _RecommendedSection(studentId: user.id),
                  const SizedBox(height: 28),
                  _RecentlyViewedSection(studentId: user.id),
                  const SizedBox(height: 28),
                  Text('About Me', style: AppTextStyles.titleSmall),
                  const SizedBox(height: 12),
                  profileAsync.maybeWhen(
                    data: (profile) => profile == null
                        ? const _NoProfileYet()
                        : _AboutSection(profile: profile),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  profileAsync.maybeWhen(
                    data: (profile) => profile == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: 28),
                            child: _ResumeSection(profile: profile),
                          ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  profileAsync.maybeWhen(
                    data: (profile) => profile == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: 28),
                            child: _PortfolioSection(profile: profile),
                          ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  profileAsync.maybeWhen(
                    data: (profile) => profile == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(top: 28),
                            child: _ProjectsSection(profile: profile),
                          ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.user, required this.profile});

  final UserEntity user;
  final StudentProfileEntity? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completion = profile?.completionPercentage ?? 0;
    final isComplete = profile?.isComplete ?? false;
    final subtitle = [profile?.degree, profile?.yearOfStudy, profile?.location]
        .where((s) => s != null && s.isNotEmpty)
        .join(' • ');

    return GradientHeader(
      padding: const EdgeInsets.fromLTRB(20, 56, 12, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(photoUrl: profile?.photoUrl, name: user.displayName),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.displayName,
                            style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isComplete) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, color: Colors.white, size: 18),
                        ],
                      ],
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white.withValues(alpha: 0.85)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () => context.push('/student-profile/edit'),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit profile')),
                  PopupMenuItem(value: 'signout', child: Text('Sign out')),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    context.push('/student-profile/edit');
                  } else if (value == 'signout') {
                    ref.read(authControllerProvider.notifier).signOut();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Profile completion',
                style: AppTextStyles.labelSmall
                    .copyWith(color: Colors.white.withValues(alpha: 0.85)),
              ),
              const Spacer(),
              Text(
                '$completion%',
                style: AppTextStyles.labelLarge
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: completion / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photoUrl, required this.name});

  final String? photoUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 36,
      backgroundColor: Colors.white24,
      backgroundImage:
          photoUrl != null ? CachedNetworkImageProvider(photoUrl!) : null,
      child: photoUrl == null
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
            )
          : null,
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final StudentProfileStats stats;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.send_outlined, stats.submitted, 'Submitted', AppColors.primary),
      (Icons.fact_check_outlined, stats.shortlisted, 'Shortlisted', AppColors.statusScreening),
      (Icons.groups_outlined, stats.interviews, 'Interviews', AppColors.statusInterview),
      (Icons.check_circle_outline, stats.accepted, 'Accepted', AppColors.statusAccepted),
      (Icons.cancel_outlined, stats.rejected, 'Rejected', AppColors.statusRejected),
      (Icons.bookmark_outline, stats.saved, 'Saved', AppColors.secondary),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        for (var i = 0; i < items.length; i++)
          StatCard(
            icon: items[i].$1,
            value: items[i].$2,
            label: items[i].$3,
            color: items[i].$4,
            delay: Duration(milliseconds: i * 60),
          ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.profile});

  final StudentProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final hasAbout = profile.bio.isNotEmpty ||
        profile.careerInterests.isNotEmpty ||
        profile.personalStatement.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profile.bio.isNotEmpty) ...[
          Text(profile.bio, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 16),
        ],
        if (profile.careerInterests.isNotEmpty) ...[
          Text('Career interests', style: AppTextStyles.labelLarge),
          const SizedBox(height: 4),
          Text(profile.careerInterests, style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
        ],
        if (profile.personalStatement.isNotEmpty) ...[
          Text('Personal statement', style: AppTextStyles.labelLarge),
          const SizedBox(height: 4),
          Text(profile.personalStatement, style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
        ],
        if (!hasAbout)
          Text(
            'Add a bio to tell startups about yourself.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
        const SizedBox(height: 20),
        Text('Skills', style: AppTextStyles.titleSmall),
        const SizedBox(height: 12),
        if (profile.skills.isEmpty)
          Text(
            'No skills added yet.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.skills
                .map(
                  (s) => Chip(
                    label: Text(s),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
                    labelStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _ResumeSection extends ConsumerStatefulWidget {
  const _ResumeSection({required this.profile});

  final StudentProfileEntity profile;

  @override
  ConsumerState<_ResumeSection> createState() => _ResumeSectionState();
}

class _ResumeSectionState extends ConsumerState<_ResumeSection> {
  bool _uploading = false;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    final picked = result?.files.single;
    if (picked == null || picked.bytes == null) return;

    if (picked.bytes!.lengthInBytes > 10 * 1024 * 1024) {
      if (mounted) AppSnackBar.showError(context, 'Resume must be under 10MB.');
      return;
    }

    setState(() => _uploading = true);
    await ref.read(studentProfileControllerProvider.notifier).uploadResume(
          widget.profile.id,
          picked.bytes!,
          picked.name,
        );
    if (!mounted) return;
    setState(() => _uploading = false);

    final error = ref.read(studentProfileControllerProvider.notifier).getErrorMessage();
    if (error != null) {
      AppSnackBar.showError(context, error);
    } else {
      AppSnackBar.showSuccess(context, 'Resume uploaded.');
    }
  }

  Future<void> _openResume() async {
    final url = widget.profile.resumeUrl;
    if (url == null) return;
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      AppSnackBar.showError(context, 'Could not open resume.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final profile = widget.profile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resume', style: AppTextStyles.titleSmall),
        const SizedBox(height: 12),
        if (!profile.hasResume)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add your resume so startups can review your background alongside your application.',
                  style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _uploading ? null : _pickAndUpload,
                  icon: _uploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.upload_file_outlined),
                  label: Text(_uploading ? 'Uploading…' : 'Upload resume (PDF)'),
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.picture_as_pdf_outlined, color: colors.error),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.resumeFileName ?? 'Resume.pdf',
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (profile.resumeUploadedAt != null)
                            Text(
                              'Uploaded ${_formatDate(profile.resumeUploadedAt!)}',
                              style: AppTextStyles.caption,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openResume,
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: const Text('Preview'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openResume,
                        icon: const Icon(Icons.download_outlined, size: 18),
                        label: const Text('Download'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _uploading ? null : _pickAndUpload,
                    icon: _uploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh, size: 18),
                    label: Text(_uploading ? 'Uploading…' : 'Replace resume'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _PortfolioLink {
  const _PortfolioLink({required this.label, required this.icon, required this.color, required this.url});

  final String label;
  final IconData icon;
  final Color color;
  final String url;
}

class _PortfolioSection extends StatelessWidget {
  const _PortfolioSection({required this.profile});

  final StudentProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final links = <_PortfolioLink>[
      if (profile.portfolioUrl != null)
        _PortfolioLink(label: 'Portfolio', icon: Icons.language, color: colors.info, url: profile.portfolioUrl!),
      if (profile.githubUrl != null)
        _PortfolioLink(label: 'GitHub', icon: FontAwesomeIcons.github, color: colors.textPrimary, url: profile.githubUrl!),
      if (profile.linkedinUrl != null)
        _PortfolioLink(label: 'LinkedIn', icon: FontAwesomeIcons.linkedin, color: const Color(0xFF0A66C2), url: profile.linkedinUrl!),
      if (profile.behanceUrl != null)
        _PortfolioLink(label: 'Behance', icon: FontAwesomeIcons.behance, color: const Color(0xFF1769FF), url: profile.behanceUrl!),
      if (profile.dribbbleUrl != null)
        _PortfolioLink(label: 'Dribbble', icon: FontAwesomeIcons.dribbble, color: const Color(0xFFEA4C89), url: profile.dribbbleUrl!),
      if (profile.mediumUrl != null)
        _PortfolioLink(label: 'Medium', icon: FontAwesomeIcons.medium, color: colors.textPrimary, url: profile.mediumUrl!),
      if (profile.personalWebsiteUrl != null)
        _PortfolioLink(label: 'Personal site', icon: Icons.public, color: colors.accent, url: profile.personalWebsiteUrl!),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Portfolio & Links', style: AppTextStyles.titleSmall),
        const SizedBox(height: 12),
        if (links.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add your GitHub, LinkedIn, portfolio, or other links so startups can see your work.',
                  style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => context.push('/student-profile/edit'),
                  icon: const Icon(Icons.add_link),
                  label: const Text('Add links'),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: links.map((link) => _PortfolioCard(link: link)).toList(),
          ),
      ],
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard({required this.link});

  final _PortfolioLink link;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final uri = Uri.parse(link.url);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Container(
        width: 132,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: link.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(link.icon, size: 18, color: link.color),
            ),
            const SizedBox(height: 10),
            Text(link.label, style: AppTextStyles.labelLarge),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Visit',
                    style: AppTextStyles.caption.copyWith(color: colors.textHint),
                  ),
                ),
                Icon(Icons.arrow_outward, size: 12, color: colors.textHint),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({required this.profile});

  final StudentProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final projects = profile.projects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Projects', style: AppTextStyles.titleSmall),
            TextButton.icon(
              onPressed: () => context.push('/student-profile/projects'),
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Manage'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (projects.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Showcase what you\'ve built — add a project with a description, tech stack, and links.',
                  style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => context.push('/student-profile/projects'),
                  icon: const Icon(Icons.add),
                  label: const Text('Add project'),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < projects.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                _ProjectCard(project: projects[i]),
              ],
            ],
          ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (project.imageUrls.isNotEmpty)
            SizedBox(
              height: 160,
              child: PageView(
                children: [
                  for (final url in project.imageUrls)
                    CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const ColoredBox(color: Colors.black12),
                      errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name, style: AppTextStyles.titleMedium),
                if (project.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(project.description, style: AppTextStyles.bodySmall),
                ],
                if (project.technologies.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: project.technologies
                        .map((t) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colors.info.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                t,
                                style: AppTextStyles.labelSmall.copyWith(color: colors.info),
                              ),
                            ))
                        .toList(),
                  ),
                ],
                if (project.githubUrl != null || project.liveDemoUrl != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (project.githubUrl != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => launchUrl(
                              Uri.parse(project.githubUrl!),
                              mode: LaunchMode.externalApplication,
                            ),
                            icon: const Icon(FontAwesomeIcons.github, size: 16),
                            label: const Text('Code'),
                          ),
                        ),
                      if (project.githubUrl != null && project.liveDemoUrl != null)
                        const SizedBox(width: 10),
                      if (project.liveDemoUrl != null)
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => launchUrl(
                              Uri.parse(project.liveDemoUrl!),
                              mode: LaunchMode.externalApplication,
                            ),
                            icon: const Icon(Icons.launch, size: 16),
                            label: const Text('Live demo'),
                          ),
                        ),
                    ],
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

class _RecommendedSection extends ConsumerWidget {
  const _RecommendedSection({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final recommendationsAsync = ref.watch(recommendedOpportunitiesProvider(studentId));

    return recommendationsAsync.maybeWhen(
      data: (recommendations) {
        if (recommendations.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recommended For You', style: AppTextStyles.titleSmall),
            const SizedBox(height: 4),
            Text(
              'Based on your skills, location, and interests.',
              style: AppTextStyles.caption.copyWith(color: colors.textHint),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 236,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recommendations.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _RecommendedCard(
                  studentId: studentId,
                  recommendation: recommendations[i],
                ),
              ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _RecommendedCard extends ConsumerWidget {
  const _RecommendedCard({required this.studentId, required this.recommendation});

  final String studentId;
  final RecommendedOpportunity recommendation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final opportunity = recommendation.opportunity;
    final matchPercent = recommendation.matchPercent;
    final matchColor = matchPercent >= 80
        ? colors.success
        : matchPercent >= 50
            ? colors.accent
            : colors.textSecondary;

    final hasAppliedAsync = ref.watch(hasAppliedProvider((
      applicantId: studentId,
      opportunityId: opportunity.id,
    )));
    final hasApplied = hasAppliedAsync.valueOrNull ?? false;

    return GestureDetector(
      onTap: () => context.push('/opportunities/${opportunity.id}'),
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colors.info.withValues(alpha: 0.12),
                  backgroundImage: opportunity.startupLogoUrl != null
                      ? CachedNetworkImageProvider(opportunity.startupLogoUrl!)
                      : null,
                  child: opportunity.startupLogoUrl == null
                      ? Icon(Icons.business, size: 16, color: colors.info)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    opportunity.startupName,
                    style: AppTextStyles.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: matchColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$matchPercent% Match',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: matchColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              opportunity.title,
              style: AppTextStyles.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: colors.textHint),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    opportunity.isRemote ? 'Remote' : opportunity.location,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (recommendation.matchedSkills.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: recommendation.matchedSkills
                    .take(3)
                    .map((s) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            s,
                            style: AppTextStyles.labelSmall.copyWith(color: colors.success),
                          ),
                        ))
                    .toList(),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: hasApplied
                    ? null
                    : () => context.push('/opportunities/${opportunity.id}/apply'),
                child: Text(hasApplied ? 'Applied' : 'Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _timeAgo(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${(diff.inDays / 7).floor()}w ago';
}

class _RecentlyViewedSection extends ConsumerWidget {
  const _RecentlyViewedSection({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentlyViewedOpportunitiesProvider(studentId));

    return recentAsync.maybeWhen(
      data: (entries) {
        if (entries.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recently Viewed', style: AppTextStyles.titleSmall),
            const SizedBox(height: 12),
            SizedBox(
              height: 108,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _RecentlyViewedCard(entry: entries[i]),
              ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _RecentlyViewedCard extends StatelessWidget {
  const _RecentlyViewedCard({required this.entry});

  final RecentlyViewedEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final opportunity = entry.opportunity;

    return GestureDetector(
      onTap: () => context.push('/opportunities/${opportunity.id}'),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: colors.info.withValues(alpha: 0.12),
                  backgroundImage: opportunity.startupLogoUrl != null
                      ? CachedNetworkImageProvider(opportunity.startupLogoUrl!)
                      : null,
                  child: opportunity.startupLogoUrl == null
                      ? Icon(Icons.business, size: 14, color: colors.info)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    opportunity.startupName,
                    style: AppTextStyles.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              opportunity.title,
              style: AppTextStyles.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.history, size: 12, color: colors.textHint),
                const SizedBox(width: 4),
                Text(_timeAgo(entry.viewedAt), style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _googleCalendarUrl(ApplicationEntity application) {
  final start = application.interviewScheduledAt!.toUtc();
  final end = start.add(const Duration(hours: 1));
  final fmt = DateFormat("yyyyMMdd'T'HHmmss'Z'");

  final detailLines = <String>[
    if (application.meetingLink != null) 'Meeting link: ${application.meetingLink}',
    if (application.interviewNotes != null) application.interviewNotes!,
  ];

  final params = {
    'action': 'TEMPLATE',
    'text': 'Interview: ${application.opportunityTitle} at ${application.startupName}',
    'dates': '${fmt.format(start)}/${fmt.format(end)}',
    if (detailLines.isNotEmpty) 'details': detailLines.join('\n'),
    if (application.interviewLocation != null) 'location': application.interviewLocation!,
  };

  return Uri.https('calendar.google.com', '/calendar/render', params).toString();
}

class _UpcomingInterviewsSection extends ConsumerWidget {
  const _UpcomingInterviewsSection({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interviewsAsync = ref.watch(upcomingInterviewsProvider(studentId));

    return interviewsAsync.maybeWhen(
      data: (interviews) {
        if (interviews.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upcoming Interviews', style: AppTextStyles.titleSmall),
            const SizedBox(height: 12),
            Column(
              children: [
                for (var i = 0; i < interviews.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  _InterviewCard(application: interviews[i]),
                ],
              ],
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _InterviewCard extends StatelessWidget {
  const _InterviewCard({required this.application});

  final ApplicationEntity application;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scheduledAt = application.interviewScheduledAt!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.info.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(application.opportunityTitle, style: AppTextStyles.titleSmall),
          const SizedBox(height: 2),
          Text(
            application.startupName,
            style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            text: DateFormat.yMMMEd().format(scheduledAt),
          ),
          const SizedBox(height: 6),
          _DetailRow(
            icon: Icons.access_time_outlined,
            text: DateFormat.jm().format(scheduledAt),
          ),
          if (application.interviewLocation != null) ...[
            const SizedBox(height: 6),
            _DetailRow(
              icon: Icons.location_on_outlined,
              text: application.interviewLocation!,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (application.meetingLink != null) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse(application.meetingLink!),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.videocam_outlined, size: 16),
                    label: const Text('Join meeting'),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(_googleCalendarUrl(application)),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(Icons.calendar_month_outlined, size: 16),
                  label: const Text('Add to Calendar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 15, color: colors.textSecondary),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
      ],
    );
  }
}

class _NoProfileYet extends StatelessWidget {
  const _NoProfileYet();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Complete your profile', style: AppTextStyles.titleSmall),
          const SizedBox(height: 6),
          Text(
            'Add your bio, skills, and details so startups can get to know you.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () => context.push('/student-profile/edit'),
            child: const Text('Set up profile'),
          ),
        ],
      ),
    );
  }
}
