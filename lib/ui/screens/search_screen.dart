import 'package:flutter/material.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/suggestion_chip.dart';
import 'ranking_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/ranking/ranking_event.dart';
import '../blocs/ranking/ranking_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToResults() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a ranking topic first!')),
      );
      return;
    }

    context.read<RankingBloc>().add(FetchRankingEvent(query));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RankingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Se adapta automáticamente al scaffoldBackgroundColor de tu AppTheme (0xFFF8F9FA)
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'RankAI',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color:
                        theme.colorScheme.primary, // Usa tu primaryColor nativo
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ask for any ranking, powered by AI.',
                  style: theme
                      .textTheme
                      .bodyLarge, // Usa tus estilos globales textSecondary
                ),
                const SizedBox(height: 32),

                CustomSearchBar(
                  controller: _searchController,
                  onSearch: _navigateToResults,
                ),
                const SizedBox(height: 24),

                // Botón Principal
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0, // Material 3 plano
                    ),
                    onPressed: _navigateToResults,
                    child: const Text(
                      'Generate Ranking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Sugerencias populares
                Text(
                  'Popular suggestions',
                  style: theme
                      .textTheme
                      .titleMedium, // Aplica tu textPrimary de forma nativa
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    SuggestionChip(
                      label: '📚 Top 10 Business Books',
                      onTap: () => _searchController.text =
                          'Top 10 business books of all time',
                    ),
                    SuggestionChip(
                      label: '🍔 Best Burgers in NY',
                      onTap: () => _searchController.text =
                          'Top 5 best burger places in New York',
                    ),
                    SuggestionChip(
                      label: '🍿 Sci-Fi Movies',
                      onTap: () => _searchController.text =
                          'Top 7 must-watch sci-fi movies',
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // --- SECCIÓN DE PROCESO ---
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        'PROCESS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: theme
                              .colorScheme
                              .primary, // Mantiene la armonía cromática
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '3 Simple Steps',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize:
                              22, // Reutiliza el color base textPrimary de tu h1
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Paso 1: Azul de la semilla cromática
                _buildProcessStep(
                  theme: theme,
                  number: '1',
                  title: 'Search',
                  description:
                      "Tell us what you're looking for with a simple query.",
                  baseColor: Colors.blue.shade600,
                ),
                const SizedBox(height: 16),

                // Paso 2: Morado generado o del sistema
                _buildProcessStep(
                  theme: theme,
                  number: '2',
                  title: 'Analyze',
                  description:
                      'AI engine processes expert data and reviews instantly.',
                  baseColor: Colors.purple.shade600,
                ),
                const SizedBox(height: 16),

                // Paso 3: Tu propio color primario (Verde Teal)
                _buildProcessStep(
                  theme: theme,
                  number: '3',
                  title: 'Rank',
                  description:
                      'View the top results in a clear, interactive list.',
                  baseColor: theme.colorScheme.secondary,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessStep({
    required ThemeData theme,
    required String number,
    required String title,
    required String description,
    required Color baseColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors
            .white, // Resalta impecable sobre el fondo F8F9FA de tu scaffold
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ), // Copia el estilo sutil de tus Chips
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: baseColor.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: baseColor.withOpacity(0.2)),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                color: baseColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize:
                  18, // Agranda un poco manteniendo el color base textPrimary
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 14, // Usa tu textSecondary de forma nativa
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
