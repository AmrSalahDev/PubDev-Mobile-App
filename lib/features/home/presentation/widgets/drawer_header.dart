import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        24.verticalSpace,
        // ShimmerAvater(
        //   size: 128.w,
        //   onTap: () {
        //     context.push(AppPaths.profile);
        //     //_advancedDrawerController.toggleDrawer();
        //   },
        //   imageUrl: profile?.avatarUrl ?? '',
        // ),
        16.verticalSpace,
        Text(
          'Pub Dev',
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        4.verticalSpace,
        Text(
          'Pub Dev',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
        ),
      ],
    );
  }
}
