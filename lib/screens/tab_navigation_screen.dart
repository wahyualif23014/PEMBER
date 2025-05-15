import 'package:absolute_cinema/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:absolute_cinema/themes/colors.dart';
import 'package:absolute_cinema/screens/tiket_screen.dart';
import 'package:absolute_cinema/screens/profile_screen.dart';
import '../widgets/custom_navbar.dart';

class TabNavigationScreen extends StatefulWidget {
  const TabNavigationScreen({super.key});

  @override
  State<TabNavigationScreen> createState() => _TabNavigationScreenState();
}

class _TabNavigationScreenState extends State<TabNavigationScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = ['', 'Coming Soon', 'My Tickets', 'Profile'];

  final List<Widget> _pages = const [
    HomeScreen(),
    TicketScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:
          _selectedIndex != 0
              ? AppBar(
                automaticallyImplyLeading: true,
                title: Text(
                  _titles[_selectedIndex],
                  style: const TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: AppColors.background,
              )
              : null,
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
