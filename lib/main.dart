import 'package:absolute_cinema/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:absolute_cinema/screens/login_screen.dart';
import 'package:absolute_cinema/screens/register_screen.dart';
import "package:absolute_cinema/screens/welcome_screen.dart";

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
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
