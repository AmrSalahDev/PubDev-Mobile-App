import 'package:animated_hint_textfield/animated_hint_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final TextTheme textTheme;
  final ColorScheme colorScheme;
  final AppLocalizations strings;
  final ValueChanged<String> onSubmitted;
  final List<String>? hintTexts;

  const CustomSearchBar({
    super.key,
    required this.searchController,
    required this.textTheme,
    required this.colorScheme,
    required this.strings,
    required this.onSubmitted,
    this.hintTexts,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
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
    return AnimatedTextField
    ( 
      animationType: Animationtype.typer,
      controller: widget.searchController,
      onSubmitted: (query) {
        widget.onSubmitted(query);
      },
      style: widget.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w400,
        color: widget.colorScheme.onPrimary,
      ),
      hintTexts: widget.hintTexts ?? [],
      decoration: InputDecoration(
        hintText: widget.strings.searchPackages,
        hintMaxLines: 2,
        hintStyle: widget.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w400,
          color: widget.colorScheme.onSurfaceVariant,
        ),
        prefixIcon: Icon(
          Icons.search,
          size: 24.sp,
          color: _isFocused
              ? widget.colorScheme.onPrimary
              : widget.colorScheme.onSurfaceVariant,
        ),
        suffixIcon: _isFocused
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: widget.colorScheme.onPrimary,
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
