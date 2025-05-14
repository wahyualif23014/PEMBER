import 'package:absolute_cinema/api_links/all_api.dart';
import 'package:absolute_cinema/widgets/section_header.dart';
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
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response = await http.get(Uri.parse(nowplayingmoviesurl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null) {
          setState(() {
            movies = data['results'];
          });
        }
      } else {
        print("Failed to fetch: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child:
            movies.isEmpty
                ? SkeletonHomeLoader()
                : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: SearchBarApp()),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    const SliverToBoxAdapter(child: SearchLocationBar()),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    SliverToBoxAdapter(
                      child: CarouselSliderWidget(
                        movies: movies.take(6).toList(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 30)),

                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: "Now Showing",
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
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    SliverToBoxAdapter(
                      child: MovieGrid(
                        movies: movies.take(6).toList(),
                        source: "now_showing",
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: "Upcoming",
                        // Removed the undefined parameter
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
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),

                    SliverToBoxAdapter(
                      child: MovieGrid(
                        movies: movies.take(6).toList(),
                        source: "upcoming",
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class SkeletonHomeLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Container(height: 40, color: AppColors.skeletonDark),
                const SizedBox(height: 10),
                Container(height: 30, color: AppColors.skeletonLight),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Container(
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.skeletonDark,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ...List.generate(
          2,
          (index) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 120,
                    color: AppColors.skeletonLight,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(
                      3,
                      (i) => Expanded(
                        child: Container(
                          height: 150,
                          margin: const EdgeInsets.only(right: 8),
                          color: AppColors.skeletonDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
