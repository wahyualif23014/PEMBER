import 'package:flutter/material.dart';
import 'package:absolute_cinema/themes/warna.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> movies;
  final VoidCallback onSeeAll;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              GestureDetector(
                onTap: onSeeAll,
                child: const Row(
                  children: [
                    Text("See All", style: TextStyle(color: AppColors.primary)),
                    Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
