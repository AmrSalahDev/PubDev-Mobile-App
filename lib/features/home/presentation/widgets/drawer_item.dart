import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/widgets/svg_icon.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;
  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      onTap: onTap,
      leading: SvgIcon(path: icon, size: 24.w, color: colorScheme.primary),
      title: Text(title, style: textTheme.bodyLarge),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.w,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}