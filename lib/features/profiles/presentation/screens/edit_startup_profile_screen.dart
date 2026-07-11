import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../domain/entities/startup_profile_entity.dart';
import '../providers/startup_profile_providers.dart';

class EditStartupProfileScreen extends ConsumerStatefulWidget {
  const EditStartupProfileScreen({super.key});

  @override
  ConsumerState<EditStartupProfileScreen> createState() =>
      _EditStartupProfileScreenState();
}

class _EditStartupProfileScreenState
    extends ConsumerState<EditStartupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _websiteController = TextEditingController();
  final _locationController = TextEditingController();
  final _foundedController = TextEditingController();
  final _missionController = TextEditingController();
  final _visionController = TextEditingController();
  final _cultureController = TextEditingController();

  String? _selectedIndustry;
  String? _selectedStage;
  String? _selectedCompanySize;
  Uint8List? _pickedLogoBytes;
  StartupProfileEntity? _existingProfile;
  bool _initialized = false;

  static const _industries = [
    'Technology', 'FinTech', 'HealthTech', 'EdTech', 'AgriTech',
    'CleanTech', 'E-commerce', 'Logistics', 'Media', 'Other',
  ];

  @override
  void dispose() {
    _companyNameController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    _foundedController.dispose();
    _missionController.dispose();
    _visionController.dispose();
    _cultureController.dispose();
    super.dispose();
  }

  void _populateFields(StartupProfileEntity profile) {
    if (_initialized) return;
    _companyNameController.text = profile.companyName;
    _taglineController.text = profile.tagline;
    _descriptionController.text = profile.description;
    _locationController.text = profile.location;
    _websiteController.text = profile.website ?? '';
    _foundedController.text = profile.founded?.toString() ?? '';
    _missionController.text = profile.mission;
    _visionController.text = profile.vision;
    _cultureController.text = profile.culture;
    _selectedIndustry = profile.industry;
    _selectedStage = profile.startupStage.isEmpty ? null : profile.startupStage;
    _selectedCompanySize =
        profile.companySize.isEmpty ? null : profile.companySize;
    _existingProfile = profile;
    _initialized = true;
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _pickedLogoBytes = bytes);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedIndustry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an industry')),
      );
      return;
    }

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final now = DateTime.now();
    final profile = StartupProfileEntity(
      id: _existingProfile?.id ?? '',
      ownerId: user.id,
      companyName: _companyNameController.text.trim(),
      tagline: _taglineController.text.trim(),
      description: _descriptionController.text.trim(),
      industry: _selectedIndustry!,
      location: _locationController.text.trim(),
      website: _websiteController.text.trim().isEmpty
          ? null
          : _websiteController.text.trim(),
      logoUrl: _existingProfile?.logoUrl,
      isVerified: _existingProfile?.isVerified ?? false,
      founded: int.tryParse(_foundedController.text.trim()),
      startupStage: _selectedStage ?? '',
      companySize: _selectedCompanySize ?? '',
      mission: _missionController.text.trim(),
      vision: _visionController.text.trim(),
      culture: _cultureController.text.trim(),
      createdAt: _existingProfile?.createdAt ?? now,
      updatedAt: now,
    );

    final controller = ref.read(startupProfileControllerProvider.notifier);
    await controller.saveProfile(profile);

    if (!mounted) return;
    final error = controller.getErrorMessage();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    if (_pickedLogoBytes != null && _existingProfile != null) {
      await controller.uploadLogo(_existingProfile!.id, _pickedLogoBytes!);
    }

    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    if (user != null) {
      final profileAsync = ref.watch(startupProfileByOwnerProvider(user.id));
      profileAsync.whenData((p) {
        if (p != null) _populateFields(p);
      });
    }

    final isLoading = ref.watch(startupProfileControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LogoPicker(
                currentLogoUrl: _existingProfile?.logoUrl,
                pickedBytes: _pickedLogoBytes,
                onTap: _pickLogo,
              ),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Company name',
                controller: _companyNameController,
                prefixIcon: Icons.business_outlined,
                validator: (v) =>
                    Validators.required(v, fieldName: 'Company name'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Tagline',
                controller: _taglineController,
                prefixIcon: Icons.short_text,
                validator: (v) => Validators.required(v, fieldName: 'Tagline'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedIndustry,
                decoration: const InputDecoration(
                  labelText: 'Industry',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _industries
                    .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                    .toList(),
                onChanged: (v) => _selectedIndustry = v,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Location',
                controller: _locationController,
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => Validators.required(v, fieldName: 'Location'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Website (optional)',
                controller: _websiteController,
                keyboardType: TextInputType.url,
                prefixIcon: Icons.language,
                validator: Validators.url,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Founded (year)',
                      controller: _foundedController,
                      prefixIcon: Icons.event_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        final year = int.tryParse(v.trim());
                        if (year == null || year < 1900 || year > DateTime.now().year) {
                          return 'Enter a valid year';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCompanySize,
                      decoration: const InputDecoration(
                        labelText: 'Company size',
                        prefixIcon: Icon(Icons.groups_outlined),
                      ),
                      items: StartupProfileEntity.companySizes
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => _selectedCompanySize = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedStage,
                decoration: const InputDecoration(
                  labelText: 'Startup stage',
                  prefixIcon: Icon(Icons.rocket_launch_outlined),
                ),
                items: StartupProfileEntity.stages
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => _selectedStage = v,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'About your startup',
                controller: _descriptionController,
                maxLines: 4,
                validator: (v) =>
                    Validators.minLength(v, 50, fieldName: 'Description'),
              ),
              const SizedBox(height: 24),
              Text('Mission, vision & culture', style: AppTextStyles.titleSmall),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Mission (optional)',
                hint: 'What is your startup working to achieve?',
                controller: _missionController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Vision (optional)',
                hint: 'Where is your startup headed?',
                controller: _visionController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Culture (optional)',
                hint: 'What is it like to work at your startup?',
                controller: _cultureController,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Save changes',
                onPressed: _save,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoPicker extends StatelessWidget {
  const _LogoPicker({
    required this.currentLogoUrl,
    required this.pickedBytes,
    required this.onTap,
  });

  final String? currentLogoUrl;
  final Uint8List? pickedBytes;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: pickedBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(pickedBytes!, fit: BoxFit.cover),
                    )
                  : currentLogoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(currentLogoUrl!, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.add_a_photo_outlined,
                          size: 32, color: AppColors.textHint),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to upload logo',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
