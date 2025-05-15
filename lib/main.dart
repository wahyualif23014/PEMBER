import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; 
import 'package:absolute_cinema/services/auth_service.dart';
import 'package:absolute_cinema/screens/tab_navigation_screen.dart';
import 'package:absolute_cinema/screens/auth/login_screen.dart';
import 'package:absolute_cinema/screens/auth/register_screen.dart';
import 'package:absolute_cinema/screens/auth/welcome_screen.dart';
import 'package:absolute_cinema/providers/TicketProvider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TicketProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absolute Cinema',
      theme: ThemeData.dark(),
      home: StreamBuilder<User?>(
        stream: authService.value.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.amberAccent),
              ),
            );
          }

          if (snapshot.hasData) {
            return const TabNavigationScreen();
          } else {
            return const WelcomeScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const TabNavigationScreen(),
      },
    );
  }
}
