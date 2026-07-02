import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
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
    'Year 1', 'Year 2', 'Year 3', 'Year 4', 'Graduate',
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your year of study')),
      );
      return;
    }

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    // Save profile data to Firestore via a dedicated provider (created in profiles feature)
    // For now, just mark onboarding complete
    await ref.read(authControllerProvider.notifier).completeOnboarding(user.id);

    if (!mounted) return;
    final error = ref.read(authControllerProvider.notifier).getErrorMessage();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ref.invalidate(authStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingHeader(
              title: 'Set up your profile',
              subtitle: 'Help startups learn more about you',
              step: '1 of 1',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
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
                        validator: (v) =>
                            Validators.required(v, fieldName: 'University'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Program / Major',
                        hint: 'e.g. Software Engineering',
                        controller: _programController,
                        prefixIcon: Icons.menu_book_outlined,
                        validator: (v) =>
                            Validators.required(v, fieldName: 'Program'),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedYear,
                        decoration: const InputDecoration(
                          labelText: 'Year of study',
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        items: _years
                            .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                            .toList(),
                        onChanged: (v) => _selectedYear = v,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Bio',
                        hint: 'Tell startups about yourself...',
                        controller: _bioController,
                        maxLines: 3,
                        validator: (v) =>
                            Validators.minLength(v, 20, fieldName: 'Bio'),
                      ),
                      const SizedBox(height: 24),
                      Text('Skills', style: AppTextStyles.titleSmall),
                      const SizedBox(height: 8),
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
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: _addSkill,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      if (_skills.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _skills
                              .map(
                                (s) => Chip(
                                  label: Text(s),
                                  onDeleted: () => _removeSkill(s),
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 32),
                      AppButton(
                        label: 'Complete setup',
                        onPressed: _complete,
                        isLoading: isLoading,
                      ),
                    ],
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

