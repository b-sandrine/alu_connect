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
import '../../domain/entities/student_profile_entity.dart';
import '../providers/student_profile_providers.dart';

class EditStudentProfileScreen extends ConsumerStatefulWidget {
  const EditStudentProfileScreen({super.key});

  @override
  ConsumerState<EditStudentProfileScreen> createState() =>
      _EditStudentProfileScreenState();
}

class _EditStudentProfileScreenState
    extends ConsumerState<EditStudentProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _universityController = TextEditingController();
  final _degreeController = TextEditingController();
  final _locationController = TextEditingController();
  final _bioController = TextEditingController();
  final _careerInterestsController = TextEditingController();
  final _personalStatementController = TextEditingController();
  final _skillController = TextEditingController();
  final _skillSearchController = TextEditingController();

  String? _selectedYear;
  Uint8List? _pickedPhotoBytes;
  final List<String> _skills = [];
  StudentProfileEntity? _existingProfile;
  bool _initialized = false;

  static const _years = ['Year 1', 'Year 2', 'Year 3', 'Year 4', 'Graduate'];

  @override
  void dispose() {
    _universityController.dispose();
    _degreeController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _careerInterestsController.dispose();
    _personalStatementController.dispose();
    _skillController.dispose();
    _skillSearchController.dispose();
    super.dispose();
  }

  void _populateFields(StudentProfileEntity profile) {
    if (_initialized) return;
    _universityController.text = profile.university;
    _degreeController.text = profile.degree;
    _locationController.text = profile.location;
    _bioController.text = profile.bio;
    _careerInterestsController.text = profile.careerInterests;
    _personalStatementController.text = profile.personalStatement;
    _selectedYear = profile.yearOfStudy.isEmpty ? null : profile.yearOfStudy;
    _skills.addAll(profile.skills);
    _existingProfile = profile;
    _initialized = true;
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

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _pickedPhotoBytes = bytes);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your year of study')),
      );
      return;
    }

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final now = DateTime.now();
    final profile = StudentProfileEntity(
      id: _existingProfile?.id ?? '',
      ownerId: user.id,
      photoUrl: _existingProfile?.photoUrl,
      university: _universityController.text.trim(),
      degree: _degreeController.text.trim(),
      yearOfStudy: _selectedYear!,
      location: _locationController.text.trim(),
      bio: _bioController.text.trim(),
      careerInterests: _careerInterestsController.text.trim(),
      personalStatement: _personalStatementController.text.trim(),
      skills: List.unmodifiable(_skills),
      createdAt: _existingProfile?.createdAt ?? now,
      updatedAt: now,
    );

    final controller = ref.read(studentProfileControllerProvider.notifier);
    await controller.saveProfile(profile);

    if (!mounted) return;
    final error = controller.getErrorMessage();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    if (_pickedPhotoBytes != null) {
      final savedProfile = ref.read(studentProfileControllerProvider).valueOrNull;
      final profileId = savedProfile?.id ?? _existingProfile?.id;
      if (profileId != null && profileId.isNotEmpty) {
        await controller.uploadPhoto(profileId, _pickedPhotoBytes!);
      }
    }

    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    if (user != null) {
      final profileAsync = ref.watch(studentProfileByOwnerProvider(user.id));
      profileAsync.whenData((p) {
        if (p != null) _populateFields(p);
      });
    }

    final isLoading = ref.watch(studentProfileControllerProvider).isLoading;
    final searchQuery = _skillSearchController.text.trim().toLowerCase();
    final visibleSkills = searchQuery.isEmpty
        ? _skills
        : _skills.where((s) => s.toLowerCase().contains(searchQuery)).toList();

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
              _PhotoPicker(
                currentPhotoUrl: _existingProfile?.photoUrl,
                pickedBytes: _pickedPhotoBytes,
                name: user?.displayName ?? '',
                onTap: _pickPhoto,
              ),
              const SizedBox(height: 24),
              AppTextField(
                label: 'University',
                controller: _universityController,
                prefixIcon: Icons.school_outlined,
                validator: (v) => Validators.required(v, fieldName: 'University'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Degree / Program',
                controller: _degreeController,
                prefixIcon: Icons.menu_book_outlined,
                validator: (v) => Validators.required(v, fieldName: 'Degree'),
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
                label: 'Location',
                controller: _locationController,
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => Validators.required(v, fieldName: 'Location'),
              ),
              const SizedBox(height: 24),
              Text('About Me', style: AppTextStyles.titleSmall),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Bio',
                hint: 'Tell startups about yourself...',
                controller: _bioController,
                maxLines: 4,
                validator: (v) => Validators.minLength(v, 20, fieldName: 'Bio'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Career interests',
                hint: 'e.g. Frontend development, Machine learning',
                controller: _careerInterestsController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Personal statement',
                hint: 'What drives you? What are you looking for?',
                controller: _personalStatementController,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Text('Skills', style: AppTextStyles.titleSmall),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Add a skill',
                      hint: 'e.g. Flutter, Firebase, UI Design',
                      controller: _skillController,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _addSkill(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(onPressed: _addSkill, icon: const Icon(Icons.add)),
                ],
              ),
              if (_skills.length > 4) ...[
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Search skills',
                  hint: 'Filter your skills',
                  controller: _skillSearchController,
                  prefixIcon: Icons.search,
                  onChanged: (_) => setState(() {}),
                ),
              ],
              if (_skills.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: visibleSkills
                      .map(
                        (s) => Chip(
                          label: Text(s),
                          onDeleted: () => _removeSkill(s),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
                          labelStyle:
                              AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
                        ),
                      )
                      .toList(),
                ),
              ],
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

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.currentPhotoUrl,
    required this.pickedBytes,
    required this.name,
    required this.onTap,
  });

  final String? currentPhotoUrl;
  final Uint8List? pickedBytes;
  final String name;
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
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: ClipOval(
                child: pickedBytes != null
                    ? Image.memory(pickedBytes!, fit: BoxFit.cover)
                    : currentPhotoUrl != null
                        ? Image.network(currentPhotoUrl!, fit: BoxFit.cover)
                        : Center(
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: AppTextStyles.displayMedium
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Tap to upload photo', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
