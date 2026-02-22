import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pub_dev_packages_app/core/assets_gen/assets.gen.dart';
import 'package:pub_dev_packages_app/core/assets_gen/colors.gen.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/core/routes/app_paths.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assets = Assets.svgs;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final strings = AppLocalizations.of(context);

    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          assets.headerImageBg.svg(
            width: double.infinity,
            height: 0.40.sh,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Assets.svgs.pubDevLogo.svg(width: 40.w, height: 40.h),
                35.verticalSpace,
                _SearchBar(
                  searchController: _searchController,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                  strings: strings,
                ),
                24.verticalSpace,
                _Subtitle(
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                  strings: strings,
                ),
                12.verticalSpace,
                Assets.images.supportedByGoogle2x.image(
                  width: 150.w,
                  height: 40.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final AppLocalizations strings;
  const _Subtitle({
    required this.textTheme,
    required this.colorScheme,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
          children: [
            TextSpan(text: strings.officialPackageRepository),
            TextSpan(
              text: strings.dart,
              style: textTheme.bodyMedium?.copyWith(
                color: ColorName.linkColor,
                decoration: TextDecoration.underline,
                decorationColor: ColorName.linkColor,
              ),
            ),
            TextSpan(text: strings.and),
            TextSpan(
              text: strings.flutter,
              style: textTheme.bodyMedium?.copyWith(
                color: ColorName.linkColor,
                decoration: TextDecoration.underline,
                decorationColor: ColorName.linkColor,
              ),
            ),
            TextSpan(text: strings.apps),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final AppLocalizations strings;

  const _SearchBar({
    required this.searchController,
    required this.textTheme,
    required this.colorScheme,
    required this.strings,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isFocused = widget.searchController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.searchController,
      onSubmitted: (query) {
        context.push(AppPaths.search, extra: query);
      },
      style: widget.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w400,
        color: widget.colorScheme.scrim,
      ),
      decoration: InputDecoration(
        hintText: widget.strings.searchPackages,
        hintStyle: widget.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w400,
          color: widget.colorScheme.onSurfaceVariant,
        ),
        prefixIcon: Icon(
          Icons.search,
          size: 24.sp,
          color: _isFocused
              ? widget.colorScheme.scrim
              : widget.colorScheme.onSurfaceVariant,
        ),
        suffixIcon: _isFocused
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: widget.colorScheme.scrim,
                  size: 24.sp,
                ),
                onPressed: () {
                  widget.searchController.clear();
                },
              )
            : null,
      ),
    );
  }
}
