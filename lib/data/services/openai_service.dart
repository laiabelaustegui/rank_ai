import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class OpenAIService {
  // System prompt that instructs the AI on how to generate the ranking and handle errors
  static const String _systemPrompt = '''
You are an expert AI engine specialized in generating structured rankings based on user requests.

Core Instructions:
1. Analyze the user query. If it is impossible, nonsensical, or inappropriate to create a ranking from it, set "isRankable" to false and provide a polite explanation in "errorMessage" (written in the user's language).
2. If valid, set "isRankable" to true and "errorMessage" to null.
3. Determine the number of items to return:
   - If the user explicitly asks for a specific number of items (e.g., "Top 3", "5 best"), strictly generate exactly that number of items.
   - If the user does not specify a number, generate a high-quality ranking containing UP TO 10 items maximum (choose an optimal number between 3 and 10 based on the topic's relevance).
4. Criterias & Language: Use a professional tone and objective consensus for the ordering. Write all text fields (titles, descriptions, error messages) in the exact same language as the user query.
''';

  // Json Schema for the expected response from OpenAI
  static const Map<String, dynamic> _rankingJsonSchema = {
    'name': 'ranking_response',
    'strict': true,
    'schema': {
      'type': 'object',
      'properties': {
        'isRankable': {'type': 'boolean'},
        'errorMessage': {
          'type': ['string', 'null'],
        },
        'ranking_list': {
          'type': 'array',
          'items': {
            'type': 'object',
            'properties': {
              'position': {'type': 'integer'},
              'title': {'type': 'string'},
              'description': {'type': 'string'},
              'rating': {'type': 'number'},
              'location': {
                'type': ['string', 'null'],
              },
              'imageUrl': {
                'type': ['string', 'null'],
              },
            },
            'required': [
              'position',
              'title',
              'description',
              'rating',
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
      'temperature': 0.5,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }

    throw Exception(
      'OpenAI API Error: ${response.statusCode} - ${response.body}',
    );
  }
}
