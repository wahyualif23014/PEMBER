import 'package:absolute_cinema/themes/warna.dart';
import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data contoh untuk tiket
    final List<Map<String, dynamic>> tickets = [
      {
        'movieTitle': 'Avatar 3',
        'date': '20 Mar 2025',
        'time': '19:30',
        'seats': 'D4, D5',
        'cinema': 'Cinema XXI Mall Central',
        'ticketCode': 'TIX25032025001',
        'image': 'assets/grand.png',
      },
      {
        'movieTitle': 'Deadpool vs Wolverine',
        'date': '25 Mar 2025',
        'time': '20:15',
        'seats': 'F7, F8, F9',
        'cinema': 'CGV Cinemas Grand City',
        'ticketCode': 'TIX25032025002',
        'image': 'assets/grand.png',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body:
          tickets.isEmpty
              ? const Center(
                child: Text(
                  'Anda tidak memiliki tiket',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Ticket(
                      movieTitle: tickets[index]['movieTitle'],
                      date: tickets[index]['date'],
                      time: tickets[index]['time'],
                      seats: tickets[index]['seats'],
                      cinema: tickets[index]['cinema'],
                      ticketCode: tickets[index]['ticketCode'],
                      image: tickets[index]['image'],
                    ),
                  );
                },
              ),
    );
  }
}

class Ticket extends StatelessWidget {
  final String movieTitle;
  final String date;
  final String time;
  final String seats;
  final String cinema;
  final String ticketCode;
  final String image;

  const Ticket({
    Key? key,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.seats,
    required this.cinema,
    required this.ticketCode,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF252525),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner film
          Image.asset(
            image,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          // Informasi tiket
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Informasi waktu dan tempat
                _buildInfoRow(Icons.calendar_today, 'Tanggal', date),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.access_time, 'Jam', time),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.event_seat, 'Kursi', seats),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_on, 'Bioskop', cinema),

                const Divider(color: Colors.grey, height: 24),

                // QR Code placeholder dan kode tiket
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Text(
                          'QR Code',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kode Tiket:',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ticketCode,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
