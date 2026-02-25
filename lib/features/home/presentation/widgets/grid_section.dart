import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/package_tile.dart';
import 'package:pub_dev_packages_app/features/widgets/shimmer_box.dart';

class GridSection extends StatelessWidget {
  final List<PackageEntity> packages;
  final bool isLoading;
  const GridSection({super.key, required this.packages, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _ShimmerGridSection();
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        mainAxisExtent: 160.h,
      ),
      itemCount: packages.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics() ,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemBuilder: (context, index) {
        return PackageTile(package: packages[index]);
      },
    );
  }
}


class _ShimmerGridSection extends StatelessWidget {
  const _ShimmerGridSection();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        mainAxisExtent: 160.h,
      ),
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics() ,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemBuilder: (context, index) {
        return ShimmerBox(width: 185.w, height: 150.h);
      },
    );
  }
}