import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rank_ai/data/services/search_history_service.dart'; // 📦 Tu servicio con import limpio
import 'package:rank_ai/data/repositories/ranking_repository.dart'; // 📦 Tu repositorio con import limpio
import 'ranking_event.dart';
import 'ranking_state.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState> {
  final RankingRepository _rankingRepository;

  // Mantenemos tu constructor idéntico con el parámetro requerido por nombre
  RankingBloc({required this._rankingRepository}) : super(RankingInitial()) {
    on<FetchRankingEvent>(_onFetchRanking);
  }

  Future<void> _onFetchRanking(
    FetchRankingEvent event,
    Emitter<RankingState> emit, // Usamos tu Emitter original
  ) async {
    final cleanQuery = event.query.trim();
    if (cleanQuery.isEmpty) return;

    emit(RankingLoading());
    try {
      // 💾 Guardamos silenciosamente en el historial usando el servicio
      await SearchHistoryService.saveSearch(cleanQuery);

      // Llamamos a tu método real: getRanking
      final items = await _rankingRepository.getRanking(cleanQuery);

      if (items.isEmpty) {
        emit(const RankingError('No results found for this topic.'));
      } else {
        emit(RankingSuccess(items: items, query: cleanQuery));
      }
    } catch (e) {
      emit(RankingError('Failed to generate ranking: ${e.toString()}'));
    }
  }
}
