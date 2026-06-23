import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;

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
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      style: theme.textTheme.bodyLarge,
      minLines: 1,
      maxLines: 3,
      keyboardType: TextInputType.multiline,

      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
        suffixIcon: widget.controller.text.isNotEmpty && !widget.readOnly
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                onPressed: () {
                  widget.controller.clear();
                  widget.onSearch();
                },
              )
            : null,
        filled: true,
        // 🛠️ MODIFICADO: Ahora el fondo usa el color primario de forma ultra suave (vibras de marca discretas)
        fillColor: theme.colorScheme.primary.withValues(alpha: 0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => widget.onSearch(),
    );
  }
}
