import 'package:flutter/material.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/suggestion_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/search_modal.dart'; // Importa el nuevo modal

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _dummyController = TextEditingController();

  // Función para abrir el modal con una transición limpia y rápida de abajo hacia arriba (o fade)
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
  void dispose() {
    _dummyController.dispose();
    super.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                Center(
                  child: Text(
                    'Find the absolute best',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Barra Falsa: Al pulsarla abre el modal tipo Instagram
                CustomSearchBar(
                  controller: _dummyController,
                  readOnly: true,
                  onTap: _openSearchModal,
                  onSearch: _openSearchModal,
                ),

                // ELIMINADO EL BOTÓN "GENERATE RANKING" AQUÍ
                const SizedBox(height: 32),

                // Sugerencias populares
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Trending Topics', style: theme.textTheme.titleMedium),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See all',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Scroll Horizontal de Tarjetas Sugeridas
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SuggestionCard(
                        icon: Icons.local_cafe_outlined,
                        iconColor: const Color(0xFF0D9488),
                        iconBgColor: const Color(0xFFE6F4F2),
                        title: 'Coffee Shops',
                        subtitle: '24 Top Picks',
                        onTap: _openSearchModal, // Te lleva al buscador
                      ),
                      const SizedBox(width: 12),
                      SuggestionCard(
                        icon: Icons.movie_filter_outlined,
                        iconColor: Colors.indigo,
                        iconBgColor: Colors.indigo.shade50,
                        title: 'Sci-Fi Movies',
                        subtitle: '45 Ranked items',
                        onTap: _openSearchModal,
                      ),
                      const SizedBox(width: 12),
                      SuggestionCard(
                        icon: Icons.menu_book_outlined,
                        iconColor: Colors.amber.shade900,
                        iconBgColor: Colors.amber.shade50,
                        title: 'Business Books',
                        subtitle: '10 Best Sellers',
                        onTap: _openSearchModal,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),
                Divider(height: 1, thickness: 1, color: theme.dividerColor),
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

                _buildProcessStep(
                  theme: theme,
                  number: '1',
                  title: 'Search',
                  description:
                      "Tell us what you're looking for with a simple query.",
                  baseColor: Colors.blue.shade600,
                ),
                const SizedBox(height: 16),

                _buildProcessStep(
                  theme: theme,
                  number: '2',
                  title: 'Analyze',
                  description:
                      'AI engine processes expert data and reviews instantly.',
                  baseColor: Colors.purple.shade600,
                ),
                const SizedBox(height: 16),

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

  // (Se mantiene intacto tu _buildProcessStep abajo...)
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
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
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
