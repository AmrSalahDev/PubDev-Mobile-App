import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_display/number_display.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class PackageScore extends StatelessWidget {
  final PackageEntity packageInfo;

  const PackageScore({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    final formatNumber = createDisplay(length: 5, decimal: 1, separator: ',');
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                packageInfo.name,
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            12.horizontalSpace,
            _ScoreItem(
              value: formatNumber(packageInfo.score.likeCount),
              label: strings.likes,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
            _scoreDivider(context),
            _ScoreItem(
              value: packageInfo.score.grantedPoints.toString(),
              label: strings.points,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
            _scoreDivider(context),
            _ScoreItem(
              value: formatNumber(packageInfo.score.downloadCount30Days),
              label: strings.downloads,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
          ],
        ),
        12.verticalSpace,
        Text(
          packageInfo.latest.pubspec.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 14.sp,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _scoreDivider(BuildContext context) => Container(
    height: 24,
    width: 1,
    color: Theme.of(context).colorScheme.outline,
    margin: EdgeInsets.symmetric(horizontal: 12.w),
  );
}

class _ScoreItem extends StatelessWidget {
  final String value;
  final String label;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  const _ScoreItem({
    required this.value,
    required this.label,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
