import 'dart:io';

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

  String? _selectedIndustry;
  File? _pickedLogo;
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
    super.dispose();
  }

  void _populateFields(StartupProfileEntity profile) {
    if (_initialized) return;
    _companyNameController.text = profile.companyName;
    _taglineController.text = profile.tagline;
    _descriptionController.text = profile.description;
    _locationController.text = profile.location;
    _websiteController.text = profile.website ?? '';
    _selectedIndustry = profile.industry;
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
      setState(() => _pickedLogo = File(picked.path));
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

    if (_pickedLogo != null && _existingProfile != null) {
      await controller.uploadLogo(_existingProfile!.id, _pickedLogo!);
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
                pickedFile: _pickedLogo,
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
              AppTextField(
                label: 'About your startup',
                controller: _descriptionController,
                maxLines: 4,
                validator: (v) =>
                    Validators.minLength(v, 50, fieldName: 'Description'),
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
    required this.pickedFile,
    required this.onTap,
  });

  final String? currentLogoUrl;
  final File? pickedFile;
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
              child: pickedFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(pickedFile!, fit: BoxFit.cover),
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
