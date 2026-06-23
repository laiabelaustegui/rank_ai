import 'package:flutter/material.dart';
import '../screens/search_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSearchPressed;

  const CustomAppBar({super.key, required this.title, this.onSearchPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      // 🛠️ MODIFICADO: Envolvemos el Row en un GestureDetector para capturar el toque
      title: GestureDetector(
        onTap: () {
          // 🚀 Limpia todo el historial de pantallas y regresa a la raíz principal
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ), // 👈 Cambia por tu Home/SearchScreen real
            (route) => false,
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors
              .click, // Hace que en web/desktop muestre la mano de click
          child: Row(
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
        ),
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
