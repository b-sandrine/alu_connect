import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/opportunity_entity.dart';

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
    this.trailing,
  });

  final OpportunityEntity opportunity;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _StartupLogo(logoUrl: opportunity.startupLogoUrl),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opportunity.startupName,
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          opportunity.title,
                          style: AppTextStyles.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _TypeChip(type: opportunity.type),
                  if (opportunity.isRemote)
                    const _SmallChip(
                      label: 'Remote',
                      color: AppColors.success,
                    ),
                  _SmallChip(
                    label: opportunity.location,
                    color: AppColors.textSecondary,
                    icon: Icons.location_on_outlined,
                  ),
                ],
              ),
              if (opportunity.requiredSkills.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: opportunity.requiredSkills
                      .take(3)
                      .map((s) => _SkillChip(skill: s))
                      .toList(),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 14, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(
                    'Deadline: ${DateFormat.yMMMd().format(opportunity.deadline)}',
                    style: AppTextStyles.caption,
                  ),
                  const Spacer(),
                  if (opportunity.compensation != null)
                    Text(
                      opportunity.compensation!,
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.success),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartupLogo extends StatelessWidget {
  const _StartupLogo({required this.logoUrl});
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: const Icon(Icons.business, size: 20, color: AppColors.textHint),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});
  final OpportunityType type;

  static const _labels = {
    OpportunityType.internship: 'Internship',
    OpportunityType.partTime: 'Part-time',
    OpportunityType.fullTime: 'Full-time',
    OpportunityType.contract: 'Contract',
    OpportunityType.volunteer: 'Volunteer',
  };

  static const _colors = {
    OpportunityType.internship: AppColors.primary,
    OpportunityType.partTime: AppColors.secondary,
    OpportunityType.fullTime: AppColors.accent,
    OpportunityType.contract: AppColors.info,
    OpportunityType.volunteer: AppColors.warning,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[type] ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _labels[type] ?? type.name,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  const _SmallChip({required this.label, required this.color, this.icon});
  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
        ],
        Text(label, style: AppTextStyles.caption.copyWith(color: color)),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.skill});
  final String skill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(skill, style: AppTextStyles.caption),
    );
  }
}
