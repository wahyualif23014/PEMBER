class Movie {
  final String id;
  final String title;
  final String posterPath;
  final double rating;
  final String status; 

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.status,
  });

  factory Movie.fromJson(Map<String, dynamic> json, String id) {
    return Movie(
      id: id,
      title: json['title'] ?? 'No Title',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      status: json['status'] ?? 'now',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'poster_path': posterPath,
      'vote_average': rating,
      'status': status,
    };
  }
}
