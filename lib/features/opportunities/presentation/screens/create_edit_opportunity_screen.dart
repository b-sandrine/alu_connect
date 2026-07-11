import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../features/authentication/presentation/providers/auth_providers.dart';
import '../../../../features/profiles/presentation/providers/startup_profile_providers.dart';
import '../../domain/entities/opportunity_entity.dart';
import '../providers/opportunity_providers.dart';

class CreateEditOpportunityScreen extends ConsumerStatefulWidget {
  const CreateEditOpportunityScreen({super.key, this.existing});

  final OpportunityEntity? existing;

  @override
  ConsumerState<CreateEditOpportunityScreen> createState() =>
      _CreateEditOpportunityScreenState();
}

class _CreateEditOpportunityScreenState
    extends ConsumerState<CreateEditOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _compensationController = TextEditingController();
  final _skillController = TextEditingController();

  OpportunityType _selectedType = OpportunityType.internship;
  OpportunityCategory _selectedCategory = OpportunityCategory.engineering;
  bool _isRemote = false;
  DateTime? _deadline;
  final List<String> _skills = [];

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _titleController.text = e.title;
      _descriptionController.text = e.description;
      _locationController.text = e.location;
      _compensationController.text = e.compensation ?? '';
      _selectedType = e.type;
      _selectedCategory = e.category;
      _isRemote = e.isRemote;
      _deadline = e.deadline;
      _skills.addAll(e.requiredSkills);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _compensationController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isEmpty || _skills.contains(skill)) return;
    setState(() => _skills.add(skill));
    _skillController.clear();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a deadline')),
      );
      return;
    }

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final profileAsync =
        ref.read(startupProfileByOwnerProvider(user.id));
    final profile = profileAsync.value;

    final now = DateTime.now();
    final opportunity = OpportunityEntity(
      id: widget.existing?.id ?? '',
      startupId: user.id,
      startupName: profile?.companyName ?? user.displayName,
      startupLogoUrl: profile?.logoUrl,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _selectedType,
      category: _selectedCategory,
      requiredSkills: List.unmodifiable(_skills),
      location: _locationController.text.trim(),
      isRemote: _isRemote,
      deadline: _deadline!,
      compensation: _compensationController.text.trim().isEmpty
          ? null
          : _compensationController.text.trim(),
      createdAt: widget.existing?.createdAt ?? now,
      updatedAt: now,
      isActive: true,
    );

    final controller = ref.read(opportunityControllerProvider.notifier);
    if (_isEditing) {
      await controller.updateOpportunity(opportunity);
    } else {
      await controller.createOpportunity(opportunity);
    }

    if (!mounted) return;
    final error = controller.getErrorMessage();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(opportunityControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Opportunity' : 'Post Opportunity'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Title',
                hint: 'e.g. Flutter Developer Intern',
                controller: _titleController,
                validator: (v) => Validators.required(v, fieldName: 'Title'),
              ),
              const SizedBox(height: 16),
              _TypeDropdown(
                value: _selectedType,
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(height: 16),
              _CategoryDropdown(
                value: _selectedCategory,
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Location',
                hint: 'e.g. Kigali, Rwanda',
                controller: _locationController,
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => Validators.required(v, fieldName: 'Location'),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Remote position'),
                value: _isRemote,
                onChanged: (v) => setState(() => _isRemote = v),
              ),
              const SizedBox(height: 8),
              AppTextField(
                label: 'Compensation (optional)',
                hint: 'e.g. \$500/month, Unpaid',
                controller: _compensationController,
                prefixIcon: Icons.payments_outlined,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDeadline,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Application deadline',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _deadline == null
                        ? 'Select a date'
                        : DateFormat.yMMMd().format(_deadline!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Description',
                hint: 'Describe the role, responsibilities, and requirements...',
                controller: _descriptionController,
                maxLines: 5,
                validator: (v) =>
                    Validators.minLength(v, 50, fieldName: 'Description'),
              ),
              const SizedBox(height: 16),
              _SkillsInput(
                controller: _skillController,
                skills: _skills,
                onAdd: _addSkill,
                onRemove: (s) => setState(() => _skills.remove(s)),
              ),
              const SizedBox(height: 32),
              AppButton(
                label: _isEditing ? 'Save changes' : 'Post opportunity',
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

class _TypeDropdown extends StatelessWidget {
  const _TypeDropdown({required this.value, required this.onChanged});
  final OpportunityType value;
  final ValueChanged<OpportunityType?> onChanged;

  static const _labels = {
    OpportunityType.internship: 'Internship',
    OpportunityType.partTime: 'Part-time',
    OpportunityType.fullTime: 'Full-time',
    OpportunityType.contract: 'Contract',
    OpportunityType.volunteer: 'Volunteer',
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<OpportunityType>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Type'),
      items: OpportunityType.values
          .map((t) => DropdownMenuItem(value: t, child: Text(_labels[t] ?? t.name)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({required this.value, required this.onChanged});
  final OpportunityCategory value;
  final ValueChanged<OpportunityCategory?> onChanged;

  static const _labels = {
    OpportunityCategory.engineering: 'Engineering',
    OpportunityCategory.design: 'Design',
    OpportunityCategory.marketing: 'Marketing',
    OpportunityCategory.business: 'Business',
    OpportunityCategory.research: 'Research',
    OpportunityCategory.other: 'Other',
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<OpportunityCategory>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Category'),
      items: OpportunityCategory.values
          .map((c) => DropdownMenuItem(value: c, child: Text(_labels[c] ?? c.name)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _SkillsInput extends StatelessWidget {
  const _SkillsInput({
    required this.controller,
    required this.skills,
    required this.onAdd,
    required this.onRemove,
  });

  final TextEditingController controller;
  final List<String> skills;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Required skills',
                hint: 'e.g. Flutter, Python',
                controller: controller,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => onAdd(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(onPressed: onAdd, icon: const Icon(Icons.add)),
          ],
        ),
        if (skills.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map(
                  (s) => Chip(
                    label: Text(s),
                    onDeleted: () => onRemove(s),
                    deleteIcon: const Icon(Icons.close, size: 16),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
