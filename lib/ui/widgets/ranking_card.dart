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

    final isDark = theme.brightness == Brightness.dark;
    final skeletonColor = isDark ? Colors.grey[700]! : Colors.grey[200]!;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isSkeleton
                    ? _buildSkeletonBlock(
                        width: 36,
                        height: 36,
                        color: skeletonColor,
                        isCircle: true,
                      )
                    : Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${item.position}',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(width: 12),
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
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              const SizedBox(height: 6),
            ],

            isSkeleton
                ? _buildSkeletonBlock(
                    width: 90,
                    height: 13,
                    color: skeletonColor,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                        ],
                      ),

                      if (hasLocation) ...[
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.location!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
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
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 10),
            ],

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
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: theme.colorScheme.secondary,
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
