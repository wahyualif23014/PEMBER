import 'package:absolute_cinema/api_links/all_api.dart';
import 'package:absolute_cinema/widgets/section_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:absolute_cinema/themes/colors.dart';
import 'package:absolute_cinema/widgets/search_bar.dart';
import 'package:absolute_cinema/widgets/search_location_bar.dart';
import 'package:absolute_cinema/widgets/carousel_slider.dart';
import 'package:absolute_cinema/screens/movie_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  List movies = [];

  Future<void> fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User belum login");
      return;
    }
    final uid = user.uid;
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          username = userDoc['username'];
        });
      } else {
        print("Dokumen user tidak ditemukan.");
      }
    } catch (e) {
      print("Terjadi error saat mengambil username: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
    fetchUsername();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse(nowplayingmoviesurl));

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

                        CarouselSliderWidget(movies: movies.take(6).toList()),
                        const SizedBox(height: 30),

                        SectionHeader(
                          title: "$username",
                          onSeeAll: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => Scaffold(
                                      backgroundColor: Colors.black,
                                      appBar: AppBar(
                                        title: const Text("Now Showing"),
                                      ),
                                      body: MovieGrid(
                                        movies: movies,
                                        source: "now_showing",
                                      ),
                                    ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 410,
                          child: MovieGrid(
                            movies: movies.take(6).toList(),
                            source: "now_showing",
                          ),
                        ),

                        const SizedBox(height: 20),

                        SectionHeader(
                          title: "Upcoming",
                          onSeeAll: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => Scaffold(
                                      backgroundColor: Colors.black,
                                      appBar: AppBar(
                                        title: const Text("Upcoming"),
                                      ),
                                      body: MovieGrid(
                                        movies: movies,
                                        source: "upcoming",
                                      ),
                                    ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 410,
                          child: MovieGrid(
                            movies: movies.take(6).toList(),
                            source: "upcoming",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
