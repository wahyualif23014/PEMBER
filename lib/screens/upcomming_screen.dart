import 'package:absolute_cinema/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

class UpcomingTabbarContent extends StatefulWidget {
  const UpcomingTabbarContent({super.key});

  @override
  State<UpcomingTabbarContent> createState() => _UpcomingTabbarContentState();
}

class _UpcomingTabbarContentState extends State<UpcomingTabbarContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Movie> allMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final movies = await MovieService.fetchMovies();
    setState(() {
      allMovies = movies;
      isLoading = false;
    });
  }

  void _showAddMovieDialog() {
    final titleController = TextEditingController();
    final posterController = TextEditingController();
    final ratingController = TextEditingController();
    String status = 'now';

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Add Movie'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: posterController,
                    decoration: const InputDecoration(labelText: 'Poster Path'),
                  ),
                  TextField(
                    controller: ratingController,
                    decoration: const InputDecoration(labelText: 'Rating'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButtonFormField<String>(
                    value: status,  
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(
                        value: 'now',
                        child: Text('Now Showing'),
                      ),
                      DropdownMenuItem(
                        value: 'upcoming',
                        child: Text('Upcoming'),
                      ),
                    ],
                    onChanged: (val) => status = val!,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final movie = Movie(
                    id: '', // ID akan di-generate oleh Firebase
                    title: titleController.text,
                    posterPath: posterController.text,
                    rating: double.tryParse(ratingController.text) ?? 0,
                    status: status,
                  );
                  await MovieService.addMovie(movie);
                  Navigator.of(ctx).pop();
                  _loadData(); // refresh list
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nowMovies = allMovies.where((m) => m.status == 'now').toList();
    final upcomingMovies =
        allMovies.where((m) => m.status == 'upcoming').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddMovieDialog,
          child: const Icon(Icons.add),
        ),
        body: Column(
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
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : TabBarView(
                        controller: _tabController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: MovieCard(
                              movies: nowMovies,
                              onDeleteSuccess: _loadData,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: MovieCard(
                              movies: upcomingMovies,
                              onDeleteSuccess: _loadData,
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
