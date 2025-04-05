import 'package:absolute_cinema/themes/warna.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String email;
  final String profileImage;

  const ProfileScreen({
    super.key,
    this.username = " Dewa saja",
    this.email = "sadewa@example.com",
    this.profileImage = "assets/mupy.jpg",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header profil dengan foto dan nama
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF252525),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Foto profil
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(profileImage),
                  ),
                  const SizedBox(height: 16),

                  // Nama pengguna
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(
                    email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Edit Profil
                  ElevatedButton(
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
                    onPressed: () {
                      // Logika untuk mengedit profil
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edit profil akan segera tersedia'),
                        ),
                      );
                    },
                    child: const Text('Edit Profil'),
                  ),
                ],
              ),
            ),

            // Menu item
            const SizedBox(height: 20),
            _buildMenuItem(
              context,
              icon: Icons.history,
              title: 'Riwayat Pembelian',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Riwayat Pembelian akan segera tersedia'),
                  ),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.favorite,
              title: 'Film Favorit',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Film Favorit akan segera tersedia'),
                  ),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.card_giftcard,
              title: 'Reward Point',
              subtitle: '240 points',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reward Point akan segera tersedia'),
                  ),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.settings,
              title: 'Pengaturan',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengaturan akan segera tersedia'),
                  ),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: 'Bantuan',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bantuan akan segera tersedia')),
                );
              },
            ),

            const SizedBox(height: 20),

            // Tombol logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Logika untuk logout
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
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
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
                child: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 20),

            // Versi aplikasi
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

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: const Color(0xFF252525),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: Colors.amberAccent),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          subtitle:
              subtitle != null
                  ? Text(subtitle, style: const TextStyle(color: Colors.grey))
                  : null,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
