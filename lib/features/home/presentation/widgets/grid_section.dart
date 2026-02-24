import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/domain/entities/package_entity.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/package_tile.dart';

class GridSection extends StatelessWidget {
  final List<PackageEntity> packages;
  const GridSection({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    if (packages.isEmpty) {
      return SizedBox(
        height: 100.h,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
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
