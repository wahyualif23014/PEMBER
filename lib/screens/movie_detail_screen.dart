import 'package:flutter/material.dart';
import 'package:absolute_cinema/screens/booking_screen.dart';
import 'package:absolute_cinema/services/themoviedb_service.dart';
import 'package:absolute_cinema/models/movie_model.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;
  final bool isUpcoming;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    this.isUpcoming = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Movie>(
      future: TheMovieDB.fetchMovieDetail(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.yellow),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'Failed to load movie details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final movie = snapshot.data;

        if (movie == null) {
          return const Center(
            child: Text(
              'No movie found.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(movie.title),
                if (isUpcoming) const SizedBox(width: 8),
                if (isUpcoming)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Upcoming",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (movie.tagline != null && movie.tagline!.isNotEmpty)
                  Center(
                    child: Text(
                      '"${movie.tagline}"',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.yellow,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 24),

                _sectionTitle("Synopsis"),
                Text(
                  movie.overview ?? '-',
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),

                const SizedBox(height: 24),

                _sectionTitle("Movie Info"),
                _infoRow("Status", movie.status),
                _infoRow("Release Date", movie.releaseDate),
                _infoRow(
                  "Duration",
                  movie.runtime != null ? "${movie.runtime} min" : null,
                ),
                _infoRow("Rating", "${movie.rating.toStringAsFixed(1)}/10"),
                _infoRow("Genres", movie.genres?.join(", ")),
                _infoRow("Languages", movie.spokenLanguages?.join(", ")),

                const SizedBox(height: 32),

                if (!isUpcoming)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(movie: movie),
                          ),
                        );
                      },
                      child: const Text(
                        "Book Now",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$label:",
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
