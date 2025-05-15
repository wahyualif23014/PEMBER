// lib/screens/ticket_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:absolute_cinema/providers/TicketProvider.dart';
import 'package:absolute_cinema/screens/booking_screen.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tickets = Provider.of<TicketProvider>(context).tickets;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Tickets',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: tickets.isEmpty
          ? const Center(
              child: Text(
                "No tickets booked yet.",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
  final ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TicketProvider>(context, listen: false);

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      shadowColor: Colors.yellow.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.movie.title,
              style: const TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white70, size: 20),
                const SizedBox(width: 6),
                Text(
                  ticket.showtime,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.event_seat, color: Colors.white70, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    ticket.seats.join(', '),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.yellow.withOpacity(0.7)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Price",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  "Rp${ticket.totalPrice}",
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    final editedTicket = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingScreen(
                          movie: ticket.movie,
                          existingTicket: ticket, 
                        ),
                      ),
                    );

                    if (editedTicket != null) {
                      provider.updateTicket(editedTicket);
                    }
                  },
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    provider.deleteTicket(ticket.id);
                  },
                  child: const Text(
                    "Delete",
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
