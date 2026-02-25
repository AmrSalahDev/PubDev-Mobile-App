import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/package_tile.dart';
import 'package:pub_dev_packages_app/features/widgets/shimmer_box.dart';

class FavoritesSection extends StatelessWidget {
  final List<PackageEntity> packages;
  final bool isLoading;
  const FavoritesSection({super.key, required this.packages, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _ShimmerFavoritesSection();
    }
    return SizedBox(
      height: 150.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 185.w,
            margin: EdgeInsets.only(
              right: index == packages.length - 1 ? 0 : 12.w,
            ),
            child: PackageTile(package: packages[index]),
          );
        },
      ),
    );
  }
}

class _ShimmerFavoritesSection extends StatelessWidget {
  const _ShimmerFavoritesSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 185.w,
            margin: EdgeInsets.only(right: index == 4 ? 0 : 12.w),
            child: ShimmerBox(width: 185.w, height: 150.h),
          );
        },
      ),
    );
  }
}
