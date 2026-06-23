import 'dart:convert';
import '../models/ranking_item.dart';
import '../services/openai_service.dart';
import 'ranking_repository.dart';
import 'dart:developer' as developer;

class OpenAIRepository implements RankingRepository {
  final OpenAIService _openAiService;

  OpenAIRepository({required this._openAiService});

  @override
  Future<List<RankingItem>> getRanking(String query) async {
    try {
      developer.log(
        '⚡ Solicitando ranking al servicio para: "$query"',
        name: 'RankAI.Repository',
      );
      final String rawJson = await _openAiService.fetchRankingJson(query);

      final Map<String, dynamic> data = jsonDecode(rawJson);
      final String assistantMessage = data['choices'][0]['message']['content'];
      final Map<String, dynamic> jsonResponse = jsonDecode(assistantMessage);

      final encoder = const JsonEncoder.withIndent('  ');
      final String prettyJson = encoder.convert(jsonResponse);
      developer.log(
        '📦 JSON del asistente mapeado con éxito:\n$prettyJson',
        name: 'RankAI.Repository',
      );

      final bool isRankable = jsonResponse['isRankable'] ?? false;

      if (!isRankable) {
        developer.log(
          '⚠️ La solicitud no es válida para rankear (isRankable = false). Lanzando excepción controlada.',
          name: 'RankAI.Repository',
        );
        throw const FormatException('NOT_RANKABLE_ERROR');
      }

      final List<dynamic> itemsJson = jsonResponse['ranking_list'] ?? [];

      developer.log(
        '🔄 Parseando ${itemsJson.length} elementos a RankingItem...',
        name: 'RankAI.Repository',
      );
      final List<RankingItem> items = itemsJson
          .map((json) => RankingItem.fromJson(json))
          .toList();

      developer.log(
        '✅ Mapeo completado. Retornando ${items.length} objetos.',
        name: 'RankAI.Repository',
      );
      return items;
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error procesando el ranking en el repositorio',
        name: 'RankAI.Repository',
        error: e,
        stackTrace: stackTrace,
      );

      if (e is FormatException && e.message == 'NOT_RANKABLE_ERROR') {
        throw Exception('NOT_RANKABLE_ERROR');
      }

      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
