import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  static const String baseUrl =
      'https://flutter-login-app-5bce8-default-rtdb.asia-southeast1.firebasedatabase.app/movie';

  static Future<List<Movie>> fetchMovies() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl.json'));
      final responseData = json.decode(res.body);

      if (responseData == null) return [];

      final Map<String, dynamic> data = responseData;
      return data.entries
          .map((entry) => Movie.fromJson(entry.value, entry.key))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

  static Future<void> addMovie(Movie movie) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl.json'),
        body: json.encode(movie.toJson()),
      );
      if (res.statusCode >= 400) {
        throw Exception('Failed to add movie');
      }
    } catch (e) {
      throw Exception('Error adding movie: $e');
    }
  }

  static Future<void> updateMovie(Movie movie) async {
    try {
      final res = await http.patch(
        Uri.parse('$baseUrl/${movie.id}.json'),
        body: json.encode(movie.toJson()),
      );
      if (res.statusCode >= 400) {
        throw Exception('Failed to update movie');
      }
    } catch (e) {
      throw Exception('Error updating movie: $e');
    }
  }

  static Future<void> deleteMovie(String id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id.json'));
      if (res.statusCode >= 400) {
        throw Exception('Failed to delete movie');
      }
    } catch (e) {
      throw Exception('Error deleting movie: $e');
    }
  }
}
