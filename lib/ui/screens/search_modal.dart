import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_search_bar.dart';
import '../blocs/ranking/ranking_event.dart';
import '../blocs/ranking/ranking_bloc.dart';
import '../../data/services/search_history_service.dart';
import 'ranking_screen.dart';

class SearchModalScreen extends StatefulWidget {
  const SearchModalScreen({super.key});

  @override
  State<SearchModalScreen> createState() => _SearchModalScreenState();
}

class _SearchModalScreenState extends State<SearchModalScreen> {
  final TextEditingController _modalController = TextEditingController();
  List<String> _recentSearches = []; // Lista dinámica

  @override
  void initState() {
    super.initState();
    _loadSearchHistory(); // Cargamos el historial al iniciar el modal
  }

  Future<void> _loadSearchHistory() async {
    final history = await SearchHistoryService.getHistory();
    if (mounted) {
      setState(() {
        _recentSearches = history;
      });
    }
  }

  void _executeSearch(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;

    // 1. Disparamos el evento (el BLoC guardará en el historial internamente)
    context.read<RankingBloc>().add(FetchRankingEvent(cleanQuery));

    // 2. Navegamos esperando a que el usuario regrese de la pantalla de resultados
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RankingScreen()),
    );

    // 3. ¡ESTO ES LO NUEVO! Cuando el usuario vuelve atrás de la RankingScreen,
    // el código continúa aquí, así que recargamos el historial actualizado.
    _loadSearchHistory(); 
  }

  Future<void> _deleteSearchItem(String item) async {
    // 🗑️ Eliminamos del almacenamiento local y actualizamos el estado visual
    final updatedHistory = await SearchHistoryService.deleteSearch(item);
    setState(() {
      _recentSearches = updatedHistory;
    });
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

            // Sección estática de título si hay búsquedas
            if (_recentSearches.isNotEmpty) ...[
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
            ],

            // Lista de búsquedas recientes persistidas
            Expanded(
              child: _recentSearches.isEmpty
                  ? Center(
                      child: Text(
                        'No recent searches yet.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _recentSearches.length,
                      itemBuilder: (context, index) {
                        final item = _recentSearches[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          leading: Icon(
                            Icons.history,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                          title: Text(item, style: theme.textTheme.bodyLarge),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => _deleteSearchItem(item),
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
