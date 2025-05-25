class Movie {
  final String id;
  final String title;
  final String posterPath;
  final double rating;

  final String? status;
  final String? overview;
  final String? releaseDate;
  final int? runtime;
  final List<String>? genres;
  final String? tagline;
  final List<String>? spokenLanguages;
  final String? homepage;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    this.status,
    this.overview,
    this.releaseDate,
    this.runtime,
    this.genres,
    this.tagline,
    this.spokenLanguages,
    this.homepage,
  });

  /// Factory for full detail (from TMDB)
  factory Movie.fromJson(Map<String, dynamic> json, [String? idOverride]) {
    return Movie(
      id: idOverride ?? json['id']?.toString() ?? '',
      title: json['title'] ?? 'No Title',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      status: json['status'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      runtime: json['runtime'],
      tagline: json['tagline'],
      homepage: json['homepage'],
      genres:
          (json['genres'] as List?)?.map((g) => g['name'].toString()).toList(),
      spokenLanguages:
          (json['spoken_languages'] as List?)
              ?.map((l) => l['english_name'].toString())
              .toList(),
    );
  }

  /// Factory for basic use (from ticket)
  factory Movie.fromTitle(String title) {
    return Movie(id: '', title: title, posterPath: '', rating: 0.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'vote_average': rating,
      'status': status,
      'overview': overview,
      'release_date': releaseDate,
      'runtime': runtime,
      'tagline': tagline,
      'homepage': homepage,
      'genres': genres?.map((g) => {'name': g}).toList(),
      'spoken_languages':
          spokenLanguages?.map((l) => {'english_name': l}).toList(),
    };
  }
}
