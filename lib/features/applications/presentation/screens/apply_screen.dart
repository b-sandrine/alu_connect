import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/opportunities/domain/entities/opportunity_entity.dart';
import '../../../../features/opportunities/presentation/providers/opportunity_providers.dart';
import '../../domain/entities/application_entity.dart';
import '../providers/application_providers.dart';

class ApplyScreen extends ConsumerStatefulWidget {
  const ApplyScreen({super.key, required this.opportunityId});

  final String opportunityId;

  @override
  ConsumerState<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends ConsumerState<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _coverLetterController = TextEditingController();

  @override
  void dispose() {
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _submit(OpportunityEntity opportunity) async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final alreadyApplied = await ref.read(
      hasAppliedProvider((
        applicantId: user.id,
        opportunityId: widget.opportunityId,
      )).future,
    );

    if (!mounted) return;
    if (alreadyApplied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already applied to this opportunity.'),
        ),
      );
      return;
    }

    final application = ApplicationEntity(
      id: '',
      opportunityId: opportunity.id,
      opportunityTitle: opportunity.title,
      startupId: opportunity.startupId,
      startupName: opportunity.startupName,
      applicantId: user.id,
      applicantName: user.displayName,
      coverLetter: _coverLetterController.text.trim(),
      status: ApplicationStatus.applied,
      appliedAt: DateTime.now(),
    );

    await ref
        .read(applicationControllerProvider.notifier)
        .submitApplication(application);

    if (!mounted) return;
    final error =
        ref.read(applicationControllerProvider.notifier).getErrorMessage();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application submitted successfully!')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final opportunityAsync =
        ref.watch(_opportunityDetailProvider(widget.opportunityId));
    final isLoading = ref.watch(applicationControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Apply')),
      body: opportunityAsync.when(
        data: (opportunity) => _Form(
          opportunity: opportunity,
          coverLetterController: _coverLetterController,
          formKey: _formKey,
          isLoading: isLoading,
          onSubmit: () => _submit(opportunity),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

// Uses the same provider as OpportunityDetailScreen to avoid duplicate fetch
final _opportunityDetailProvider =
    FutureProvider.family<OpportunityEntity, String>((ref, id) {
  return ref.watch(opportunityRepositoryProvider).getOpportunityById(id);
});

class _Form extends StatelessWidget {
  const _Form({
    required this.opportunity,
    required this.coverLetterController,
    required this.formKey,
    required this.isLoading,
    required this.onSubmit,
  });

  final OpportunityEntity opportunity;
  final TextEditingController coverLetterController;
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OpportunitySummary(opportunity: opportunity),
            const SizedBox(height: 28),
            Text('Cover letter', style: AppTextStyles.titleSmall),
            const SizedBox(height: 4),
            Text(
              'Tell the startup why you are a great fit for this role.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Cover letter',
              hint:
                  'Describe your interest, relevant experience, and what you bring to this role...',
              controller: coverLetterController,
              maxLines: 8,
              validator: (v) =>
                  Validators.minLength(v, 100, fieldName: 'Cover letter'),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ValueListenableBuilder(
                valueListenable: coverLetterController,
                builder: (_, value, __) => Text(
                  '${value.text.length} characters',
                  style: AppTextStyles.caption,
                ),
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Submit application',
              onPressed: onSubmit,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _OpportunitySummary extends StatelessWidget {
  const _OpportunitySummary({required this.opportunity});

  final OpportunityEntity opportunity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(opportunity.title, style: AppTextStyles.titleMedium),
          const SizedBox(height: 4),
          Text(opportunity.startupName,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
              )),
        ],
      ),
    );
  }
}
