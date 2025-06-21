import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui'; 

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  String _language = 'Indonesia';

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _darkMode);
    await prefs.setString('language', _language);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('dark_mode') ?? true;
      _language = prefs.getString('language') ?? 'Indonesia';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Efek Blur Latar Belakang
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withOpacity(0.6),
                ),
              ),
            ),
          ),

          // Konten Pengaturan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Profil
                const Text(
                  "Others",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // 🔤 Pilih Bahasa
                Card(
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.language, color: Colors.amber),
                    title: const Text(
                      "Bahasa",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _language,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      _showLanguageDialog(context);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.dark_mode, color: Colors.amber),
                    title: const Text(
                      "Dark Mode",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Switch(
                      value: _darkMode,
                      activeColor: Colors.amber,
                      onChanged: (value) {
                        setState(() {
                          _darkMode = value;
                        });
                        _saveSettings();
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 📝 Info
                const Text(
                  "change settings for applications.",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Pilih Bahasa",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("Indonesia", style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    _language = 'Indonesia';
                  });
                  Navigator.pop(context);
                  _saveSettings();
                },
              ),
              ListTile(
                title: const Text("English", style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    _language = 'English';
                  });
                  Navigator.pop(context);
                  _saveSettings();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}