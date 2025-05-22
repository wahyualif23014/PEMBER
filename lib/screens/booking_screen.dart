import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:lottie/lottie.dart';
import 'package:absolute_cinema/services/notification_service.dart';

import 'package:absolute_cinema/models/movie_model.dart';
import 'package:absolute_cinema/models/ticket_model.dart';
import 'package:absolute_cinema/services/ticket_service.dart';
import 'package:absolute_cinema/widgets/seat_selection_widget.dart';
import 'package:absolute_cinema/widgets/time_selector_widget.dart';


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

  List<String> selectedSeats = [];
  List<String> bookedSeats = [];
  String? selectedShowtime;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Jika edit, isi ulang datanya
    if (widget.editingTicket != null) {
      selectedSeats = List.from(widget.editingTicket!.seats);
      selectedShowtime = widget.editingTicket!.showtime;
      fetchBookedSeats();
    } else {
      // Default: pilih showtime pertama
      selectedShowtime = '12:00';
      fetchBookedSeats();
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

  Future<void> fetchBookedSeats() async {
    if (selectedShowtime == null) return;

    setState(() => isLoading = true);
    final seats = await ticketService.fetchBookedSeatsByTitleAndTime(
      widget.movie.title,
      selectedShowtime!,
    );
    setState(() {
      bookedSeats = seats;
      selectedSeats.removeWhere(
        (s) => bookedSeats.contains(s),
      ); // hindari duplikat
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
    showtime: selectedShowtime!,
    totalPrice: selectedSeats.length * seatPrice,
  );

  if (widget.editingTicket != null) {
    await ticketService.updateTicketOnServer(ticket);
  } else {
    await ticketService.addTicketToServer(ticket, user.uid);

    // Notifikasi berhasil
    await NotificationService.awesome_notifications(
      title: 'Booking Berhasil',
      body: 'Tiket untuk "${widget.movie.title}" telah berhasil dipesan!',
    );

    await Future.delayed(const Duration(milliseconds: 300));
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
        elevation: 0,
        centerTitle: true,
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
                        selectedTime: selectedShowtime,
                        onSelected: (val) {
                          setState(() {
                            selectedShowtime = val;
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
