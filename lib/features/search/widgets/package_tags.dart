import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class PackageTags extends StatelessWidget {
  final PackageEntity packageInfo;
  const PackageTags({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (packageInfo.score.sdks != null &&
            packageInfo.score.sdks!.isNotEmpty)
          PackageTag(label: 'SDK'.toUpperCase(), values: packageInfo.score.sdks!),
        if (packageInfo.score.platforms != null &&
            packageInfo.score.platforms!.isNotEmpty)
          PackageTag(
            label: 'Platform'.toUpperCase(),
            values: packageInfo.score.platforms!,
          ),
      ],
    );
  }
}

class PackageTag extends StatelessWidget {
  final String label;
  final List<String> values;
  const PackageTag({super.key, required this.label, required this.values});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: colorScheme.surface,
              child: Text(
                label.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            for (final v in values)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Text(
                  v.toUpperCase(),
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
