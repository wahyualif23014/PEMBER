import 'package:flutter/material.dart';

class ShowtimeSelectorWidget extends StatelessWidget {
  final List<String> showtimes;
  final String? selectedTime;
  final Function(String) onSelected;

  const ShowtimeSelectorWidget({
    super.key,
    this.showtimes = const ['12:00', '14:30', '17:00', '19:30', '21:00'],
    required this.selectedTime,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Select Showtime",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: showtimes.map((time) {
            final isSelected = time == selectedTime;
            return ChoiceChip(
              label: Text(time),
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              selected: isSelected,
              selectedColor: Colors.yellow,
              backgroundColor: Colors.grey.shade800,
              onSelected: (_) => onSelected(time),
            );
          }).toList(),
        ),
      ],
    );
  }
}
