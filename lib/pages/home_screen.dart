import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:absolute_cinema/themes/warna.dart';
import 'package:absolute_cinema/widgets/search_bar.dart';
import 'package:absolute_cinema/widgets/search_location_bar.dart';
import 'package:absolute_cinema/widgets/header.dart';
import 'package:absolute_cinema/widgets/carousel_slider.dart';
import 'package:absolute_cinema/pages/movie_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];
  final String apiKey = '08c65abc73be4c1cc0e0e39cd1b19141';

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movies = data['results'];
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child:
            movies.isEmpty
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const SearchBarApp(),
                        const SizedBox(height: 10),
                        const SearchLocationBar(),
                        const SizedBox(height: 20),

                        CarouselSliderWidget(movies: movies.take(5).toList()),
                        const SizedBox(height: 20),

                        const SectionHeader(title: "Now Showing"),
                        const SizedBox(height: 10),
                        MovieGrid(movies: movies.take(6).toList()),

                        const SizedBox(height: 20),

                        const SectionHeader(title: "Upcoming"),
                        const SizedBox(height: 10),
                        MovieGrid(movies: movies.skip(6).take(6).toList()),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
