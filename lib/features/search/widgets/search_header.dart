import 'package:flutter/material.dart';
import 'package:pub_api_client/pub_api_client.dart';
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF263545))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RESULTS $count packages',
            style: const TextStyle(
              color: Color(0xFFB0BEC5),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SortDropdown(
            currentSort: currentSort,
            onSortChanged: onSortChanged,
          ),
        ],
      ),
    );
  }
}