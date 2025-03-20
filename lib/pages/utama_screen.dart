import 'package:flutter/material.dart';
import 'movie_screen.dart';
import 'upcomming_screen.dart';
import 'tiket_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_navbar.dart'; 

// Halaman Utama
class UtamaScreen extends StatefulWidget {
  const UtamaScreen({Key? key}) : super(key: key);

  @override
  _UtamaScreenState createState() => _UtamaScreenState();
}

class _UtamaScreenState extends State<UtamaScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MovieDetailScreen(),
    const UpcomingScreen(),
    const TicketScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(
          _getScreenTitle(),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Column(
        children: [
          Expanded(child: _pages[_selectedIndex]),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selamat Datang di Halaman Utama!',
              style: const TextStyle(color: Colors.white, fontSize: 20),
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
}