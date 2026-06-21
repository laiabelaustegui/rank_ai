import 'package:flutter/material.dart';
import '../widgets/custom_search_bar.dart'; // Importamos tu nuevo componente
import '../widgets/suggestion_chip.dart';
import 'ranking_screen.dart';

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
    if (_searchController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a ranking topic first!')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RankingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                'RankAI',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ask for any ranking, powered by AI.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 40),

              // ¡Aquí invocamos tu buscador reutilizable!
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
                    elevation: 2,
                  ),
                  onPressed: _navigateToResults,
                  child: const Text(
                    'Generate Ranking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Sugerencias populares
              Text(
                'Popular suggestions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
