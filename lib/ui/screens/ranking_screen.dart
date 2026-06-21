import 'package:flutter/material.dart';
import '../../data/repositories/mock_repository.dart';
import '../widgets/ranking_card.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = MockRepository.getMockRanking();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Ranking Results'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          // Invocamos el widget reutilizable pasándole el item correspondiente
          return RankingCard(item: items[index]);
        },
      ),
    );
  }
}
