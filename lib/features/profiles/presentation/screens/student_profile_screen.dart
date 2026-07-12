import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
