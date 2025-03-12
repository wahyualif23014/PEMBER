import 'package:flutter/material.dart';
import 'pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

// Test

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absolute Cinema',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
