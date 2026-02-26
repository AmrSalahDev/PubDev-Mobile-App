import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';
import 'package:pub_dev_packages_app/features/search/widgets/sort_dropdown.dart';

class SearchHeader extends StatelessWidget {
  final int count;
  final SearchOrder currentSort;
  final Function(SearchOrder?) onSortChanged;

  const SearchHeader({
    super.key,
    required this.count,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final strings = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outline)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              text: '${strings.results} ',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: count.toString(),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary,
                    backgroundColor: colorScheme.surfaceContainer,
                  ),
                ),
                TextSpan(
                  text: ' ${strings.packages}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          SortDropdown(currentSort: currentSort, onSortChanged: onSortChanged),
        ],
      ),
    );
  }
}
