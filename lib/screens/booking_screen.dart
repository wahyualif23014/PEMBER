import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:lottie/lottie.dart';

import '../models/movie_model.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/seat_selection_widget.dart';
import '../widgets/time_selector_widget.dart';

class BookingScreen extends StatefulWidget {
  final Movie movie;
  final Ticket? editingTicket;

  const BookingScreen({super.key, required this.movie, this.editingTicket});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TicketService ticketService = TicketService();
  final int seatPrice = 50000;

  final List<String> defaultTimes = ['12:00', '15:00', '18:00'];

  List<String> selectedSeats = [];
  List<String> bookedSeats = [];
  DateTime? selectedShowtime;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.editingTicket != null) {
      selectedSeats = List.from(widget.editingTicket!.seats);

      final now = DateTime.now();
      final timeParts = widget.editingTicket!.showtime.split(":");
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      selectedShowtime = DateTime(now.year, now.month, now.day, hour, minute);
    } else {
      final now = DateTime.now();
      final defaultTime = defaultTimes.first;
      final hour = int.parse(defaultTime.split(":")[0]);
      final minute = int.parse(defaultTime.split(":")[1]);
      selectedShowtime = DateTime(now.year, now.month, now.day, hour, minute);
    }

    Future.delayed(Duration.zero, fetchBookedSeats);
  }

  void toggleSeat(String seat) {
    setState(() {
      selectedSeats.contains(seat)
          ? selectedSeats.remove(seat)
          : selectedSeats.add(seat);
    });
  }

  Future<void> fetchBookedSeats() async {
    if (selectedShowtime == null) return;
    setState(() => isLoading = true);

    List<String> seats;
    if (widget.editingTicket != null) {
      seats = await ticketService.fetchBookedSeatsByTitleAndTime(
        widget.movie.title,
        selectedShowtime!,
        excludeTicketId: widget.editingTicket!.id,
      );
    } else {
      seats = await ticketService.fetchBookedSeatsByTitleAndTime(
        widget.movie.title,
        selectedShowtime!,
      );
    }

    setState(() {
      bookedSeats = seats;
      selectedSeats.removeWhere((s) => bookedSeats.contains(s));
      isLoading = false;
    });
  }

  Future<void> confirmBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || selectedSeats.isEmpty || selectedShowtime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select showtime and seats.")),
      );
      return;
    }

    final ticket = Ticket(
      id: widget.editingTicket?.id ?? const Uuid().v4(),
      movie: widget.movie,
      seats: selectedSeats,
      showtime:
          "${selectedShowtime!.hour.toString().padLeft(2, '0')}:${selectedShowtime!.minute.toString().padLeft(2, '0')}",
      totalPrice: selectedSeats.length * seatPrice,
    );

    if (widget.editingTicket != null) {
      await ticketService.updateTicketOnServer(ticket);
    } else {
      print("masuk");
      await ticketService.addTicketToServer(ticket, user.uid);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.editingTicket != null
              ? "Ticket updated!"
              : "Booking confirmed!",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final total = selectedSeats.length * seatPrice;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.editingTicket != null ? "Edit Ticket" : "Booking Seat",
        ),
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.yellow),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Lottie.network(
                      'https://lottie.host/77041b64-04ee-4b9b-ad70-3511eafb361e/qIsGDWDg8S.json',
                      height: 180,
                    ),
                    Text(
                      widget.movie.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SeatSelectionWidget(
                        selectedSeats: selectedSeats,
                        bookedSeats: bookedSeats,
                        onSeatTap: toggleSeat,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ShowtimeSelectorWidget(
                        selectedTime:
                            selectedShowtime != null
                                ? "${selectedShowtime!.hour.toString().padLeft(2, '0')}:${selectedShowtime!.minute.toString().padLeft(2, '0')}"
                                : defaultTimes.first,
                        onSelected: (val) {
                          final hour = int.parse(val.split(":")[0]);
                          final minute = int.parse(val.split(":")[1]);
                          final now = DateTime.now();

                          setState(() {
                            selectedShowtime = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              hour,
                              minute,
                            );
                          });

                          fetchBookedSeats();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Price",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        Text(
                          "Rp$total",
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: confirmBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(double.infinity, 55),
                      ),
                      child: Text(
                        widget.editingTicket != null
                            ? "Update Ticket"
                            : "Confirm Booking",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}
