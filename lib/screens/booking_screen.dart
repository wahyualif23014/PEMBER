import 'package:flutter/material.dart';
import 'package:absolute_cinema/models/movie_model.dart';
import 'package:absolute_cinema/widgets/seat_selection_widget.dart';
import 'package:absolute_cinema/widgets/time_selector_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:absolute_cinema/models/ticket_model.dart';
import 'package:absolute_cinema/providers/TicketProvider.dart';

class BookingScreen extends StatefulWidget {
  final Movie movie;
  final Ticket? editingTicket;
  final dynamic existingTicket;

  const BookingScreen({super.key, required this.movie, this.editingTicket, this.existingTicket});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<String> selectedSeats = [];
  String? selectedShowtime;
  final int seatPrice = 50000;

  @override
  void initState() {
    super.initState();
    if (widget.editingTicket != null) {
      selectedSeats = List.from(widget.editingTicket!.seats);
      selectedShowtime = widget.editingTicket!.showtime;
    }
  }

  void toggleSeat(String seat) {
    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    });
  }

  void confirmBooking() {
    if (selectedSeats.isEmpty || selectedShowtime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select seats and showtime.")),
      );
      return;
    }

    final total = selectedSeats.length * seatPrice;

    final ticket = Ticket(
      id: widget.editingTicket?.id ?? const Uuid().v4(),
      movie: widget.movie,
      seats: selectedSeats,
      showtime: selectedShowtime!,
      totalPrice: total,
    );

    if (widget.editingTicket != null) {
      Provider.of<TicketProvider>(context, listen: false).updateTicket(
        ticket,
      );
    } else {
      Provider.of<TicketProvider>(context, listen: false).addTicket(ticket);
    }

    Navigator.pop(context); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.editingTicket != null
            ? "Ticket updated!"
            : "Booking confirmed!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = selectedSeats.length * seatPrice;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.editingTicket != null ? 'Edit Ticket' : 'Booking Seat',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: Lottie.network(
                  'https://lottie.host/77041b64-04ee-4b9b-ad70-3511eafb361e/qIsGDWDg8S.json',
                ),
              ),
              Text(
                widget.movie.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro Display',
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
                  onSeatTap: toggleSeat,
                  bookedSeats: const [], // optionally update if needed
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
                  onSelected: (value) =>
                      setState(() => selectedShowtime = value),
                  selectedTime: selectedShowtime,
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
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
