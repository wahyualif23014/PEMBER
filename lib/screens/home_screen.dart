import 'package:flutter/material.dart';
import 'package:absolute_cinema/services/themoviedb_service.dart';
import 'package:absolute_cinema/widgets/home_skeleton_loader.dart';
import 'package:absolute_cinema/widgets/section_header.dart';
import 'package:absolute_cinema/widgets/search_bar.dart';
import 'package:absolute_cinema/widgets/search_location_bar.dart';
import 'package:absolute_cinema/widgets/carousel_slider.dart';
import 'package:absolute_cinema/widgets/movie_grid.dart';

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
    loadMovies();
  }

  Future<void> loadMovies() async {
    final movieService = TheMovieDB();
    final fetchedMovies = await movieService.fetchMovies();

    setState(() {
      movies = fetchedMovies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          movies.isEmpty
              ? const SkeletonHomeLoader()
              : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Padding atas
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Search Bar
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(child: SearchBarApp()),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Location Bar
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(child: SearchLocationBar()),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Carousel Slider (no padding)
                  SliverToBoxAdapter(
                    child: CarouselSliderWidget(
                      movies: movies.take(6).toList(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 30)),

                  // Now Showing Header
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
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
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Now Showing Grid
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: MovieGrid(
                        movies: movies.take(6).toList(),
                        source: "now_showing",
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Upcoming Header
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: SectionHeader(
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
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Upcoming Grid
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: MovieGrid(
                        movies: movies.take(6).toList(),
                        source: "upcoming",
                      ),
                    ),
                  ),

                  // Padding bawah
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
    );
  }
}
