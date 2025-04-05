import 'package:coba/pages/home_screen.dart';
import 'package:coba/pages/login_screen.dart';
import 'package:coba/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'pages/welcome_screen.dart';

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
