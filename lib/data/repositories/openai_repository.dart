import 'dart:convert';
import '../models/ranking_item.dart';
import '../services/openai_service.dart';
import 'ranking_repository.dart';
import 'dart:developer' as developer;

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
      developer.log(
        '📦 JSON interno del asistente extraído correctamente.',
        name: 'RankAI.Repository',
      );

      final bool isRankable = jsonResponse['isRankable'] ?? false;

      if (!isRankable) {
        final String errorMsg =
            jsonResponse['errorMessage'] ??
            'It seems that the request cannot be ranked. Please try a different query.';
        developer.log(
          '⚠️ La solicitud no es válida para rankear. Motivo: $errorMsg',
          name: 'RankAI.Repository',
        );
        throw Exception(errorMsg);
      }

      final List<dynamic> itemsJson = jsonResponse['ranking_list'] ?? [];
      return itemsJson.map((json) => RankingItem.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
