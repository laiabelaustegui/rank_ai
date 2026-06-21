import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText = 'Ex: Top 10 entrepreneurship books...',
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void initState() {
    super.initState();
    // Escuchamos los cambios para redibujar la 'X' localmente sin refrescar toda la pantalla externa
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: widget.controller,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                onPressed: () {
                  widget.controller.clear();
                  widget.onSearch(); // Opcional: dispara acción al limpiar si se requiere
                },
              )
            : null,
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => widget.onSearch(),
    );
  }
}