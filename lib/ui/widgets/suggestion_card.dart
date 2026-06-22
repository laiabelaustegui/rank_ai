import 'package:flutter/material.dart';

class SuggestionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SuggestionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 160, // Ancho fijo estructural para el scroll horizontal
      decoration: BoxDecoration(
        // Usa automáticamente Colors.white que definimos en 'surfaceContainer'
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16.0),
        // Usa el color sutil grisáceo personalizado de tu AppTheme
        border: Border.all(color: theme.dividerColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Contenedor del Icono
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 16),

              // Título (textPrimary)
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Subtítulo (textSecondary)
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
