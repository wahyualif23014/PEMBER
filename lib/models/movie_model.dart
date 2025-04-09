class Movie {
  final String title;
  final String posterPath;
  final double rating;

  Movie({required this.title, required this.posterPath, required this.rating});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'No Title',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
    );
  }
}
