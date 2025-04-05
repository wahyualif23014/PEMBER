import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/BG1.png', fit: BoxFit.cover),
          ),
          // Overlay Blur Effect
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: .6)),
          ),
          // Content Layout
          Column(
            children: [
              const Spacer(), // Memberi ruang kosong di atas
              // Logo
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/newlogo.png', height: 100),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              const Spacer(), // Membantu meletakkan tombol di bawah
              // Button Section
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 100.0,
                ), // Menyesuaikan dengan desain
                child: Column(
                  children: [
                    _buildButton(
                      context,
                      'Sign In',
                      Colors.white,
                      Colors.black,
                      const RegisterScreen(),
                    ),
                    const SizedBox(height: 15),
                    _buildButton(
                      context,
                      'Log In',
                      Colors.amberAccent,
                      Colors.black,
                      const LoginScreen(),
                    ),
                    const SizedBox(height: 15),
                    _buildButton(
                      context,
                      'Google Account',
                      Colors.white,
                      Colors.black,
                      null,
                      icon: Icons.account_circle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // test

  Widget _buildButton(
    BuildContext context,
    String text,
    Color bgColor,
    Color textColor,
    Widget? page, {
    IconData? icon,
  }) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed:
            page != null
                ? () {
                  Navigator.pushReplacementNamed(
                    context,
                    text == 'Sign In' ? '/register' : '/login',
                  );
                }
                : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: textColor),
            if (icon != null) const SizedBox(width: 10),
            Text(text, style: TextStyle(color: textColor, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
