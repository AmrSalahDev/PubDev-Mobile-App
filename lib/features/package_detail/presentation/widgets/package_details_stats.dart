import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_display/number_display.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class PackageDetailsStats extends StatelessWidget {
  final PackageEntity packageInfo;
  const PackageDetailsStats({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final formatNumber = createDisplay(length: 5, decimal: 1, separator: ',');
    final strings = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outline),
          bottom: BorderSide(color: colorScheme.outline),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _scoreItem(
            formatNumber(packageInfo.score.likeCount),
            strings.likes,
            colorScheme,
            textTheme,
          ),
          _vDivider(colorScheme),
          _scoreItem(
            packageInfo.score.maxPoints.toString(),
            strings.points,
            colorScheme,
            textTheme,
          ),
          _vDivider(colorScheme),
          _scoreItem(
            formatNumber(packageInfo.score.downloadCount30Days),
            strings.downloads,
            colorScheme,
            textTheme,
          ),
        ],
      ),
    );
  }

  Widget _scoreItem(
    String value,
    String label,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) => Column(
    children: [
      Text(
        value,
        style: textTheme.headlineSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );

  Widget _vDivider(ColorScheme colorScheme) =>
      Container(width: 2.w, height: 40.h, color: colorScheme.outline);
}
