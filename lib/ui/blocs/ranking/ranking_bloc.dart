import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/ranking_repository.dart'; // Importa la interfaz
import 'ranking_event.dart';
import 'ranking_state.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState> {
  final RankingRepository _rankingRepository; // Depende de la abstracción

  RankingBloc({required this._rankingRepository}) : super(RankingInitial()) {
    on<FetchRankingEvent>(_onFetchRanking);
  }

  Future<void> _onFetchRanking(
    FetchRankingEvent event,
    Emitter<RankingState> emit,
  ) async {
    emit(RankingLoading());
    try {
      // Llamamos al método del repositorio pasándole la query del usuario
      final items = await _rankingRepository.getRanking(event.query);

      if (items.isEmpty) {
        emit(const RankingError('No results found for this topic.'));
      } else {
        emit(RankingSuccess(items: items, query: event.query));
      }
    } catch (e) {
      emit(RankingError('Failed to generate ranking: ${e.toString()}'));
    }
  }
}
