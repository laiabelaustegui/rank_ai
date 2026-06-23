import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSearchPressed;

  const CustomAppBar({super.key, required this.title, this.onSearchPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      // 🛠️ MODIFICADO: Usamos un Row para colocar el icono y el texto juntos
      title: Row(
        mainAxisSize:
            MainAxisSize.min, // Evita que el Row se estire innecesariamente
        children: [
          Icon(
            Icons.bar_chart_rounded, // El icono insignia de tu app 🌟
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(
            width: 8,
          ), // Pequeña separación entre el logo y el texto
          Text(
            title,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
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
