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
  List nowPlayingMovies = [];
  List upcomingMovies = [];

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    final movieService = TheMovieDB();
    final nowPlaying = await movieService.fetchNowPlayingMovies();
    final upcoming = await movieService.fetchUpcomingMovies();

    if (!mounted) return;

    if (nowPlaying.isNotEmpty && upcoming.isNotEmpty) {
      setState(() {
        nowPlayingMovies = nowPlaying;
        upcomingMovies = upcoming;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          nowPlayingMovies.isEmpty && upcomingMovies.isEmpty
              ? const SkeletonHomeLoader()
              : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(child: SearchBarApp()),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(child: SearchLocationBar()),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: CarouselSliderWidget(
                      movies: nowPlayingMovies.take(6).toList(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
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
                                    body: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: MovieGrid(
                                        movies: nowPlayingMovies,
                                        source: "now_showing",
                                      ),
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: MovieGrid(
                        movies: nowPlayingMovies.take(6).toList(),
                        source: "now_showing",
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
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
                                    body: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: MovieGrid(
                                        movies: upcomingMovies,
                                        source: "upcoming",
                                      ),
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: MovieGrid(
                        movies: upcomingMovies.take(6).toList(),
                        source: "upcoming",
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
    );
  }
}
