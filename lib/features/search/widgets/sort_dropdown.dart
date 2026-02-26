import 'package:flutter/material.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';

class SortDropdown extends StatelessWidget {
  final SearchOrder currentSort;
  final Function(SearchOrder?) onSortChanged;

  const SortDropdown({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final strings = AppLocalizations.of(context);

    return DropdownButton<SearchOrder>(
      value: currentSort,
      alignment: Alignment.centerRight,
      underline: const SizedBox(),
      icon: Icon(Icons.arrow_drop_down, color: colorScheme.onPrimary),
      style: textTheme.bodySmall?.copyWith(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
      onChanged: onSortChanged,
      items: [
        DropdownMenuItem(value: SearchOrder.top, child: Text(strings.defaultt)),
        DropdownMenuItem(
          value: SearchOrder.popularity,
          child: Text(strings.popularity),
        ),
        DropdownMenuItem(
          value: SearchOrder.points,
          child: Text(strings.points),
        ),
        DropdownMenuItem(
          value: SearchOrder.updated,
          child: Text(strings.updated),
        ),
        DropdownMenuItem(
          value: SearchOrder.created,
          child: Text(strings.newestPackage),
        ),
      ],
    );
  }
}
