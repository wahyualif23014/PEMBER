import 'package:flutter/material.dart';
import 'package:absolute_cinema/screens/movie_grid.dart';

class UpcomingTabbarContent extends StatefulWidget {
  const UpcomingTabbarContent({super.key});

  @override
  State<UpcomingTabbarContent> createState() => _UpcomingTabbarContentState();
}

class _UpcomingTabbarContentState extends State<UpcomingTabbarContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> nowShowingMovies = [
    {
      'title': 'Jujutsu Kaisen',
      'poster_path': '/1E5baAaEse26fej7uHcjOgEE2t2.jpg',
    },
    {
      'title': 'One Piece Film Red',
      'poster_path': '/nLBRD7UPR6GjmWQp6ASAfCTaWKX.jpg',
    },
    {
      'title': 'Bleach: Thousand-Year Blood War',
      'poster_path': '/1f3qspv64L5FXrRy0MF8X92ieuw.jpg',
    },
  ];

  final List<Map<String, dynamic>> upcomingMovies = [
    {
      'title': 'Chainsaw Man',
      'poster_path': '/npdB6eFzizki0WaZ1OvKcJrWe97.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.yellow, width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.yellow,
              indicatorWeight: 3,
              labelColor: Colors.yellow,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [Tab(text: 'Now Showing'), Tab(text: 'Upcoming')],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: MovieGrid(
                    movies: nowShowingMovies,
                    source: 'now_showing',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: MovieGrid(movies: upcomingMovies, source: 'upcoming'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
