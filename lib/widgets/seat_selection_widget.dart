import 'package:flutter/material.dart';

class SeatSelectionWidget extends StatelessWidget {
  final List<String> selectedSeats;
  final List<String> bookedSeats;
  final Function(String) onSeatTap;

  const SeatSelectionWidget({
    super.key,
    required this.selectedSeats,
    required this.bookedSeats,
    required this.onSeatTap,
  });

  @override
  Widget build(BuildContext context) {
    const rows = ['A', 'B', 'C', 'D', 'E', 'F'];
    const columns = [1, 2, 3, 4, 5, 6, 7, 8];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Select Your Seats",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 12),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendBox("Available", Colors.grey.shade800),
            const SizedBox(width: 8),
            _legendBox("Selected", Colors.yellow),
            const SizedBox(width: 8),
            _legendBox("Booked", Colors.redAccent),
          ],
        ),
        const SizedBox(height: 16),

        // Seat Grid
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children:
                rows.map((row) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        columns.map((col) {
                          final seatId = '$row$col';
                          final isSelected = selectedSeats.contains(seatId);
                          final isBooked = bookedSeats.contains(seatId);

                          Color bgColor;
                          if (isBooked) {
                            bgColor = Colors.redAccent;
                          } else if (isSelected) {
                            bgColor = Colors.yellow;
                          } else {
                            bgColor = Colors.grey.shade800;
                          }

                          return GestureDetector(
                            onTap: isBooked ? null : () => onSeatTap(seatId),
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                seatId,
                                style: TextStyle(
                                  color:
                                      isSelected || isBooked
                                          ? Colors.black
                                          : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _legendBox(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
