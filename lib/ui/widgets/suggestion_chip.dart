import 'package:flutter/material.dart';

class SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SuggestionChip({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionChip(
      label: Text(label),
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: theme.colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      side: BorderSide.none,
      onPressed: onTap,
    );
  }
}
