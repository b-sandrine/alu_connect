import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../domain/entities/opportunity_entity.dart';
import '../providers/opportunity_providers.dart';
import '../widgets/opportunity_card.dart';

class OpportunitiesScreen extends ConsumerStatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  ConsumerState<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends ConsumerState<OpportunitiesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final current = ref.read(opportunityFilterProvider);
    ref.read(opportunityFilterProvider.notifier).state = current.copyWith(
      query: query.isEmpty ? null : query,
    );
  }

  void _clearFilters() {
    _searchController.clear();
    ref.read(opportunityFilterProvider.notifier).state =
        const OpportunityFilter();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredOpportunitiesProvider);
    final filter = ref.watch(opportunityFilterProvider);

    return Column(
      children: [
        _SearchBar(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onFilter: () => _showFilterSheet(context),
          hasActiveFilters: filter.hasActiveFilters,
        ),
        Expanded(
          child: filteredAsync.when(
            data: (opportunities) {
              if (opportunities.isEmpty) {
                return _EmptyState(
                  hasFilters: filter.hasActiveFilters,
                  onClear: _clearFilters,
                );
              }
              final hasMore = ref.watch(hasMoreOpportunitiesProvider);
              final itemCount = opportunities.length + (hasMore ? 1 : 0);

              return RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(opportunitiesStreamProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: itemCount,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    if (index >= opportunities.length) {
                      return Center(
                        child: TextButton(
                          onPressed: () => loadMoreOpportunities(ref),
                          child: const Text('Load more'),
                        ),
                      );
                    }
                    return OpportunityCard(
                      opportunity: opportunities[index],
                      onTap: () => context
                          .push('/opportunities/${opportunities[index].id}'),
                    );
                  },
                ),
              );
            },
            loading: () => const LoadingIndicator(),
            error: (e, _) => ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(opportunitiesStreamProvider),
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _FilterSheet(),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onFilter,
    required this.hasActiveFilters,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;
  final bool hasActiveFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Search opportunities...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          onChanged('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Badge(
            isLabelVisible: hasActiveFilters,
            child: IconButton.outlined(
              onPressed: onFilter,
              icon: const Icon(Icons.tune),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilters, required this.onClear});

  final bool hasFilters;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              hasFilters
                  ? 'No opportunities match your filters'
                  : 'No opportunities available yet',
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onClear,
                child: const Text('Clear filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(opportunityFilterProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Filters', style: AppTextStyles.titleLarge),
              const Spacer(),
              if (filter.hasActiveFilters)
                TextButton(
                  onPressed: () {
                    ref.read(opportunityFilterProvider.notifier).state =
                        const OpportunityFilter();
                    Navigator.pop(context);
                  },
                  child: const Text('Clear all'),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Type', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: OpportunityType.values.map((type) {
              final labels = {
                OpportunityType.internship: 'Internship',
                OpportunityType.partTime: 'Part-time',
                OpportunityType.fullTime: 'Full-time',
                OpportunityType.contract: 'Contract',
                OpportunityType.volunteer: 'Volunteer',
              };
              return FilterChip(
                label: Text(labels[type] ?? type.name),
                selected: filter.type == type,
                onSelected: (selected) {
                  ref.read(opportunityFilterProvider.notifier).state =
                      filter.copyWith(type: selected ? type : null);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text('Category', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: OpportunityCategory.values.map((cat) {
              final labels = {
                OpportunityCategory.engineering: 'Engineering',
                OpportunityCategory.design: 'Design',
                OpportunityCategory.marketing: 'Marketing',
                OpportunityCategory.business: 'Business',
                OpportunityCategory.research: 'Research',
                OpportunityCategory.other: 'Other',
              };
              return FilterChip(
                label: Text(labels[cat] ?? cat.name),
                selected: filter.category == cat,
                onSelected: (selected) {
                  ref.read(opportunityFilterProvider.notifier).state =
                      filter.copyWith(category: selected ? cat : null);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Remote only'),
            value: filter.isRemote ?? false,
            onChanged: (v) {
              ref.read(opportunityFilterProvider.notifier).state =
                  filter.copyWith(isRemote: v ? true : null);
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply filters'),
            ),
          ),
        ],
      ),
    );
  }
}
