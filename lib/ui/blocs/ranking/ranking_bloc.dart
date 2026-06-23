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
      await SearchHistoryService.saveSearch(cleanQuery);

      final items = await _rankingRepository.getRanking(cleanQuery);

      if (items.isEmpty) {
        throw const FormatException('NOT_RANKABLE_ERROR');
      } else {
        emit(RankingSuccess(items: items, query: cleanQuery));
      }
    } catch (e) {
      final errorStr = e.toString();

      if (errorStr.contains('NOT_RANKABLE_ERROR')) {
        emit(const RankingError('NOT_RANKABLE_ERROR'));
      } else {
        final cleanField = errorStr
            .replaceAll('Exception:', '')
            .replaceAll('FormatException:', '')
            .trim();

        emit(RankingError(cleanField));
      }
    }
  }
}
