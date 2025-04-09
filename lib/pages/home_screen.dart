import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:absolute_cinema/themes/warna.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];

  final String apiKey = '08c65abc73be4c1cc0e0e39cd1b19141';

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movies = data['results'];
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return movies.isEmpty
        ? const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(
              title: movie['title'] ?? 'Tanpa Judul',
              imageUrl:
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              overview: movie['overview'] ?? '',
            );
          },
        );
  }
}

class MovieCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String overview;

  const MovieCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.iconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    overview,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.iconColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
