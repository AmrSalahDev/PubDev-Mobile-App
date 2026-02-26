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

    final searchOrders = [
      SearchOrder.text,
      SearchOrder.top,
      SearchOrder.updated,
      SearchOrder.created,
      SearchOrder.like,
      SearchOrder.points,
      SearchOrder.downloads,
      SearchOrder.popularity,
    ];

    String getDropdownText(SearchOrder order) {
      switch (order) {
        case SearchOrder.text:
          return strings.sortDefaultRanking;
        case SearchOrder.top:
          return strings.sortOverallScore;
        case SearchOrder.updated:
          return strings.sortRecentlyUpdated;
        case SearchOrder.created:
          return strings.sortNewestPackage;
        case SearchOrder.like:
          return strings.sortMostLikes;
        case SearchOrder.points:
          return strings.sortMostPubPoints;
        case SearchOrder.downloads:
          return strings.sortDownloads;
        case SearchOrder.popularity:
          return strings.sortTrending;
      }
    }

    return DropdownButton<SearchOrder>(
      value: currentSort,
      alignment: Alignment.centerRight,
      dropdownColor: colorScheme.surfaceContainer,
      underline: const SizedBox(),
      icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.onPrimary),
      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
      selectedItemBuilder: (BuildContext context) {
        return searchOrders.map((SearchOrder order) {
          return Center(
            child: Text.rich(
              TextSpan(
                text: strings.sortBy,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: getDropdownText(order).toUpperCase(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF4EAFF7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
      onChanged: onSortChanged,
      items: searchOrders.map((SearchOrder order) {
        return DropdownMenuItem(
          value: order,
          child: Text(getDropdownText(order)),
        );
      }).toList(),
    );
  }
}
