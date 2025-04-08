import 'package:flutter/material.dart';
import 'package:absolute_cinema/themes/warna.dart';
import 'package:absolute_cinema/pages/movie_screen.dart';
import 'package:absolute_cinema/pages/upcomming_screen.dart';
import 'package:absolute_cinema/pages/tiket_screen.dart';
import 'package:absolute_cinema/pages/profile_screen.dart';
import '../widgets/custom_navbar.dart';
import '../widgets/location_bar.dart';
import '../widgets/carousel_slider.dart';
import '../widgets/movie_section.dart'; 
import '../pages/movie_screen.dart';

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

  // List halaman selain home (index 0 akan dihandle manual di bawah)
  final List<Widget> _pages = const [
    SizedBox.shrink(), // Placeholder untuk index 0 (home), tidak digunakan
    UpcomingScreen(),
    TicketScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 0) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const SearchLocationBar(location: 'Surabaya'),
                const SizedBox(height: 16),
                const CarouselSliderWidget(),
                const SizedBox(height: 16),
                MovieSection(
                  title: 'Now Showing',
                  onSeeAllPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MovieScreen(showFullList: true),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                MovieSection(
                  title: 'Upcoming',
                  onSeeAllPressed: () {
                    setState(() {
                      _selectedIndex = 1; // Switch to Upcoming tab
                    });
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
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
    } else {
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
}