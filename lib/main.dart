import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:absolute_cinema/services/auth_service.dart';
import 'package:absolute_cinema/screens/tab_navigation_screen.dart';
import 'package:absolute_cinema/screens/auth/login_screen.dart';
import 'package:absolute_cinema/screens/auth/register_screen.dart';
import 'package:absolute_cinema/screens/auth/welcome_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
            Future.microtask(() {
              if (Get.currentRoute != '/home') {
                Get.offAllNamed('/home');
              }
            });
            return const SizedBox();
          } else {
            print("👋 Not authenticated");
            return const WelcomeScreen();
          }
        },
      ),
      initialRoute: '/TabNavigationScreen',
      getPages: [
        GetPage(name: '/', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/home', page: () => const TabNavigationScreen()),
      ],
    );
  }
}
