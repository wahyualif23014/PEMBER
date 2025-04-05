import 'package:flutter/material.dart';

class SearchBarApp extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Cari film...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}  
class MovieDetailScreen extends StatelessWidget {
  final String movieTitle;
  final String movieDescription;
  final String movieImage;

  const MovieDetailScreen({
    Key? key,
    this.movieTitle = "Film Contoh",
    this.movieDescription = "Deskripsi film contoh.",
    this.movieImage = "assets/Group39.png", // Ganti dengan gambar film yang sesuai
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movieTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(movieImage, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                movieDescription,
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Logika untuk memesan tiket
                // Misalnya, navigasi ke halaman pemesanan tiket
                Navigator.pushNamed(context, '/booking'); // Ganti dengan rute yang sesuai
              },
              child: Text('Pesan Tiket'),
            ),
          ],
        ),
      ),
    );
  }
}