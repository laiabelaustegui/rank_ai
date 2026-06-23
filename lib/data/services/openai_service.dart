import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import 'dart:developer' as developer;

class OpenAIService {
  static const String _systemPrompt = '''
You are an expert AI engine specialized in generating structured rankings based on user requests.

Core Instructions:
1. Analyze the user query. If it is impossible, nonsensical, or inappropriate to create a ranking from it, set "isRankable" to false and provide a polite explanation in "errorMessage" (written in the user's language).
2. If valid, set "isRankable" to true and "errorMessage" to null.
3. Determine the number of items to return:
   - If the user explicitly asks for a specific number of items (e.g., "Top 3", "5 best"), strictly generate exactly that number of items.
   - If the user does not specify a number, generate a high-quality ranking containing UP TO 10 items maximum (choose an optimal number between 3 and 10 based on the topic's relevance).
4. Criterias & Language: Use a professional tone and objective consensus for the ordering. Write all text fields (titles, descriptions, subtitles, tags, ranking_criteria, error messages) in the exact same language as the user query.
5. Fields Semantic:
   - "subtitle": Author, brand, creator, year, director, or sub-category depending on the query context.
   - "tags": 2 or 3 short relevant keywords (e.g., ["Bestseller", "Classic"]).
   - "keyStats": Up to 3 key-value string pairs relevant to the topic (e.g., {"Price": "\$15", "Pages": "320"}).
   - "ranking_criteria": A list of up to 3 short criteria that justify why this item is in this specific position (e.g., {"name": "Innovation", "reason": "Revolutionized the market in 2023"}).
   - "imageUrl": Return null unless you have a completely permanent, reliable public URL.
''';

  static const Map<String, dynamic> _rankingJsonSchema = {
    'name': 'ranking_response',
    'strict': true,
    'schema': {
      'type': 'object',
      'properties': {
        'isRankable': {'type': 'boolean'},
        'errorMessage': {
          'anyOf': [
            {'type': 'string'},
            {'type': 'null'},
          ],
        },
        'ranking_list': {
          'type': 'array',
          'items': {
            'type': 'object',
            'properties': {
              'position': {'type': 'integer'},
              'title': {'type': 'string'},
              'subtitle': {'type': 'string'},
              'description': {'type': 'string'},
              'rating': {'type': 'number'},
              'tags': {
                'type': 'array',
                'items': {'type': 'string'},
              },
              // 🛠️ FIX REQUERIDO PARA KEYSTATS EN MODO STRICT
              'keyStats': {
                'type': 'object',
                'properties': {},
                'additionalProperties': {'type': 'string'},
                'required': [],
              },
              'ranking_criteria': {
                'type': 'array',
                'items': {
                  'type': 'object',
                  'properties': {
                    'name': {'type': 'string'},
                    'reason': {'type': 'string'},
                  },
                  'required': ['name', 'reason'],
                  'additionalProperties': false,
                },
              },
              'location': {
                'anyOf': [
                  {'type': 'string'},
                  {'type': 'null'},
                ],
              },
              'imageUrl': {
                'anyOf': [
                  {'type': 'string'},
                  {'type': 'null'},
                ],
              },
            },
            'required': [
              'position',
              'title',
              'subtitle',
              'description',
              'rating',
              'tags',
              'keyStats',
              'ranking_criteria',
              'location',
              'imageUrl',
            ],
            'additionalProperties': false,
          },
        },
      },
      'required': ['isRankable', 'errorMessage', 'ranking_list'],
      'additionalProperties': false,
    },
  };

  Future<String> fetchRankingJson(String query) async {
    final url = Uri.parse(ApiConstants.openAiUrl);

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${ApiConstants.openAiApiKey}',
    };

    final body = jsonEncode({
      'model': 'gpt-4o-mini',
      'response_format': {
        'type': 'json_schema',
        'json_schema': _rankingJsonSchema,
      },
      'messages': [
        {'role': 'system', 'content': _systemPrompt},
        {
          'role': 'user',
          'content':
              'Process this request and generate the ranking if applicable: "$query"',
        },
      ],
      'temperature': 0.4,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);
      developer.log(
        '✅ Respuesta cruda de OpenAI recibida (Esquema con Criterios):',
        name: 'RankAI.Service',
      );
      return decodedBody;
    }

    throw Exception(
      'OpenAI API Error: ${response.statusCode} - ${response.body}',
    );
  }
}
