import 'package:flutter/material.dart';
import '../../data/models/ranking_item.dart';
import '../screens/ranking_detail_screen.dart'; // 1. Importamos la nueva pantalla

class RankingCard extends StatelessWidget {
  final RankingItem item;

  const RankingCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;
    final String reviewCount = "(${item.rating > 4.7 ? '2.4k' : '1.2k'})";

    // 2. Envolvemos todo en un InkWell para capturar el Tap
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      color: Colors
          .transparent, // Evitamos que tape el diseño del container de abajo
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          // 3. NAVEGACIÓN: Viajamos a la pantalla de detalle pasándole el objeto "item"
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
            color: theme
                .colorScheme
                .surfaceContainer, // Blanco puro (Colors.white)
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withOpacity(0.4),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen Cuadrada
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: hasImage
                    ? Image.network(
                        item.imageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(theme),
                      )
                    : _buildPlaceholder(theme),
              ),
              const SizedBox(width: 16),

              // Bloque de contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary, // Teal
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
                          child: Text(
                            item.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          reviewCount,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                        ),
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
                            item.location ?? 'Unknown',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.3,
                        fontSize: 13,
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

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      width: 100,
      height: 100,
      color: theme.scaffoldBackgroundColor,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 28,
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
      ),
    );
  }
}
