import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/context_theme_x.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../providers/startup_analytics_provider.dart';

class StartupAnalyticsScreen extends ConsumerWidget {
  const StartupAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();
    final startupId = user.id;

    final analyticsAsync = ref.watch(startupAnalyticsProvider(startupId));
    final insightsAsync = ref.watch(applicantInsightsProvider(startupId));

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: analyticsAsync.when(
        data: (analytics) {
          if (analytics.totalOpportunities == 0) {
            return const _EmptyAnalytics();
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(startupAnalyticsProvider(startupId));
              ref.invalidate(applicantInsightsProvider(startupId));
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _MetricsRow(analytics: analytics),
                const SizedBox(height: AppSpacing.xl),
                _SectionCard(
                  title: 'Applications per month',
                  child: _ApplicationsPerMonthChart(data: analytics.applicationsPerMonth),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionCard(
                  title: 'Most viewed internships',
                  child: analytics.topOpportunities.isEmpty
                      ? const _EmptySection(message: 'No views recorded yet.')
                      : _RankedBarList(
                          entries: [
                            for (final o in analytics.topOpportunities)
                              _RankedEntry(label: o.title, value: o.views, suffix: '${o.applications} applied'),
                          ],
                        ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionCard(
                  title: 'Acceptance rate',
                  child: _AcceptanceRateChart(rate: analytics.acceptanceRate),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionCard(
                  title: 'Top skills among applicants',
                  child: insightsAsync.when(
                    data: (insights) => insights.topSkills.isEmpty
                        ? const _EmptySection(message: 'No applicant data yet.')
                        : _RankedBarList(
                            entries: [
                              for (final s in insights.topSkills)
                                _RankedEntry(label: s.skill, value: s.count),
                            ],
                          ),
                    loading: () => const _ChartSkeleton(),
                    error: (e, _) => ErrorView(message: e.toString()),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionCard(
                  title: 'Applicant locations',
                  child: insightsAsync.when(
                    data: (insights) => insights.locations.isEmpty
                        ? const _EmptySection(message: 'No applicant data yet.')
                        : _RankedBarList(
                            entries: [
                              for (final l in insights.locations)
                                _RankedEntry(label: l.location, value: l.count),
                            ],
                          ),
                    loading: () => const _ChartSkeleton(),
                    error: (e, _) => ErrorView(message: e.toString()),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorView(message: e.toString()),
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({required this.analytics});

  final StartupAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final metrics = [
      (Icons.work_outline, '${analytics.totalOpportunities}', 'Postings', colors.info),
      (Icons.people_outline, '${analytics.totalApplications}', 'Applicants', colors.accent),
      (Icons.visibility_outlined, '${analytics.totalViews}', 'Views', colors.startupAccent),
      (Icons.check_circle_outline, '${(analytics.acceptanceRate * 100).round()}%', 'Accepted', colors.success),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.7,
      children: [
        for (var i = 0; i < metrics.length; i++)
          _MetricCard(
            icon: metrics[i].$1,
            value: metrics[i].$2,
            label: metrics[i].$3,
            color: metrics[i].$4,
            delay: Duration(milliseconds: i * 60),
          ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.delay = Duration.zero,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTextStyles.displayMedium.copyWith(color: color)),
          Text(label, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: delay).slideY(begin: 0.15, end: 0);
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _ApplicationsPerMonthChart extends StatelessWidget {
  const _ApplicationsPerMonthChart({required this.data});

  final List<MonthlyCount> data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxCount = data.map((d) => d.count).fold<int>(0, (a, b) => a > b ? a : b);
    final maxY = maxCount == 0 ? 5.0 : (maxCount * 1.25).ceilToDouble();

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(data[index].month, style: AppTextStyles.caption),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data[i].count.toDouble(),
                    color: colors.info,
                    width: 18,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _AcceptanceRateChart extends StatelessWidget {
  const _AcceptanceRateChart({required this.rate});

  final double rate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final percent = (rate * 100).round();

    return SizedBox(
      height: 140,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    centerSpaceRadius: 42,
                    sections: [
                      PieChartSectionData(
                        value: rate,
                        color: colors.success,
                        showTitle: false,
                        radius: 18,
                      ),
                      PieChartSectionData(
                        value: 1 - rate,
                        color: colors.divider,
                        showTitle: false,
                        radius: 18,
                      ),
                    ],
                  ),
                ),
                Text('$percent%', style: AppTextStyles.titleMedium),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              'Share of accepted vs. rejected applications, among those with a final decision.',
              style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankedEntry {
  const _RankedEntry({required this.label, required this.value, this.suffix});

  final String label;
  final int value;
  final String? suffix;
}

class _RankedBarList extends StatelessWidget {
  const _RankedBarList({required this.entries});

  final List<_RankedEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxValue = entries.map((e) => e.value).fold<int>(0, (a, b) => a > b ? a : b);

    return Column(
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          _RankedBarRow(
            entry: entries[i],
            fraction: maxValue == 0 ? 0 : entries[i].value / maxValue,
            color: colors.info,
          ),
        ],
      ],
    );
  }
}

class _RankedBarRow extends StatelessWidget {
  const _RankedBarRow({required this.entry, required this.fraction, required this.color});

  final _RankedEntry entry;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                entry.label,
                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              entry.suffix != null ? '${entry.value} · ${entry.suffix}' : '${entry.value}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: colors.divider,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(color: context.colors.textHint),
      ),
    );
  }
}

class _ChartSkeleton extends StatelessWidget {
  const _ChartSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 80, child: LoadingIndicator());
  }
}

class _EmptyAnalytics extends StatelessWidget {
  const _EmptyAnalytics();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_outlined, size: 56, color: colors.textHint),
            const SizedBox(height: AppSpacing.lg),
            Text('No data yet', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Post your first opportunity to start seeing applications, views, and applicant insights here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
