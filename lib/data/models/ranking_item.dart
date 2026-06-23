// lib/data/models/ranking_item.dart

class PositionCriterion {
  final String name;
  final String reason;

  PositionCriterion({required this.name, required this.reason});

  factory PositionCriterion.fromJson(Map<String, dynamic> json) {
    return PositionCriterion(
      name: json['name'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'reason': reason};
  }
}

class RankingItem {
  final int position;
  final String title;
  final String subtitle;
  final String description;
  final double rating;
  final List<String> tags;
  final Map<String, String> keyStats;
  final List<PositionCriterion> rankingCriteria; // 🚀 El nuevo campo mapeado
  final String? imageUrl;
  final String? location;

  RankingItem({
    required this.position,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.rating,
    required this.tags,
    required this.keyStats,
    required this.rankingCriteria,
    this.imageUrl,
    this.location,
  });

  factory RankingItem.fromJson(Map<String, dynamic> json) {
    return RankingItem(
      position: json['position'] as int,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rating: (json['rating'] as num? ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      location: json['location'] as String?,
      // Parseo seguro de listas y mapas de strings
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      keyStats: Map<String, String>.from(json['keyStats'] ?? {}),
      // Mapeo de la sub-clase interna
      rankingCriteria:
          (json['ranking_criteria'] as List<dynamic>?)
              ?.map(
                (e) => PositionCriterion.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'rating': rating,
      'imageUrl': imageUrl,
      'location': location,
      'tags': tags,
      'keyStats': keyStats,
      'ranking_criteria': rankingCriteria.map((e) => e.toJson()).toList(),
    };
  }
}
