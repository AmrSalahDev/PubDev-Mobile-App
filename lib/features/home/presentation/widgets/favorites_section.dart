import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/package_tile.dart';

class FavoritesSection extends StatelessWidget {
  final List<PackageEntity> packages;
  const FavoritesSection({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    if (packages.isEmpty) {
      return SizedBox(
        height: 130.h,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
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
