import 'package:flutter/material.dart';

class MovieModel {
  final String title;
  final String image;
  final String rating;

  MovieModel({required this.title, required this.image, required this.rating});
}

class UpcomingTabbarContent extends StatefulWidget {
  const UpcomingTabbarContent({super.key});

  @override
  State<UpcomingTabbarContent> createState() => _UpcomingTabbarContentState();
}

class _UpcomingTabbarContentState extends State<UpcomingTabbarContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<MovieModel> nowShowingMovies = [
    MovieModel(
      title: "Naruto The Last",
      image: "assets/naruto.png",
      rating: "9.2",
    ),
    MovieModel(title: "Demon Slayer", image: "assets/demon.png", rating: "9.0"),
    MovieModel(
      title: "Jujutsu Kaisen",
      image: "assets/jujutsu.png",
      rating: "9.1",
    ),
    MovieModel(title: "Demon Slayer", image: "assets/demon.png", rating: "9.0"),
    MovieModel(
      title: "Jujutsu Kaisen",
      image: "assets/jujutsu.png",
      rating: "9.1",
    ),
    MovieModel(title: "Demon Slayer", image: "assets/demon.png", rating: "9.0"),
    MovieModel(
      title: "Jujutsu Kaisen",
      image: "assets/jujutsu.png",
      rating: "9.1",
    ),
    MovieModel(title: "Demon Slayer", image: "assets/demon.png", rating: "9.0"),
    MovieModel(
      title: "Jujutsu Kaisen",
      image: "assets/jujutsu.png",
      rating: "9.1",
    ),
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
          // Tab bar
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        itemCount: nowShowingMovies.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.7, 
                            ),
                        itemBuilder: (context, index) {
                          final movie = nowShowingMovies[index];
                          return MovieCard(movie: movie);
                        },
                      ),
                    );
                  },
                ),

                const Center(
                  child: Text(
                    "Belum ada film upcoming...",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final MovieModel movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(movie.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          movie.title,
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "Rate ${movie.rating}",
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
