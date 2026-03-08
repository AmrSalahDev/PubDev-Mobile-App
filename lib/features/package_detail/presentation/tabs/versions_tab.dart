import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/core/utils/time_ago_helper.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class VersionsTab extends StatelessWidget {
  final PackageEntity packageInfo;
  const VersionsTab({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final strings = AppLocalizations.of(context);

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: packageInfo.versions.length,
      separatorBuilder: (context, index) =>
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
      itemBuilder: (context, index) {
        final version = packageInfo.versions[index];
        final isLatest = version.version == packageInfo.latest.version;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Text(
                version.version,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              if (isLatest) ...[
                12.horizontalSpace,
                _tag(strings.latest, Colors.green, context),
              ],
            ],
          ),
          subtitle: Text(
            TimeAgoHelper.format(version.published),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
          ),
        );
      },
    );
  }

  Widget _tag(String label, Color color, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
