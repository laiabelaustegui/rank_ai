import 'dart:convert';
import '../models/ranking_item.dart';
import '../services/openai_service.dart';
import 'ranking_repository.dart';

class OpenAIRepository implements RankingRepository {
  final OpenAIService _openAiService;

  // Constructor that requires an instance of OpenAIService
  OpenAIRepository({required this._openAiService});

  @override
  Future<List<RankingItem>> getRanking(String query) async {
    try {
      final String rawJson = await _openAiService.fetchRankingJson(query);

      final Map<String, dynamic> data = jsonDecode(rawJson);
      final String assistantMessage = data['choices'][0]['message']['content'];
      final Map<String, dynamic> jsonResponse = jsonDecode(assistantMessage);

      final bool isRankable = jsonResponse['isRankable'] ?? false;

      if (!isRankable) {
        final String errorMsg =
            jsonResponse['errorMessage'] ??
            'It seems that the request cannot be ranked. Please try a different query.';
        throw Exception(errorMsg);
      }

      final List<dynamic> itemsJson = jsonResponse['ranking_list'] ?? [];
      return itemsJson.map((json) => RankingItem.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
