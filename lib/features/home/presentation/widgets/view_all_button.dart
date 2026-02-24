import 'package:flutter/material.dart';
import 'package:pub_dev_packages_app/core/l10n/generated/l10n.dart';

class ViewAllButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  const ViewAllButton({super.key, required this.onTap, this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onTap,
        child: Text(
          title?.toUpperCase() ?? strings.viewAll.toUpperCase(),
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.primary,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
