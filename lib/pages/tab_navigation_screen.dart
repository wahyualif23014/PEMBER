import 'package:absolute_cinema/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:absolute_cinema/themes/warna.dart';
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

  // Judul untuk AppBar di tiap tab selain home
  final List<String> _titles = [
    'Now Playing',
    'Coming Soon',
    'My Tickets',
    'Profile',
  ];

  final List<Widget> _pages = const [
    HomeScreen(), 
    UpcomingScreen(),
    TicketScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
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
