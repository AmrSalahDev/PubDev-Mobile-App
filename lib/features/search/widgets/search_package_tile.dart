import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pub_dev_packages_app/core/routes/app_paths.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/search/widgets/package_score.dart';
import 'package:pub_dev_packages_app/features/search/widgets/package_tags.dart';
import 'package:pub_dev_packages_app/features/search/widgets/search_package_info.dart';

class SearchPackageTile extends StatelessWidget {
  final PackageEntity packageInfo;

  const SearchPackageTile({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        context.push(AppPaths.packageDetail, extra: packageInfo);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorScheme.outline)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PackageScore(packageInfo: packageInfo),
            16.verticalSpace,
            SearchPackageInfo(packageInfo: packageInfo),
            12.verticalSpace,
            PackageTags(packageInfo: packageInfo),
          ],
        ),
      ),
    );
  }
}
