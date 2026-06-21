import 'package:equatable/equatable.dart';
import '../../../../data/models/ranking_item.dart';

abstract class RankingState extends Equatable {
  const RankingState();
  
  @override
  List<Object?> get props => [];
}

class RankingInitial extends RankingState {}

class RankingLoading extends RankingState {}

class RankingSuccess extends RankingState {
  final List<RankingItem> items;
  final String query;

  const RankingSuccess({required this.items, required this.query});

  @override
  List<Object?> get props => [items, query];
}

class RankingError extends RankingState {
  final String message;

  const RankingError(this.message);

  @override
  List<Object?> get props => [message];
}