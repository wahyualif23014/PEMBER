import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:absolute_cinema/screens/edit_profile_screen.dart';
import 'package:absolute_cinema/themes/colors.dart';
import 'package:absolute_cinema/widgets/profile_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? email;
  String profileImage = "assets/mupy.jpg"; // default fallback

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final uid = user.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        username = userDoc.data()?['username'] ?? "Unknown User";
        email = user.email ?? "No Email";
        isLoading = false;
      });
    } catch (e) {
      print("Error loading profile: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditProfileScreen(
              username: username ?? '',
              email: email ?? '',
              profileImage: profileImage,
              onSave: (newUsername, newEmail, newImagePath) {
                setState(() {
                  username = newUsername;
                  email = newEmail;
                  profileImage = newImagePath;
                });
              },
            ),
      ),
    );
  }

  ImageProvider _getImageProvider(String path) {
    try {
      if (path.startsWith('assets')) {
        return AssetImage(path);
      } else {
        final file = File(path);
        return file.existsSync()
            ? FileImage(file)
            : const AssetImage("assets/mupy.jpg");
      }
    } catch (_) {
      return const AssetImage("assets/mupy.jpg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.amberAccent),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header profil
                    Container(
                      padding: const EdgeInsets.only(
                        top: 30,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF252525),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: _getImageProvider(profileImage),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            username ?? "Loading...",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            email ?? "Loading...",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _navigateToEditProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    ProfileMenuItem(
                      icon: Icons.history,
                      title: 'Purchase History',
                      onTap:
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Riwayat Pembelian akan segera tersedia',
                              ),
                            ),
                          ),
                    ),
                    ProfileMenuItem(
                      icon: Icons.settings,
                      title: 'Setting',
                      onTap:
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pengaturan akan segera tersedia'),
                            ),
                          ),
                    ),
                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Support',
                      onTap:
                          () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bantuan akan segera tersedia'),
                            ),
                          ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  backgroundColor: const Color(0xFF252525),
                                  title: const Text(
                                    'Logout',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    'Apakah Anda yakin ingin keluar?',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Batal',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/login',
                                        );
                                      },
                                      child: const Text(
                                        'Logout',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Logout'),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      'Versi 1.0.0',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}
