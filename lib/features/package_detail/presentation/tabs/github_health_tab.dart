import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/package_detail/domain/entities/github_health_entity.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/bloc/github_health/github_health_bloc.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/bloc/github_health/github_health_event.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/bloc/github_health/github_health_state.dart';
import 'package:intl/intl.dart';

class GithubHealthTab extends StatefulWidget {
  final PackageEntity packageInfo;

  const GithubHealthTab({super.key, required this.packageInfo});

  @override
  State<GithubHealthTab> createState() => _GithubHealthTabState();
}

class _GithubHealthTabState extends State<GithubHealthTab> {
  late final GithubHealthBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.I<GithubHealthBloc>();
    _fetchData();
  }

  void _fetchData() {
    final pubspec = widget.packageInfo.latest.pubspec;
    String? urlToUse;

    // 1. Try repository field
    if (pubspec.repository != null &&
        pubspec.repository!.contains('github.com')) {
      urlToUse = pubspec.repository;
    }

    // 2. Try homepage field
    if (urlToUse == null && pubspec.homepage.contains('github.com')) {
      urlToUse = pubspec.homepage;
    }

    // 3. Fallback to readmeUrl
    if (urlToUse == null) {
      String? readmeUrl = widget.packageInfo.readmeUrl;
      if (readmeUrl != null && readmeUrl.contains('github.com')) {
        final parts = Uri.parse(readmeUrl).pathSegments;
        if (parts.length >= 2) {
          urlToUse = 'https://github.com/${parts[0]}/${parts[1]}';
        }
      }
    }

    if (urlToUse != null && urlToUse.isNotEmpty) {
      _bloc.add(GetGithubHealthEvent(urlToUse));
    } else {
      // If we still have no URL, we should explicitly trigger an error state or empty state
      // instead of doing nothing (which leaves UI in loading state).
      _bloc.add(const GetGithubHealthEvent(''));
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<GithubHealthBloc, GithubHealthState>(
        builder: (context, state) {
          if (state is GithubHealthLoading || state is GithubHealthInitial) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32.h),
                child: const CircularProgressIndicator(),
              ),
            );
          }

          if (state is GithubHealthError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32.h),
                child: Text(
                  AppLocalizations.of(context).githubHealthNotAvailable,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            );
          }

          if (state is GithubHealthLoaded) {
            return _buildContent(context, state.githubHealthEntity);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, GithubHealthEntity data) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthScoreCard(context, data),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  Icons.error_outline,
                  l10n.openIssues,
                  data.openIssuesCount.toString(),
                  colorScheme.error,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildMetricCard(
                  context,
                  Icons.call_merge,
                  l10n.openPrs,
                  data.openPrsCount.toString(),
                  colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildDateCard(context, data.lastCommitDate),
          SizedBox(height: 16.h),
          _buildCommitActivityCard(context, data),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard(BuildContext context, GithubHealthEntity data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    Color statusColor = Colors.green;
    if (data.healthScore < 50) {
      statusColor = Colors.red;
    } else if (data.healthScore < 75) {
      statusColor = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.healthScore,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.maintenanceAndCommunity,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72.w,
                    height: 72.w,
                    child: CircularProgressIndicator(
                      value: data.healthScore / 100,
                      strokeWidth: 6.w,
                      backgroundColor: colorScheme.outlineVariant,
                      color: colorScheme.primary,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    '${data.healthScore}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.status,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  data.status,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: data.healthScore / 100,
              minHeight: 8.h,
              backgroundColor: colorScheme.outlineVariant,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    Color iconColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: iconColor),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(BuildContext context, DateTime? date) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    String dateStr = 'Unknown';
    if (date != null) {
      if (date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day) {
        dateStr = '${l10n.today}, ${DateFormat.jm().format(date)}';
      } else {
        dateStr = DateFormat('MMM d, y, h:mm a').format(date);
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, size: 16.sp, color: colorScheme.primary),
              SizedBox(width: 8.w),
              Text(
                l10n.lastCommitDate,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            dateStr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommitActivityCard(
    BuildContext context,
    GithubHealthEntity data,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.commitActivity,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.last6Months,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 120.h,
            child: _buildBarChart(context, data.commitActivity, colorScheme),
          ),
          SizedBox(height: 16.h),
          _buildMonthLabels(context),
        ],
      ),
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    List<double> values,
    ColorScheme colorScheme,
  ) {
    if (values.isEmpty) return const SizedBox.shrink();

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final scale = maxValue > 0 ? 120.h / maxValue : 1.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(6, (index) {
        final val = index < values.length ? values[index] : 0.0;
        final height = (val * scale).clamp(4.0, 120.h);
        final isHighest = val == maxValue && maxValue > 0;

        return Container(
          width: 32.w,
          height: height.toDouble(),
          decoration: BoxDecoration(
            color: isHighest
                ? colorScheme.primary
                : colorScheme.primary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }

  Widget _buildMonthLabels(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Generate last 6 months labels
    List<String> labels = [];
    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      labels.add(DateFormat('MMM').format(month).toUpperCase());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: labels.map((label) {
        return SizedBox(
          width: 32.w,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }).toList(),
    );
  }
}
