class RankingItem {
  final int position;
  final String title;
  final String description;
  final double rating;
  final String? imageUrl;
  final String? location;

  RankingItem({
    required this.position,
    required this.title,
    required this.description,
    required this.rating,
    this.imageUrl,
    this.location,
  });

  factory RankingItem.fromJson(Map<String, dynamic> json) {
    return RankingItem(
      position: json['position'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'title': title,
      'description': description,
      'rating': rating,
      'imageUrl': imageUrl,
      'location': location,
    };
  }
}
