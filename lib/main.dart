import 'package:absolute_cinema/repository/user_repository/user_repository.dart';
import 'package:absolute_cinema/screens/tab_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:absolute_cinema/screens/auth/login_screen.dart';
import 'package:absolute_cinema/screens/auth/register_screen.dart';
import "package:absolute_cinema/screens/auth/welcome_screen.dart";
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(UserRepository());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
