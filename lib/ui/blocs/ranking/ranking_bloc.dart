import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rank_ai/data/services/search_history_service.dart';
import 'package:rank_ai/data/repositories/ranking_repository.dart';
import 'ranking_event.dart';
import 'ranking_state.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState> {
  final RankingRepository _rankingRepository;

  RankingBloc({required this._rankingRepository}) : super(RankingInitial()) {
    on<FetchRankingEvent>(_onFetchRanking);
  }

  Future<void> _onFetchRanking(
    FetchRankingEvent event,
    Emitter<RankingState> emit,
  ) async {
    final cleanQuery = event.query.trim();
    if (cleanQuery.isEmpty) return;

    emit(RankingLoading());
    try {
      // 💾 Guardamos en el historial de forma asíncrona
      await SearchHistoryService.saveSearch(cleanQuery);

      // Llamada al repositorio
      final items = await _rankingRepository.getRanking(cleanQuery);

      if (items.isEmpty) {
        // 🚀 Si la lista viene vacía, también lo forzamos como no rankeable
        throw const FormatException('NOT_RANKABLE_ERROR');
      } else {
        emit(RankingSuccess(items: items, query: cleanQuery));
      }
    } catch (e) {
      final errorStr = e.toString();

      // 🎯 INTERCEPCIÓN ROBUSTA: Si el error contiene nuestro token (venga de donde venga)
      if (errorStr.contains('NOT_RANKABLE_ERROR')) {
        // Emitimos la cadena limpia para que la vista lo intercepte sin ruido de Dart
        emit(const RankingError('NOT_RANKABLE_ERROR'));
      } else {
        // Para cualquier otra excepción (Red, Timeout, etc.)
        // Limpiamos los prefijos clásicos "Exception:" de Dart para que no ensucien
        final cleanField = errorStr
            .replaceAll('Exception:', '')
            .replaceAll('FormatException:', '')
            .trim();

        emit(RankingError(cleanField));
      }
    }
  }
}
