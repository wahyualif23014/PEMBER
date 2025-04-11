import 'package:flutter/material.dart';

class SearchLocationBar extends StatelessWidget {
  const SearchLocationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.location_on, color: Colors.yellow, size: 16),
        SizedBox(width: 4),
        Text('Surabaya', style: TextStyle(color: Colors.white)),
      ],
    );
  }
}