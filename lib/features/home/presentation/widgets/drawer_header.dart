import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/assets_gen/assets.gen.dart';

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    super.key,
    required this.textTheme,
    required this.colorScheme,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final assets = Assets.svgs;
    return Stack(
      children: [
        assets.headerImageBg.svg(
          width: double.infinity,
          height: 0.25.sh,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              40.verticalSpace,
              assets.pubDevLogo.svg(),
              16.verticalSpace,
              Text(
                'Version 1.0.0',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
