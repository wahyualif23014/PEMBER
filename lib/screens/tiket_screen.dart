import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:absolute_cinema/models/ticket_model.dart';
import 'package:absolute_cinema/services/ticket_service.dart';
import 'package:absolute_cinema/screens/booking_screen.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final TicketService ticketService = TicketService();
  List<Ticket> userTickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserTickets();
  }

  Future<void> _loadUserTickets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    await ticketService.fetchTicketsByUserId(user.uid);
    setState(() {
      userTickets = ticketService.tickets;
      isLoading = false;
    });
  }

  Future<void> _deleteTicket(String id) async {
    await ticketService.deleteTicket(id);
    await _loadUserTickets();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Ticket deleted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.yellow),
              )
              : userTickets.isEmpty
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
                itemCount: userTickets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final ticket = userTickets[index];
                  return TicketCard(
                    ticket: ticket,
                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Delete Ticket?"),
                              content: const Text(
                                "Are you sure you want to delete this ticket?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        await _deleteTicket(ticket.id);
                      }
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BookingScreen(
                                movie: ticket.movie,
                                editingTicket: ticket,
                              ),
                        ),
                      ).then((_) => _loadUserTickets()); // reload after edit
                    },
                  );
                },
              ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onEdit,
    required this.onDelete,
  });

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
            const Divider(color: Colors.yellow),
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
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.white),
                  tooltip: "Edit Ticket",
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: "Delete Ticket",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
