import 'package:flutter/material.dart';
import '../models/ticket_model.dart';

class TicketDetailCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  const TicketDetailCard({
    super.key,
    required this.ticket,
    required this.onEdit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.movie.title,
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Showtime: ${ticket.showtime}",
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              "Seats: ${ticket.seats.join(', ')}",
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              "Total Price: Rp${ticket.totalPrice}",
              style: const TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onEdit,
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
                TextButton(
                  onPressed: onCancel,
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
