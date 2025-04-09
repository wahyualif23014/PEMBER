import 'package:flutter/material.dart';
import '../themes/warna.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor: Colors.black,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        selectedFontSize: 14,
        unselectedItemColor: Colors.black54,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30, color: Colors.amber),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.movie_creation_outlined,
              color: Colors.amber,
              size: 30,
            ),
            label: "Movies",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.confirmation_num_outlined,
              color: Colors.amber,
              size: 30,
            ),
            label: "Tickets",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Colors.amberAccent,
              size: 30,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
