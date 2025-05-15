import 'dart:convert';

import 'package:absolute_cinema/api_links/all_api.dart';
import 'package:absolute_cinema/models/movie_model.dart';
import 'package:http/http.dart' as http;

class TheMovieDB {
  Future<List> fetchNowPlayingMovies() async {
    try {
      final response = await http.get(Uri.parse(nowplayingmoviesurl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] ?? [])
            .where((m) => m['poster_path'] != null)
            .toList();
      }
      return [];
    } catch (e) {
      print("Error fetching now playing: $e");
      return [];
    }
  }

  Future<List> fetchUpcomingMovies() async {
    try {
      final response = await http.get(Uri.parse(upcomingmoviesurl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data["results"] ?? [])
            .where((m) => m['poster_path'] != null)
            .toList();
      }
      return [];
    } catch (e) {
      print("Error fetching upcoming: $e");
      return [];
    }
  }

  static Future<Movie> fetchMovieDetail(String movieId) async {
    final url = detailMovieUrl(movieId);

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return Movie.fromJson(data, movieId);
      } else {
        throw Exception('Failed to load movie detail: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movie detail: $e');
    }
  }
}
