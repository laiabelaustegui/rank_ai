import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // 🛠️ NUEVO IMPORT
import '../blocs/ranking/ranking_bloc.dart';
import '../blocs/ranking/ranking_state.dart';
import '../widgets/ranking_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/ranking_filters.dart';
import '../../data/models/ranking_item.dart';
import 'search_modal.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  bool _isDescending = true;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'RankAI', onSearchPressed: _openSearchModal),
      body: BlocBuilder<RankingBloc, RankingState>(
        builder: (context, state) {
          // 🛠️ ADAPTADO: Bloque Shimmer en estado de carga (Loading)
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
                physics:
                    const NeverScrollableScrollPhysics(), // Desactiva scroll mientras carga
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                itemCount:
                    5, // Renderiza el filtro superior + 4 tarjetas falsas
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Esqueleto para simular la barra superior 'RankingFilterBar'
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    );
                  }

                  // Renderiza las tarjetas usando tu nuevo modo esqueleto
                  return RankingCard(
                    item: RankingItem.dummy(),
                    isSkeleton: true,
                  );
                },
              ),
            );
          }

          if (state is RankingSuccess) {
            final List<RankingItem> sortedItems = List.from(state.items);

            // 🛠️ CORREGIDO: Ordenar por 'position' en lugar de 'rating'
            if (_isDescending) {
              // Si es descendente, queremos la posición #1 arriba, luego #2, #3...
              sortedItems.sort((a, b) => a.position.compareTo(b.position));
            } else {
              // Si el usuario invierte el filtro, queremos las posiciones más altas arriba (#10, #9, #8...)
              sortedItems.sort((a, b) => b.position.compareTo(a.position));
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              itemCount: sortedItems.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return RankingFilterBar(
                    query: state.query,
                    isDescending: _isDescending,
                    onSortChanged: (descending) {
                      setState(() => _isDescending = descending);
                    },
                  );
                }

                final item = sortedItems[index - 1];
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

          if (state is RankingError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(state.message, style: theme.textTheme.titleMedium),
              ),
            );
          }

          return const Center(child: Text('Please enter a topic to search.'));
        },
      ),
    );
  }
}
