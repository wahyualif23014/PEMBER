import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:absolute_cinema/models/user_model.dart';
import 'package:absolute_cinema/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _usernameKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _confirmKey = GlobalKey<FormFieldState>();

  String? _firebaseEmailError;
  String? _firebasePasswordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username cannot be empty';
    if (value.length < 3) return 'Username must be at least 3 characters';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Invalid email format';
    }
    return _firebaseEmailError;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return _firebasePasswordError;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password cannot be empty';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _submitForm() async {
    setState(() {
      _firebaseEmailError = null;
      _firebasePasswordError = null;
    });

    if (_formKey.currentState!.validate()) {
      try {
        final userModel = UserModel(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        await authService.value.signUpWithModel(userModel);

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'email-already-in-use') {
            _firebaseEmailError = 'Email is already in use';
          } else if (e.code == 'invalid-email') {
            _firebaseEmailError = 'Invalid email format';
          } else if (e.code == 'weak-password') {
            _firebasePasswordError = 'Password is too weak';
          }
        });

        // Re-validate to show updated firebase error
        _formKey.currentState!.validate();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
      }
    }
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon, {
    bool isPassword = false,
    bool obscure = true,
    VoidCallback? toggle,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.amberAccent),
      hintText: hint,
      hintStyle: const TextStyle(color: Color.fromARGB(137, 216, 216, 216)),
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.amberAccent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
      suffixIcon:
          isPassword
              ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.amberAccent,
                ),
                onPressed: toggle,
              )
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amberAccent),
          onPressed:
              () =>
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset('assets/newlogo.png', height: 100),
              const SizedBox(height: 30),

              TextFormField(
                key: _usernameKey,
                controller: _usernameController,
                validator: _validateUsername,
                onChanged: (_) => _usernameKey.currentState?.validate(),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Username', Icons.person),
              ),
              const SizedBox(height: 20),

              TextFormField(
                key: _emailKey,
                controller: _emailController,
                validator: _validateEmail,
                onChanged: (_) {
                  _firebaseEmailError = null;
                  _emailKey.currentState?.validate();
                },
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Email', Icons.email),
              ),
              const SizedBox(height: 20),

              TextFormField(
                key: _passwordKey,
                controller: _passwordController,
                validator: _validatePassword,
                onChanged: (_) {
                  _firebasePasswordError = null;
                  _passwordKey.currentState?.validate();
                },
                obscureText: obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  'Password',
                  Icons.lock,
                  isPassword: true,
                  obscure: obscurePassword,
                  toggle:
                      () => setState(() => obscurePassword = !obscurePassword),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                key: _confirmKey,
                controller: _confirmPasswordController,
                validator: _validateConfirmPassword,
                onChanged: (_) => _confirmKey.currentState?.validate(),
                obscureText: obscureConfirmPassword,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  'Confirm Password',
                  Icons.lock,
                  isPassword: true,
                  obscure: obscureConfirmPassword,
                  toggle:
                      () => setState(
                        () => obscureConfirmPassword = !obscureConfirmPassword,
                      ),
                ),
              ),
              const SizedBox(height: 35),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              const SizedBox(height: 25),

              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'Log In',
                        style: TextStyle(color: Colors.amberAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
