import 'package:flutter/material.dart' hide DrawerHeader;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/drawer_header.dart';
import 'package:pub_dev_packages_app/features/home/presentation/widgets/drawer_item.dart';

class MenuItem {
  final String title;
  final String icon;
  final VoidCallback onTap;

  MenuItem({required this.title, required this.icon, required this.onTap});
}

class DrawerBody extends StatelessWidget {
  const DrawerBody({
    super.key,
    required this.textTheme,
    required this.colorScheme,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> menuItems = [
      // MenuItem(title: strings.editProfile, icon: icons.edit.path, onTap: () {}),
      // MenuItem(title: strings.network, icon: icons.network.path, onTap: () {}),
      // MenuItem(
      //   title: strings.photosVideos,
      //   icon: icons.imagesVideos.path,
      //   onTap: () {},
      // ),
      // MenuItem(title: strings.groups, icon: icons.group.path, onTap: () {}),
      // MenuItem(
      //   title: strings.searchProfile,
      //   icon: icons.search.path,
      //   onTap: () {},
      // ),
      // MenuItem(
      //   title: strings.language,
      //   icon: icons.translate.path,
      //   onTap: () {},
      // ),
      // MenuItem(
      //   title: strings.settings,
      //   icon: icons.settings.path,
      //   onTap: () {},
      // ),
      // MenuItem(
      //   title: strings.yourPrivacy,
      //   icon: icons.privacy.path,
      //   onTap: () {},
      // ),
      // MenuItem(title: strings.aboutUs, icon: icons.info.path, onTap: () {}),
      // MenuItem(
      //   title: strings.logout,
      //   icon: icons.logout.path,
      //   onTap: () {

      //     context.read<AuthBloc>().add(SignOutEvent());
      //   },
      // ),
    ];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          DrawerHeader(textTheme: textTheme, colorScheme: colorScheme),
          16.verticalSpace,
          Divider(color: colorScheme.outline),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 50.h),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return DrawerItem(
                  key: ValueKey(item.title),
                  title: item.title,
                  icon: item.icon,
                  onTap: item.onTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
