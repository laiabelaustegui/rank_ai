import 'package:flutter/material.dart';

class RankingFilterBar extends StatelessWidget {
  final String query;
  final bool isDescending;
  final ValueChanged<bool> onSortChanged;

  const RankingFilterBar({
    super.key,
    required this.query,
    required this.isDescending,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI RANKING FOR',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              // Usamos directamente el color secundario/variante de tu AppTheme (Gris 0xFF757575)
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            query,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                Theme(
                  data: theme.copyWith(canvasColor: Colors.transparent),
                  child: FilterChip(
                    showCheckmark: false,
                    selected: true,
                    selectedColor: theme
                        .colorScheme
                        .primary, // Tu color de marca exacto Teal (0xFF0D9488)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 1. ICONO DE LA IZQUIERDA FIJO (Fiel a tu mockup e intuitivo)
                        const Icon(Icons.sort, size: 16, color: Colors.white),
                        const SizedBox(width: 6),

                        // 2. TEXTO DINÁMICO
                        Text(
                          isDescending ? 'Sort: Rating' : 'Sort: Rating (Low)',
                        ),
                        const SizedBox(width: 4),

                        // 3. FLECHA DE LA DERECHA DINÁMICA (Indica la dirección del ordenamiento)
                        Icon(
                          isDescending
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    onSelected: (_) {
                      // Notifica a la pantalla que invierta el orden
                      onSortChanged(!isDescending);
                    },
                  ),
                ),
                // Espacio listo para los próximos filtros (Price: $$, Distance, etc.)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
