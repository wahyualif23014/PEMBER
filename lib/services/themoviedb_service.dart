import 'dart:convert';

import 'package:absolute_cinema/api_links/all_api.dart';
import 'package:http/http.dart' as http;

class TheMovieDB {
  Future<List> fetchMovies() async {
    try {
      final response = await http.get(Uri.parse(nowplayingmoviesurl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else {
        print("Failed to fetch: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching movies: $e");
      return [];
    }
  }
}
