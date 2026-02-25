import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class SearchPackageInfo extends StatelessWidget {
  final PackageEntity packageInfo;
  const SearchPackageInfo({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    final formatTime = GetTimeAgo.parse(packageInfo.latest.published);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'v ${packageInfo.latest.version}',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '($formatTime)',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        if (packageInfo.score.publisher != null) ...[
          Icon(Icons.verified, size: 14, color: colorScheme.primary),
          Text(
            packageInfo.score.publisher!,
            style: textTheme.labelSmall?.copyWith(color: colorScheme.primary),
          ),
        ],
        if (packageInfo.latest.pubspec.license != null)
          Text(
            packageInfo.latest.pubspec.license!,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
