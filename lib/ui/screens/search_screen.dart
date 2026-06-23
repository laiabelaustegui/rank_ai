import 'package:flutter/material.dart';
import '../widgets/suggestion_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/ranking_search_card.dart';
import 'search_modal.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  void _openSearchModal({String? initialQuery}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SearchModalScreen(initialQuery: initialQuery),
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
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // 1. INSIGNIA / BADGE: AI-POWERED INSIGHTS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AI-POWERED INSIGHTS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. TÍTULO PRINCIPAL
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 32,
                      letterSpacing: -0.5,
                    ),
                    children: [
                      const TextSpan(text: 'Discover the '),
                      TextSpan(
                        text: 'Best of\nEverything.',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. SUBTÍTULO DESCRIPTIVO
                Text(
                  'Get instantly generated, data-backed rankings for any query. From tech gadgets to hidden travel gems.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 24),

                // 4. TARJETA DE BÚSQUEDA DINÁMICA
                RankingSearchCard(onTap: _openSearchModal),

                const SizedBox(height: 32),

                // --- SECCIÓN: SUGGESTED TOPICS ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Suggested Topics',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 16),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      SuggestionCard(
                        icon: Icons.restaurant_outlined,
                        title: 'BCN Restaurants',
                        subtitle: 'Best hidden culinary gems',
                        onTap: () => _openSearchModal(
                          initialQuery:
                              'Best hidden gem restaurants in Barcelona',
                        ),
                      ),
                      const SizedBox(width: 12),
                      SuggestionCard(
                        icon: Icons.menu_book_outlined,
                        title: 'Business Books',
                        subtitle: 'Essential reads for founders',
                        onTap: () => _openSearchModal(
                          initialQuery: 'Essential business books for founders',
                        ),
                      ),
                      const SizedBox(width: 12),
                      SuggestionCard(
                        icon: Icons.casino_outlined,
                        title: 'Board Games',
                        subtitle: 'Best strategy games for groups',
                        onTap: () => _openSearchModal(
                          initialQuery:
                              'Best modern strategy board games for groups',
                        ),
                      ),
                      const SizedBox(width: 12),
                      SuggestionCard(
                        icon: Icons.movie_filter_outlined,
                        title: 'Sci-Fi Movies',
                        subtitle: 'Mind-bending masterpieces',
                        onTap: () => _openSearchModal(
                          initialQuery: 'Mind-bending sci-fi movies',
                        ),
                      ),
                      const SizedBox(width: 12),
                      SuggestionCard(
                        icon: Icons.local_cafe_outlined,
                        title: 'Coffee Shops',
                        subtitle: 'Best spots to work remotely',
                        onTap: () => _openSearchModal(
                          initialQuery: 'Best coffee shops to work remotely',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: theme.colorScheme.outlineVariant,
                ),
                const SizedBox(height: 36),

                // --- SECCIÓN DE PROCESO ---
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        'PROCESS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '3 Simple Steps',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 🛠️ MODIFICADO: Ahora pasamos tipos de paso estructurados en vez de colores fijos
                _buildProcessStep(
                  theme: theme,
                  number: '1',
                  title: 'Search',
                  description:
                      "Tell us what you're looking for with a simple query.",
                  stepType: _StepType.primary,
                ),
                const SizedBox(height: 16),

                _buildProcessStep(
                  theme: theme,
                  number: '2',
                  title: 'Analyze',
                  description:
                      'AI engine processes expert data and reviews instantly.',
                  stepType: _StepType.tertiary,
                ),
                const SizedBox(height: 16),

                _buildProcessStep(
                  theme: theme,
                  number: '3',
                  title: 'Rank',
                  description:
                      'View the top results in a clear, interactive list.',
                  stepType: _StepType.secondary,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget para mapear semánticamente los colores del tema sin hardcodeo
  Widget _buildProcessStep({
    required ThemeData theme,
    required String number,
    required String title,
    required String description,
    required _StepType stepType,
  }) {
    // Asigna dinámicamente el color objetivo resolviendo desde el colorScheme actual
    final Color stepColor = switch (stepType) {
      _StepType.primary => theme.colorScheme.primary,
      _StepType.secondary => theme.colorScheme.secondary,
      _StepType.tertiary => theme.colorScheme.tertiary,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: stepColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(color: stepColor.withValues(alpha: 0.2)),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                color: stepColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// 🛠️ ENUM AUXILIAR: Para mapear los pasos del proceso limpiamente
enum _StepType { primary, secondary, tertiary }
