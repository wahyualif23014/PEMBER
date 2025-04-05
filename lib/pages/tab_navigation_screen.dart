import 'package:absolute_cinema/themes/warna.dart';
import 'package:flutter/material.dart';
import 'package:absolute_cinema/pages/movie_screen.dart';
import 'package:absolute_cinema/pages/upcomming_screen.dart';
import 'package:absolute_cinema/pages/tiket_screen.dart';
import 'package:absolute_cinema/pages/profile_screen.dart';
import '../widgets/custom_navbar.dart';

class TabNavigationScreen extends StatefulWidget {
  const TabNavigationScreen({super.key});

  @override
  State<TabNavigationScreen> createState() => _TabNavigationScreenState();
}

class _TabNavigationScreenState extends State<TabNavigationScreen> {
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _getScreenTitle(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _pages[_selectedIndex],
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
