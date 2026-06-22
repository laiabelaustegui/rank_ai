import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final String hintText;
  final bool
  readOnly; // Nuevo: Para controlar si abre el modal o si escribe directo
  final VoidCallback? onTap; // Nuevo: Evento al pulsar la barra falsa

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText = 'Ex: Top 10 entrepreneurship books...',
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void initState() {
    super.initState();
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
      readOnly:
          widget.readOnly, // Si es true, no saca teclado, solo dispara el onTap
      onTap: widget.onTap,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.4),
        ),
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
        suffixIcon: widget.controller.text.isNotEmpty && !widget.readOnly
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                onPressed: () {
                  widget.controller.clear();
                  widget.onSearch();
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
