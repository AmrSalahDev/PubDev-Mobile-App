import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/assets_gen/colors.gen.dart';
import 'package:pub_dev_packages_app/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double? borderRadius;
  final bool? isEnable;
  final Widget? child;
  final EdgeInsetsGeometry? margin;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.isEnable,
    this.borderRadius,
    this.margin,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: isEnable ?? true,
      baseColor: context.isDark ? ColorName.darkBaseShimmerColor : ColorName.lightBaseShimmerColor,
      highlightColor: context.isDark ? ColorName.darkHighlightShimmerColor : ColorName.lightHighlightShimmerColor,
      child: child ?? Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: context.isDark ? ColorName.darkBaseShimmerColor : ColorName.lightBaseShimmerColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        ),
      ),
    );
  }
}