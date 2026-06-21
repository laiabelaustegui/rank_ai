import 'package:equatable/equatable.dart';

abstract class RankingEvent extends Equatable {
  const RankingEvent();

  @override
  List<Object?> get props => [];
}

class FetchRankingEvent extends RankingEvent {
  final String query;

  const FetchRankingEvent(this.query);

  @override
  List<Object?> get props => [query];
}