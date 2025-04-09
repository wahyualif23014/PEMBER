import 'package:flutter/material.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const MovieSection({super.key, required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: Row(
                children: const [
                  Text('See All', style: TextStyle(color: Colors.yellow)),
                  Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Title",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      "Rate: 10/10",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
