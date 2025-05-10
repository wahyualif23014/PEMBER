import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:absolute_cinema/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String username;
  final String email;
  final String profileImage; // bisa path lokal atau base64
  final Function(String, String, String) onSave;

  const EditProfileScreen({
    super.key,
    required this.username,
    required this.email,
    required this.profileImage,
    required this.onSave,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late String _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
    _profileImage = widget.profileImage;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.amberAccent,
                ),
                title: const Text(
                  'Ambil dari Kamera',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    final bytes = await File(pickedFile.path).readAsBytes();
                    final base64String = base64Encode(bytes);
                    setState(() {
                      _profileImage = base64String;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Colors.amberAccent,
                ),
                title: const Text(
                  'Pilih dari Galeri',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    final bytes = await File(pickedFile.path).readAsBytes();
                    final base64String = base64Encode(bytes);
                    setState(() {
                      _profileImage = base64String;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    try {
      await authService.value.updateProfile(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        profileImageBase64: _profileImage,
      );

      widget.onSave(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _profileImage,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memperbarui profil: $e")));
    }
  }

  ImageProvider _getImageProvider() {
    try {
      final bytes = base64Decode(_profileImage);
      return MemoryImage(bytes);
    } catch (_) {
      return const AssetImage('assets/mupy.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _getImageProvider(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
