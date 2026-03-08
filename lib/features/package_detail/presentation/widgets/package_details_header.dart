import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/assets_gen/assets.gen.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/widgets/package_details_info.dart';
import 'package:pub_dev_packages_app/features/package_detail/presentation/widgets/package_details_stats.dart';

class PackageDetailsHeader extends StatelessWidget {
  final PackageEntity packageInfo;
  const PackageDetailsHeader({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    final assets = Assets.svgs;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        assets.headerImageBg.svg(
          width: double.infinity,
          height: 0.27.sh,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              PackageDetailsInfo(packageInfo: packageInfo),
              24.verticalSpace,
              PackageDetailsStats(packageInfo: packageInfo),
            ],
          ),
        ),
      ],
    );
  }
}

class ShimmerPackageDetailHeader extends StatelessWidget {
  const ShimmerPackageDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
