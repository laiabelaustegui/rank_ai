import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_search_bar.dart';
import '../blocs/ranking/ranking_event.dart';
import '../blocs/ranking/ranking_bloc.dart';
import '../../data/services/search_history_service.dart';
import 'ranking_screen.dart';

class SearchModalScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchModalScreen({super.key, this.initialQuery});

  @override
  State<SearchModalScreen> createState() => _SearchModalScreenState();
}

class _SearchModalScreenState extends State<SearchModalScreen> {
  final TextEditingController _modalController = TextEditingController();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _modalController.text = widget.initialQuery!;
    }

    _loadSearchHistory();
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

    context.read<RankingBloc>().add(FetchRankingEvent(cleanQuery));

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RankingScreen()),
    );

    _loadSearchHistory();
  }

  Future<void> _deleteSearchItem(String item) async {
    final updatedHistory = await SearchHistoryService.deleteSearch(item);
    setState(() {
      _recentSearches = updatedHistory;
    });
  }

  Future<void> _clearAllHistory() async {
    await SearchHistoryService.clearHistory();
    setState(() {
      _recentSearches = [];
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
            // 🛠️ MODIFICADO: Header con el buscador expandido y el botón Cancel a la derecha
            Padding(
              padding: const EdgeInsets.only(
                left:
                    24.0, // Más espacio en la izquierda ya que no está la flecha
                right: 12.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      controller: _modalController,
                      hintText: 'Search topics to rank...',
                      onSearch: () => _executeSearch(_modalController.text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          theme.colorScheme.primary, // Color primario
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sección de título + Botón "Clear" usando el App Theme
            if (_recentSearches.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: _clearAllHistory,
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Lista o Estado Vacío animador
            Expanded(
              child: _recentSearches.isEmpty
                  ? _buildEmptyState(theme)
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
                          onTap: () => _executeSearch(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      // Usamos un LayoutBuilder para calcular el espacio disponible real
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Container(
              // Forzamos al contenedor interno a ocupar la altura disponible del Expanded
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🛠️ COMPENSACIÓN ÓPTICA: Subimos ligeramente el diseño restando peso visual abajo
                  const Spacer(flex: 4),

                  // Círculo decorativo con icono de IA/Búsqueda
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_motion,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mensaje Principal animador
                  Text(
                    'What are we ranking today?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Texto descriptivo guía
                  Text(
                    'Type any topic above to discover, compare, and instantly generate an AI-backed ranking.\n\nTry gadgets, cities, books, or movies!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.8,
                      ),
                      height: 1.4,
                    ),
                  ),

                  // El Spacer inferior es más grande (flex: 5) para empujar el contenido hacia arriba sutilmente
                  const Spacer(flex: 5),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
