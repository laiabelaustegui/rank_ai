import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/ranking_item.dart';
import '../screens/ranking_detail_screen.dart';

class RankingCard extends StatelessWidget {
  final RankingItem item;
  final bool isSkeleton;

  const RankingCard({super.key, required this.item, this.isSkeleton = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;
    final hasLocation =
        item.location != null && item.location!.trim().isNotEmpty;

    // Mapeamos los colores del esqueleto basados en el tema actual
    final isDark = theme.brightness == Brightness.dark;
    final skeletonColor = Colors.white; // Shimmer convierte esto en el destello

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: isSkeleton
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RankingDetailScreen(item: item),
                  ),
                );
              },
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.4),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Imagen o Esqueleto (¡CORREGIDO: Sin Hero! 🛠️)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: isSkeleton
                    ? _buildSkeletonBlock(
                        width: 100,
                        height: 100,
                        color: skeletonColor,
                      )
                    : (hasImage
                          ? Image.network(
                              item.imageUrl!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholder(theme),
                            )
                          : _buildPlaceholder(theme)),
              ),
              const SizedBox(width: 16),

              // 2. Bloque de Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabecera: Posición + Título
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isSkeleton
                            ? _buildSkeletonBlock(
                                width: 32,
                                height: 18,
                                color: skeletonColor,
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  '#${item.position}',
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: isSkeleton
                              ? _buildSkeletonBlock(
                                  height: 17,
                                  color: skeletonColor,
                                )
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
                    const SizedBox(height: 4),

                    // Subtítulo
                    if (isSkeleton || item.subtitle.isNotEmpty) ...[
                      isSkeleton
                          ? _buildSkeletonBlock(
                              width: 120,
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
                      const SizedBox(height: 4),
                    ],

                    // Fila de Metadatos
                    isSkeleton
                        ? _buildSkeletonBlock(
                            width: 80,
                            height: 13,
                            color: skeletonColor,
                          )
                        : Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 15,
                              ),
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
                    const SizedBox(height: 8),

                    // Tags
                    if (isSkeleton || item.tags.isNotEmpty) ...[
                      isSkeleton
                          ? _buildSkeletonBlock(
                              width: 100,
                              height: 14,
                              color: skeletonColor,
                            )
                          : Wrap(
                              spacing: 4,
                              children: item.tags.take(2).map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme
                                        .colorScheme
                                        .surfaceContainerHighest
                                        .withOpacity(0.6),
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
                      const SizedBox(height: 8),
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET AUXILIAR: Crea bloques grises individuales
  Widget _buildSkeletonBlock({
    double? width,
    required double height,
    required Color color,
    int lines = 1,
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
              borderRadius: BorderRadius.circular(height / 4),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      width: 100,
      height: 100,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      child: Icon(
        Icons.analytics_outlined,
        size: 28,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),
    );
  }
}
