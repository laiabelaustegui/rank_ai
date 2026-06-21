import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // IMPORTANTE: Falta este paquete
import '../blocs/ranking/ranking_bloc.dart';
import '../blocs/ranking/ranking_state.dart';
import '../widgets/ranking_card.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Ranking Results'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      // 🔄 ESCUCHAR ESTADOS DEL BLOC MEDIANTE BLOCBUILDER
      body: BlocBuilder<RankingBloc, RankingState>(
        builder: (context, state) {
          // 1. ESTADO: CARGANDO (Muestra el spinner de progreso)
          if (state is RankingLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          // 2. ESTADO: ÉXITO (Dibuja la lista real con las tarjetas modulares)
          if (state is RankingSuccess) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return RankingCard(item: state.items[index]);
              },
            );
          }

          // 3. ESTADO: ERROR (Muestra un mensaje estilizado si algo falla)
          if (state is RankingError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          // 4. ESTADO INICIAL (Por si acaso cae aquí antes de disparar nada)
          return const Center(child: Text('Please enter a topic to search.'));
        },
      ),
    );
  }
}
