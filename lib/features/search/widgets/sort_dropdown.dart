import 'package:flutter/material.dart';
import 'package:pub_api_client/pub_api_client.dart';

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'SORT BY ',
          style: TextStyle(
            color: Color(0xFFB0BEC5),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        Theme(
          data: ThemeData.dark().copyWith(canvasColor: const Color(0xFF1C2834)),
          child: DropdownButton<SearchOrder>(
            value: currentSort,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4EAFF7)),
            style: const TextStyle(
              color: Color(0xFF4EAFF7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            onChanged: onSortChanged,
            items: const [
              DropdownMenuItem(value: SearchOrder.top, child: Text('DEFAULT')),
              DropdownMenuItem(
                value: SearchOrder.popularity,
                child: Text('POPULARITY'),
              ),
              DropdownMenuItem(
                value: SearchOrder.points,
                child: Text('POINTS'),
              ),
              DropdownMenuItem(
                value: SearchOrder.updated,
                child: Text('RECENTLY UPDATED'),
              ),
              DropdownMenuItem(
                value: SearchOrder.created,
                child: Text('NEWEST PACKAGE'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}