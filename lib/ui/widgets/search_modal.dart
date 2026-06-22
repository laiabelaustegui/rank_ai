import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_search_bar.dart';
import '../blocs/ranking/ranking_event.dart';
import '../blocs/ranking/ranking_bloc.dart';
import '../screens/ranking_screen.dart';

class SearchModalScreen extends StatefulWidget {
  const SearchModalScreen({super.key});

  @override
  State<SearchModalScreen> createState() => _SearchModalScreenState();
}

class _SearchModalScreenState extends State<SearchModalScreen> {
  final TextEditingController _modalController = TextEditingController();

  // Lista ficticia de búsquedas recientes (puedes conectarla a local storage o BLoC después)
  final List<String> _recentSearches = [
    'Best coffee shops',
    'Top must-watch sci-fi movies',
    'Crypto trends 2026',
    'Best dynamic warm up routines',
  ];

  void _executeSearch(String query) {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;

    // Disparar evento del BLoC
    context.read<RankingBloc>().add(FetchRankingEvent(cleanQuery));

    // Reemplazar la pantalla actual (el modal) por la de resultados
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RankingScreen()),
    );
  }

  @override
  void dispose() {
    _modalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header estilo Instagram: Botón atrás + Input Real
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: CustomSearchBar(
                      controller: _modalController,
                      hintText: 'Search topics to rank...',
                      onSearch: () => _executeSearch(_modalController.text),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sección de búsquedas recientes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Recent Searches',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Lista de búsquedas recientes
            Expanded(
              child: ListView.builder(
                itemCount: _recentSearches.length,
                itemBuilder: (context, index) {
                  final item = _recentSearches[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    leading: Icon(
                      Icons.history,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    title: Text(item, style: theme.textTheme.bodyLarge),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        setState(() {
                          _recentSearches.removeAt(index);
                        });
                      },
                    ),
                    onTap: () =>
                        _executeSearch(item), // Al pulsar, busca directo
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
