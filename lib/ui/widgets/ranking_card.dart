import 'package:flutter/material.dart';
import '../../data/models/ranking_item.dart';
import '../screens/ranking_detail_screen.dart';

class RankingCard extends StatelessWidget {
  final RankingItem item;
  final bool isSkeleton;

  const RankingCard({super.key, required this.item, this.isSkeleton = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasLocation =
        item.location != null && item.location!.trim().isNotEmpty;

    // 🎨 APP THEME: Shimmer adaptativo
    final isDark = theme.brightness == Brightness.dark;
    final skeletonColor = isDark ? Colors.grey[700]! : Colors.grey[200]!;

    // Método centralizado para la navegación de detalles
    void navigateToDetail() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RankingDetailScreen(item: item),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera: Posición Circular + Título
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isSkeleton
                    ? _buildSkeletonBlock(
                        width: 36, // Ajustado al mismo tamaño circular
                        height: 36,
                        color: skeletonColor,
                        isCircle: true, // 🚀 Activamos círculo para el Shimmer
                      )
                    : Container(
                        width: 36, // 🚀 Ancho fijo esférico
                        height: 36, // 🚀 Alto fijo esférico
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle, // 🚀 Hace el badge redondo
                        ),
                        child: Center(
                          child: Text(
                            '${item.position}', // 🚀 Posición limpia sin '#'
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 14, // Balanceado para 1 y 2 dígitos
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  width: 12,
                ), // 🚀 Espaciado premium junto al círculo
                Expanded(
                  child: isSkeleton
                      ? _buildSkeletonBlock(height: 17, color: skeletonColor)
                      : Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Subtítulo
            if (isSkeleton || item.subtitle.isNotEmpty) ...[
              isSkeleton
                  ? _buildSkeletonBlock(
                      width: 140,
                      height: 13,
                      color: skeletonColor,
                    )
                  : Text(
                      item.subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              const SizedBox(height: 6),
            ],

            // Fila de Metadatos (Rating y Location)
            isSkeleton
                ? _buildSkeletonBlock(
                    width: 90,
                    height: 13,
                    color: skeletonColor,
                  )
                : Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toStringAsFixed(1),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      if (hasLocation) ...[
                        const SizedBox(width: 6),
                        Text(
                          '•',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            item.location!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
            const SizedBox(height: 10),

            // Tags
            if (isSkeleton || item.tags.isNotEmpty) ...[
              isSkeleton
                  ? _buildSkeletonBlock(
                      width: 110,
                      height: 14,
                      color: skeletonColor,
                    )
                  : Wrap(
                      spacing: 4,
                      children: item.tags.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 10),
            ],

            // Descripción
            isSkeleton
                ? _buildSkeletonBlock(
                    height: 12.5,
                    color: skeletonColor,
                    lines: 2,
                  )
                : Text(
                    item.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.3,
                      fontSize: 12.5,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

            const SizedBox(height: 8),

            // Botón de "View details"
            Align(
              alignment: Alignment.centerRight,
              child: isSkeleton
                  ? _buildSkeletonBlock(
                      width: 90,
                      height: 16,
                      color: skeletonColor,
                    )
                  : InkWell(
                      onTap: navigateToDetail,
                      borderRadius: BorderRadius.circular(4.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 6.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View details',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 🚀 Se añadió la propiedad `isCircle` para redondear el esqueleto en la cabecera
  Widget _buildSkeletonBlock({
    double? width,
    required double height,
    required Color color,
    int lines = 1,
    bool isCircle = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? 4.0 : 0),
          child: Container(
            width: width ?? double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: color,
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isCircle ? null : BorderRadius.circular(height / 4),
            ),
          ),
        );
      }),
    );
  }
}
