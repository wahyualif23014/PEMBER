import 'package:absolute_cinema/pages/tab_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:absolute_cinema/pages/auth/login_screen.dart';
import 'package:absolute_cinema/pages/auth/register_screen.dart';
import "package:absolute_cinema/pages/auth/welcome_screen.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absolute Cinema',
      theme: ThemeData.dark(),
      initialRoute: '/home',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const TabNavigationScreen(),
      },
    );
  }
}
