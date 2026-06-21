import 'package:flutter/material.dart';
import '../../data/models/ranking_item.dart';

class RankingCard extends StatelessWidget {
  final RankingItem item;

  const RankingCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final List<Color> medalColors = [
      Colors.amber.shade700,
      Colors.grey.shade500,
      Colors.brown.shade600,
    ];

    final bool isTop3 = item.position <= 3;
    final bool hasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: theme.cardTheme.elevation ?? 4,
      color: theme.cardTheme.color ?? theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              if (hasImage)
                Image.network(
                  item.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholder(theme),
                )
              else
                _buildPlaceholder(theme),

              if (hasImage)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                ),
              
              Positioned(
                top: 12,
                left: 12,
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: isTop3 ? medalColors[item.position - 1] : theme.colorScheme.scrim.withOpacity(0.8),
                  child: Text(
                    '#${item.position}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                ),
              ),
                ),
              ),
              
              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: Text(
                  item.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: hasImage ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < item.rating.floor()
                              ? Icons.star
                              : (index < item.rating ? Icons.star_half : Icons.star_border),
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    if (item.location != null)
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: theme.colorScheme.error),
                          const SizedBox(width: 4),
                          Text(
                            item.location!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.85),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      height: 180,
      width: double.infinity,
      color: theme.colorScheme.surfaceVariant,
      child: Icon(
        Icons.image_not_supported_outlined, 
        size: 48, 
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
      ),
    );
  }
}