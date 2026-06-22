import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/ranking/ranking_bloc.dart';
import '../blocs/ranking/ranking_state.dart';
import '../widgets/ranking_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/ranking_filters.dart';
import '../../data/models/ranking_item.dart';
import '../widgets/search_modal.dart'; // 📦 IMPORTANTE: Importamos el nuevo modal

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  bool _isDescending = true;

  // Creamos la misma función de apertura para que la experiencia sea idéntica
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
      appBar: CustomAppBar(
        title: 'RankAI',
        onSearchPressed:
            _openSearchModal, // 🛠️ CAMBIADO: Ahora abre el modal directamente
      ),
      body: BlocBuilder<RankingBloc, RankingState>(
        builder: (context, state) {
          if (state is RankingLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (state is RankingSuccess) {
            final List<RankingItem> sortedItems = List.from(state.items);
            if (_isDescending) {
              sortedItems.sort((a, b) => b.rating.compareTo(a.rating));
            } else {
              sortedItems.sort((a, b) => a.rating.compareTo(b.rating));
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
                return RankingCard(item: sortedItems[index - 1]);
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
