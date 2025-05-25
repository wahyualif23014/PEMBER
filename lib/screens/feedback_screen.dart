import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/feedback_form.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final Color backgroundColor = Colors.black;
  final Color cardColor = const Color(0xFF1C1C1E);
  final Color accentColor = Colors.amber[700]!;

  final List<File> _images = [];

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Gambar Lokasi Utama
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://picsum.photos/400/200',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // Carousel Gambar yang Diunggah
          if (_images.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 180,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
              items: _images.map((file) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }).toList(),
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

          // Judul
          const Text(
            "give your feedback",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Form
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const FeedbackForm(),
          ),
          const SizedBox(height: 120), // agar tidak tertutup tombol
        ],
      ),

      // Floating Button
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'uploadBtn',
                  onPressed: _pickImages,
                  icon: const Icon(Icons.image),
                  label: const Text("Upload"),
                  backgroundColor: cardColor,
                  foregroundColor: accentColor,
                ),
                const SizedBox(height: 12),
                FloatingActionButton.extended(
                  heroTag: 'sendBtn',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Feedback berhasil dikirim!")),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("Send"),
                  backgroundColor: accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
