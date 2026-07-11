import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/auth_controller.dart';
import '../providers/auth_providers.dart';
import '../widgets/onboarding_header.dart';

class StartupOnboardingScreen extends ConsumerStatefulWidget {
  const StartupOnboardingScreen({super.key});

  @override
  ConsumerState<StartupOnboardingScreen> createState() =>
      _StartupOnboardingScreenState();
}

class _StartupOnboardingScreenState
    extends ConsumerState<StartupOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _websiteController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedIndustry;

  static const _industries = [
    'Technology',
    'FinTech',
    'HealthTech',
    'EdTech',
    'AgriTech',
    'CleanTech',
    'E-commerce',
    'Logistics',
    'Media',
    'Other',
  ];

  @override
  void dispose() {
    _companyNameController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedIndustry == null) {
      AppSnackBar.showError(context, 'Please select your industry');
      return;
    }

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

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
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const OnboardingHeader(
              title: 'Set up your startup',
              subtitle: 'Help students learn about your company',
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
                              label: 'Company name',
                              hint: 'e.g. Acme Technologies',
                              controller: _companyNameController,
                              prefixIcon: Icons.business_outlined,
                              validator: (v) => Validators.required(v,
                                  fieldName: 'Company name'),
                            )
                                .animate()
                                .fadeIn(duration: 250.ms)
                                .slideY(begin: 0.08, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              label: 'Tagline',
                              hint: 'One-line description of what you do',
                              controller: _taglineController,
                              prefixIcon: Icons.short_text,
                              validator: (v) =>
                                  Validators.required(v, fieldName: 'Tagline'),
                            )
                                .animate()
                                .fadeIn(duration: 250.ms, delay: 40.ms)
                                .slideY(begin: 0.08, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedIndustry,
                              decoration: const InputDecoration(
                                labelText: 'Industry',
                                prefixIcon: Icon(Icons.category_outlined),
                              ),
                              items: _industries
                                  .map((i) => DropdownMenuItem(
                                      value: i, child: Text(i)))
                                  .toList(),
                              onChanged: (v) => _selectedIndustry = v,
                            )
                                .animate()
                                .fadeIn(duration: 250.ms, delay: 80.ms)
                                .slideY(begin: 0.08, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              label: 'Location',
                              hint: 'e.g. Kigali, Rwanda',
                              controller: _locationController,
                              prefixIcon: Icons.location_on_outlined,
                              validator: (v) =>
                                  Validators.required(v, fieldName: 'Location'),
                            )
                                .animate()
                                .fadeIn(duration: 250.ms, delay: 120.ms)
                                .slideY(begin: 0.08, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              label: 'Website (optional)',
                              hint: 'https://yourcompany.com',
                              controller: _websiteController,
                              keyboardType: TextInputType.url,
                              prefixIcon: Icons.language,
                              validator: Validators.url,
                            )
                                .animate()
                                .fadeIn(duration: 250.ms, delay: 160.ms)
                                .slideY(begin: 0.08, end: 0),
                            const SizedBox(height: AppSpacing.lg),
                            AppTextField(
                              label: 'About your startup',
                              hint:
                                  'Describe your mission, product, and team...',
                              controller: _descriptionController,
                              maxLines: 4,
                              validator: (v) => Validators.minLength(v, 50,
                                  fieldName: 'Description'),
                            )
                                .animate()
                                .fadeIn(duration: 250.ms, delay: 200.ms)
                                .slideY(begin: 0.08, end: 0),
                            const SizedBox(height: AppSpacing.xxl),
                            AppButton(
                              label: 'Complete setup',
                              onPressed: _complete,
                              isLoading: isLoading,
                              useGradient: true,
                            ).animate().fadeIn(duration: 250.ms, delay: 240.ms),
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
