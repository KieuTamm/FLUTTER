class Game {
  final int id;
  final String name;
  final String backgroundImage;
  final double rating;
  final List<Genre> genres;
  final String? released;

  Game({
    required this.id,
    required this.name,
    required this.backgroundImage,
    required this.rating,
    required this.genres,
    this.released, // Thêm vào constructor
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      backgroundImage:
          json['background_image'] ?? 'https://via.placeholder.com/600x400',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      released: json['released'], // Lấy ngày phát hành từ API
      genres:
          (json['genres'] as List?)?.map((g) => Genre.fromJson(g)).toList() ??
          [],
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
