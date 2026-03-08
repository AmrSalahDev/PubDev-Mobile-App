import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/di/di.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/core/services/toast_service.dart';
import 'package:pub_dev_packages_app/core/utils/time_ago_helper.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';

class PackageDetailsInfo extends StatelessWidget {
  final PackageEntity packageInfo;
  const PackageDetailsInfo({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final strings = AppLocalizations.of(context);
    final publishedDate = TimeAgoHelper.format(packageInfo.latest.published);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${packageInfo.name} ${packageInfo.latest.version}',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.copy,
                color: colorScheme.onSurfaceVariant,
                size: 20.w,
              ),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: '${packageInfo.name}: ^${packageInfo.latest.version}',
                  ),
                );
                getIt<ToastService>().showSuccessToast(
                  context: context,
                  message: strings.copied,
                );
              },
            ),
          ],
        ),
        8.verticalSpace,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '${strings.published} $publishedDate ',
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (packageInfo.score.publisher != null) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, color: colorScheme.primary, size: 14.w),
                  4.horizontalSpace,
                  Text(
                    packageInfo.score.publisher!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
