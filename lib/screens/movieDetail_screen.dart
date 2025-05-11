import 'package:flutter/material.dart';
import 'package:absolute_cinema/models/movie_model.dart'; 

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Movie Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    height: 310,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      InfoTile("Genre", 'Drama, Action'), 
                      InfoTile("Duration", "130 Min"), 
                      InfoTile("Rating", "${movie.rating.toStringAsFixed(1)}/10"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.yellow),
            const SizedBox(height: 10),
            _buildText("Director", null),
            _buildText("Writer", null),
            _buildText("Actors", null),
            _buildText("Synopsis", null),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {},
              child: const Text("Book Now", style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }

  Widget InfoTile(String title, String value) {
    IconData iconData;

    switch (title.toLowerCase()) {
      case 'genre':
        iconData = Icons.movie;
        break;
      case 'duration':
        iconData = Icons.schedule;
        break;
      case 'rating':
        iconData = Icons.star;
        break;
      default:
        iconData = Icons.info;
    }

    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.yellow.shade700, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow.shade700,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.black, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildText(String label, dynamic content) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "$label : ${content ?? '-'}",
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
