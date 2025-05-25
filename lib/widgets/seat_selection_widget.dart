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
    const rows = ['A', 'B', 'C', 'D'];
    const columns = [1, 2, 3, 4, 5];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Select Your Seats",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Column(
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
                            margin: const EdgeInsets.all(6),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
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
      ],
    );
  }
}
