import 'package:absolute_cinema/themes/warna.dart';
import 'package:flutter/material.dart';

class UpcomingScreen extends StatelessWidget {
  final String upcomingTitle;
  final String upcomingDescription;
  final String upcomingImage;
  final String releaseDate;

  const UpcomingScreen({
    super.key,
    this.upcomingTitle = "Up Comming Film",
    this.upcomingDescription = "Film baru yang akan segera tayang di bioskop.",
    this.upcomingImage = "assets/Group39.png",
    this.releaseDate = "Akan tayang pada 1 April 2025",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner film
            Container(
              height: 250,
              width: double.infinity,
              child: Image.asset(upcomingImage, fit: BoxFit.cover),
            ),

            // Judul film
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                upcomingTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Tanggal rilis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                releaseDate,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Deskripsi film
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                upcomingDescription,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),

            // Tombol untuk notifikasi
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Logika untuk mengatur notifikasi ketika film tayang
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Anda akan mendapatkan notifikasi saat film ini tayang',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text(
                    'Ingatkan Saya',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
