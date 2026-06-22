import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSearchPressed;

  const CustomAppBar({super.key, required this.title, this.onSearchPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.headlineLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontSize:
              24, // Ajustado ligeramente para que encaje mejor en un AppBar
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0, // Evita que cambie de color al hacer scroll
      actions: [
        if (onSearchPressed != null)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              onPressed: onSearchPressed,
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
