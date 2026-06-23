import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../blocs/ranking/ranking_bloc.dart';
import '../blocs/ranking/ranking_state.dart';
import '../widgets/ranking_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/error_view.dart'; // 🚀 Importación de tu nuevo widget extraído
import '../../data/models/ranking_item.dart';
import 'search_modal.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  void _openSearchModal() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchModalScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _saveCollection(String query, List<RankingItem> items) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Collection "$query" saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'RankAI', onSearchPressed: _openSearchModal),
      body: BlocBuilder<RankingBloc, RankingState>(
        builder: (context, state) {
          if (state is RankingLoading) {
            final isDark = theme.brightness == Brightness.dark;
            final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
            final highlightColor = isDark
                ? Colors.grey[700]!
                : Colors.grey[100]!;

            return Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 24, width: 180, color: Colors.white),
                        const SizedBox(height: 12),
                        Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }
                  return RankingCard(
                    item: RankingItem.dummy(),
                    isSkeleton: true,
                  );
                },
              ),
            );
          }

          if (state is RankingSuccess) {
            final List<RankingItem> orderedItems = List.from(state.items);
            orderedItems.sort((a, b) => a.position.compareTo(b.position));

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              itemCount: orderedItems.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI ANALYSIS FOR:',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.7,
                            ),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          state.query,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _saveCollection(state.query, orderedItems),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            foregroundColor:
                                theme.colorScheme.onPrimaryContainer,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            minimumSize: const Size(0, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(
                            Icons.bookmark_add_outlined,
                            size: 18,
                          ),
                          label: const Text(
                            'Save Collection',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Divider(height: 24, thickness: 0.5),
                      ],
                    ),
                  );
                }

                final item = orderedItems[index - 1];
                final itemKey = '${item.position}_${item.title}';

                return TweenAnimationBuilder<double>(
                  key: ValueKey(itemKey),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: Duration(
                    milliseconds: 350 + (index * 50).clamp(0, 300),
                  ),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: RankingCard(item: item),
                );
              },
            );
          }

          // 🚀 SECCIÓN OPTIMIZADA: Inyección del nuevo widget desacoplado
          if (state is RankingError) {
            return ErrorView(
              rawMessage: state.message,
              onActionPressed: _openSearchModal,
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 48,
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  'Please enter a topic to search.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
