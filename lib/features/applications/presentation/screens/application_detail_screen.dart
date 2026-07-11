import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../domain/entities/application_entity.dart';
import '../providers/application_providers.dart';
import '../widgets/application_timeline.dart';

class ApplicationDetailScreen extends ConsumerWidget {
  const ApplicationDetailScreen({super.key, required this.applicationId});

  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    final applicationsAsync = ref.watch(applicantApplicationsProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Application')),
      body: applicationsAsync.when(
        data: (applications) {
          final application = applications
              .where((a) => a.id == applicationId)
              .cast<ApplicationEntity?>()
              .firstWhere((a) => a != null, orElse: () => null);

          if (application == null) {
            return const Center(child: Text('Application not found.'));
          }
          return _Detail(application: application);
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.application});

  final ApplicationEntity application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(applicationControllerProvider).isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(application.opportunityTitle, style: AppTextStyles.titleLarge),
          const SizedBox(height: 4),
          Text(application.startupName,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 28),
          Text('Status', style: AppTextStyles.titleSmall),
          const SizedBox(height: 16),
          ApplicationTimeline(application: application),
          if (application.interviewScheduledAt != null) ...[
            const SizedBox(height: 8),
            _InfoCard(
              icon: Icons.event_outlined,
              title: 'Interview scheduled',
              lines: [
                DateFormat.yMMMd().add_jm().format(application.interviewScheduledAt!),
                if (application.interviewLocation != null)
                  application.interviewLocation!,
                if (application.interviewNotes != null) application.interviewNotes!,
              ],
            ),
          ],
          if (application.status == ApplicationStatus.offer) ...[
            const SizedBox(height: 8),
            _InfoCard(
              icon: Icons.card_giftcard_outlined,
              title: 'Offer',
              lines: [
                if (application.offerNote != null) application.offerNote!,
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () => ref
                            .read(applicationControllerProvider.notifier)
                            .declineOffer(application),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: isLoading
                        ? null
                        : () => ref
                            .read(applicationControllerProvider.notifier)
                            .acceptOffer(application),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                    child: const Text('Accept offer'),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 28),
          Text('Cover letter', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Text(application.coverLetter, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.lines});

  final IconData icon;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.titleSmall),
            ],
          ),
          for (final line in lines) ...[
            const SizedBox(height: 6),
            Text(line, style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }
}
