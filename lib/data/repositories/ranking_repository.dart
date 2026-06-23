import '../models/ranking_item.dart';

abstract class RankingRepository {
  Future<List<RankingItem>> getRanking(String query);
}
