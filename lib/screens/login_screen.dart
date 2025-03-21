import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../pages/utama_screen.dart'; // Import langsung dari file yang sama level
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 88),
              Image.asset('assets/newlogo.png', height: 100),
              const SizedBox(height: 60),
              // Username
              const CustomTextField(icon: Icons.person, hintText: 'Email'),
              const SizedBox(height: 15),
              // Password
              const CustomTextField(icon: Icons.lock, hintText: 'PASSWORD', isPassword: true),
              const SizedBox(height: 15),
              // Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  // Navigasi ke halaman Home setelah login
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UtamaScreen()),
                  );
                },
                child: const Text('Log In', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 10),
              // Sign Up Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(text: 'Don\'t have an account? ', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                      TextSpan(text: 'Sign Up', style: TextStyle(color: Colors.yellow)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom), // Menyesuaikan dengan keyboard
            ],
          ),
        ),
      ),
    );
  }
}