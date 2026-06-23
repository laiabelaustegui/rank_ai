import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import 'dart:developer' as developer;

class OpenAIService {
  static const String _systemPrompt = '''
You are an expert AI engine specialized in generating structured rankings based on user requests.

Core Instructions:
1. Analyze the user query. If it is impossible, nonsensical, or inappropriate to create a ranking from it, set "isRankable" to false.
2. If valid, set "isRankable" to true.
3. Determine the number of items to return:
   - If the user explicitly asks for a specific number of items (e.g., "Top 3", "5 best"), strictly generate exactly that number of items.
   - If the user does not specify a number, generate a high-quality ranking containing UP TO 10 items maximum (choose an optimal number between 3 and 10 based on the topic's relevance).
4. Criterias & Language: Use a professional tone and objective consensus for the ordering. Write all text fields (titles, descriptions, subtitles, tags, ranking_criteria) in the exact same language as the user query.
5. Fields Semantic:
   - "subtitle": Author, brand, creator, year, director, or sub-category depending on the query context.
   - "tags": 2 or 3 short relevant keywords (e.g., ["Bestseller", "Classic"]).
   - "keyStats": Strictly generate exactly 3 relevant key-value string pairs relevant to the topic (e.g., {"Price": "\$15", "Pages": "320", "Weight": "1.2kg"}). Do not generate fewer than 3.
   - "ranking_criteria": A list of up to 3 short criteria that justify why this item is in this specific position (e.g., {"name": "Innovation", "reason": "Revolutionized the market in 2023"}).
   - "location": Complete physical address (Street name, number, city, and country). For famous monuments, include both its specific popular square/street and the city. Set to null if the item is abstract or digital (e.g., books, movies, software, products).
   - "coordinates": Exact geographic coordinates. This is MANDATORY for physical objects/places located in the real world (monuments, buildings, restaurants, parks). If the item is abstract, digital, or a movable commercial product (like a smartphone or book), set this entire object to null.
   - "websiteUrl": The official main website URL of the place, brand, creator, or product if it exists and is globally known. Set to null if there is no highly reliable official website.
   - "phoneNumber": The official public contact telephone number (with international prefix, e.g., "+1 555-0199" or "+34 910 000 000") if applicable to the item (like a restaurant, hotel, company, or museum). Set to null if it does not apply or is not widely known.
''';

  static const Map<String, dynamic> _rankingJsonSchema = {
    'name': 'ranking_response',
    'strict': true,
    'schema': {
      'type': 'object',
      'properties': {
        'isRankable': {
          'type': 'boolean',
        }, // 📌 Conservamos únicamente el booleano controlador
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
              'coordinates': {
                'anyOf': [
                  {
                    'type': 'object',
                    'properties': {
                      'latitude': {'type': 'number'},
                      'longitude': {'type': 'number'},
                    },
                    'required': ['latitude', 'longitude'],
                    'additionalProperties': false,
                  },
                  {'type': 'null'},
                ],
              },
              'websiteUrl': {
                'anyOf': [
                  {'type': 'string'},
                  {'type': 'null'},
                ],
              },
              'phoneNumber': {
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
              'coordinates',
              'websiteUrl',
              'phoneNumber',
            ],
            'additionalProperties': false,
          },
        },
      },
      'required': [
        'isRankable',
        'ranking_list',
      ], // 🎯 errorMessage eliminado con éxito de los campos obligatorios
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
      'temperature': 0.3,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);
      developer.log(
        '✅ Respuesta cruda de OpenAI recibida (Esquema Modificado: Solo booleano de control):',
        name: 'RankAI.Service',
      );
      return decodedBody;
    }

    throw Exception(
      'OpenAI API Error: ${response.statusCode} - ${response.body}',
    );
  }
}
