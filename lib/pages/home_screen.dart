import 'package:flutter/material.dart';
import 'movie_screen.dart';
import 'upcomming_screen.dart';
import 'tiket_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MovieDetailScreen(),
    UpcomingScreen(),
    TicketScreen(),
    ProfileScreen(),
  ];

  String _getScreenTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Now Playing';
      case 1:
        return 'Coming Soon';
      case 2:
        return 'My Tickets';
      case 3:
        return 'Profile';
      default:
        return 'Home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        centerTitle: true,
        title: Text(
          _getScreenTitle(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _pages[_selectedIndex]),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Selamat Datang di Halaman Utama!',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
