import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../profiles/domain/entities/student_profile_entity.dart';
import '../../../profiles/presentation/providers/student_profile_providers.dart';
import '../providers/auth_controller.dart';
import '../providers/auth_providers.dart';
import '../widgets/onboarding_header.dart';

class StudentOnboardingScreen extends ConsumerStatefulWidget {
  const StudentOnboardingScreen({super.key});

  @override
  ConsumerState<StudentOnboardingScreen> createState() =>
      _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState
    extends ConsumerState<StudentOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _universityController = TextEditingController();
  final _programController = TextEditingController();
  final _skillController = TextEditingController();

  final List<String> _skills = [];
  String? _selectedYear;

  static const _years = [
    'Year 1',
    'Year 2',
    'Year 3',
    'Year 4',
    'Graduate',
  ];

  @override
  void dispose() {
    _bioController.dispose();
    _universityController.dispose();
    _programController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isEmpty || _skills.contains(skill)) return;
    setState(() => _skills.add(skill));
    _skillController.clear();
  }

  void _removeSkill(String skill) {
    setState(() => _skills.remove(skill));
  }

  Future<void> _complete() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedYear == null) {
      AppSnackBar.showError(context, 'Please select your year of study');
      return;
    }

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final now = DateTime.now();
    await ref.read(studentProfileControllerProvider.notifier).saveProfile(
          StudentProfileEntity(
            id: '',
            ownerId: user.id,
            university: _universityController.text.trim(),
            degree: _programController.text.trim(),
            yearOfStudy: _selectedYear!,
            location: '',
            bio: _bioController.text.trim(),
            skills: List.unmodifiable(_skills),
            createdAt: now,
            updatedAt: now,
          ),
        );

    if (!mounted) return;
    final profileError =
        ref.read(studentProfileControllerProvider.notifier).getErrorMessage();
    if (profileError != null) {
      AppSnackBar.showError(context, profileError);
      return;
    }

    await ref.read(authControllerProvider.notifier).completeOnboarding(user.id);

    if (!mounted) return;
    final error = ref.read(authControllerProvider.notifier).getErrorMessage();
    if (error != null) {
      AppSnackBar.showError(context, error);
      return;
    }

    ref.invalidate(authStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading ||
        ref.watch(studentProfileControllerProvider).isLoading;
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const OnboardingHeader(
              title: 'Set up your profile',
              subtitle: 'Help startups learn more about you',
              step: '1 of 1',
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              label: 'University',
                              hint: 'e.g. African Leadership University',
                              controller: _universityController,
                              prefixIcon: Icons.school_outlined,
                              validator: (v) => Validators.required(v,
                                  fieldName: 'University'),
                            )
                                .animate()
                                .fadeIn(duration: 250.ms)
                                .slideY(begin: 0.08, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              label: 'Program / Major',
                              hint: 'e.g. Software Engineering',
                              controller: _programController,
                              prefixIcon: Icons.menu_book_outlined,
                              validator: (v) =>
                                  Validators.required(v, fieldName: 'Program'),
                            )
                                .animate()
                                .fadeIn(duration: 250.ms, delay: 40.ms)
                                .slideY(begin: 0.08, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedYear,
                              decoration: const InputDecoration(
                                labelText: 'Year of study',
                                prefixIcon: Icon(Icons.calendar_today_outlined),
                              ),
                              items: _years
                                  .map((y) => DropdownMenuItem(
                                      value: y, child: Text(y)))
                                  .toList(),
                              onChanged: (v) => _selectedYear = v,
                            )
                                .animate()
                                .fadeIn(duration: 250.ms, delay: 80.ms)
                                .slideY(begin: 0.08, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              label: 'Bio',
                              hint: 'Tell startups about yourself...',
                              controller: _bioController,
                              maxLines: 3,
                              validator: (v) =>
                                  Validators.minLength(v, 20, fieldName: 'Bio'),
                            )
                                .animate()
                                .fadeIn(duration: 250.ms, delay: 120.ms)
                                .slideY(begin: 0.08, end: 0),
                            const SizedBox(height: AppSpacing.xl),
                            Text(
                              'Skills',
                              style: AppTextStyles.titleSmall
                                  .copyWith(color: colors.textPrimary),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    label: 'Add a skill',
                                    hint: 'e.g. Flutter, Python',
                                    controller: _skillController,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _addSkill(),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                IconButton.filled(
                                  onPressed: _addSkill,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            if (_skills.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.md),
                              Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                children: _skills
                                    .map(
                                      (s) => Chip(
                                        label: Text(s),
                                        onDeleted: () => _removeSkill(s),
                                        deleteIcon:
                                            const Icon(Icons.close, size: 16),
                                      )
                                          .animate()
                                          .fadeIn(duration: 200.ms)
                                          .scale(begin: const Offset(0.9, 0.9)),
                                    )
                                    .toList(),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.xxl),
                            AppButton(
                              label: 'Complete setup',
                              onPressed: _complete,
                              isLoading: isLoading,
                              useGradient: true,
                            ).animate().fadeIn(duration: 250.ms, delay: 160.ms),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
