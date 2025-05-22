import 'package:flutter/material.dart';
import '../widgets/feedback_form.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.black;
    final Color cardColor = const Color(0xFF1C1C1E); // iOS-style dark card
    final Color accentColor = Colors.amber[700]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Feedback Location'),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Gambar Lokasi
          GestureDetector(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: cardColor,
                  title: const Text("Simpan Gambar", style: TextStyle(color: Colors.white)),
                  content: const Text(
                    "Fitur simpan gambar ke galeri akan segera tersedia.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Tutup", style: TextStyle(color: accentColor)),
                    ),
                  ],
                ),
              );
            },
            child: Hero(
              tag: 'locationImage',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Image.network(
                    'https://picsum.photos/400/200',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Lokasi
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on, color: Colors.amber),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pantai Batu Bolong, Bali',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Title Feedback
          const Text(
            "give your feedback",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Form Feedback
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const FeedbackForm(),
          ),

          const SizedBox(height: 100), // Supaya tidak tertutup FAB
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Feedback berhasil dikirim!")),
          );
        },
        icon: const Icon(Icons.send),
        label: const Text("Send"),
        backgroundColor: accentColor,
      ),
    );
  }
}
