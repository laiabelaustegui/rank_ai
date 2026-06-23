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

class GeoCoordinates {
  final double latitude;
  final double longitude;

  GeoCoordinates({required this.latitude, required this.longitude});

  factory GeoCoordinates.fromJson(Map<String, dynamic> json) {
    return GeoCoordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
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
  final List<PositionCriterion> rankingCriteria;
  final String? location;
  final GeoCoordinates? coordinates;
  final String? websiteUrl;
  final String? phoneNumber;

  RankingItem({
    required this.position,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.rating,
    required this.tags,
    required this.keyStats,
    required this.rankingCriteria,
    this.location,
    this.coordinates,
    this.websiteUrl,
    this.phoneNumber,
  });

  factory RankingItem.fromJson(Map<String, dynamic> json) {
    return RankingItem(
      position: json['position'] as int,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rating: (json['rating'] as num? ?? 0.0).toDouble(),
      location: json['location'] as String?,
      websiteUrl: (json['website_url'] ?? json['websiteUrl']) as String?,
      phoneNumber: (json['phone_number'] ?? json['phoneNumber']) as String?,

      coordinates: json['coordinates'] != null
          ? GeoCoordinates.fromJson(json['coordinates'] as Map<String, dynamic>)
          : null,

      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      keyStats: Map<String, String>.from(json['keyStats'] ?? {}),

      rankingCriteria:
          (json['ranking_criteria'] as List<dynamic>?)
              ?.map(
                (e) => PositionCriterion.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  factory RankingItem.dummy() {
    return RankingItem(
      position: 0,
      title: '',
      subtitle: '',
      description: '',
      rating: 0.0,
      tags: [],
      keyStats: {},
      rankingCriteria: [],
      location: null,
      coordinates: null,
      websiteUrl: null,
      phoneNumber: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'rating': rating,
      'location': location,
      'tags': tags,
      'keyStats': keyStats,
      'ranking_criteria': rankingCriteria.map((e) => e.toJson()).toList(),
      'coordinates': coordinates?.toJson(),
      'websiteUrl': websiteUrl,
      'phoneNumber': phoneNumber,
    };
  }
}
