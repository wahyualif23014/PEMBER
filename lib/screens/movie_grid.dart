import 'package:flutter/material.dart';
import 'package:absolute_cinema/screens/movieDetail_screen.dart';
import 'package:absolute_cinema/screens/UpcommingDetail.dart';
import 'package:absolute_cinema/themes/colors.dart';

class MovieGrid extends StatelessWidget {
  final List movies;
  final void Function(Map movie)? onMovieTap;
  final String source;

  const MovieGrid({
    super.key,
    required this.movies,
    this.onMovieTap,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: movies.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 0.55, // Adjusted for better proportions
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            if (onMovieTap != null) {
              onMovieTap!(movie);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          source == "now_showing"
                              ? MovieDetailScreen(movie: movie)
                              : UpcomingDetailScreen(movie: movie),
                ),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster container with shadow and rounded corners
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[900],
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Movie title with adequate space
              SizedBox(
                height: 20, // Increased height for better text display
                child: Text(
                  movie['title'] ?? 'Untitled',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.2, // Adjusted line height
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Rating with consistent style
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "10/10",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
