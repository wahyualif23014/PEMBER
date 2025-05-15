import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  final List dummyTickets = const []; // Kosongkan atau isi dengan dummy

  @override
  Widget build(BuildContext context) {
    final tickets = dummyTickets;

    return SafeArea(
      child:
          tickets.isEmpty
              ? const Center(
                child: Text(
                  "No tickets booked yet.",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                itemCount: tickets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return TicketCard(ticket: ticket);
                },
              ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final dynamic ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      shadowColor: Colors.yellow.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Movie Title",
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.white70, size: 20),
                SizedBox(width: 6),
                Text(
                  "Showtime",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.event_seat, color: Colors.white70, size: 20),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Seat A1, A2",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(color: Colors.yellow),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  "Rp50.000",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
