import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;

class EditProfileScreen extends StatefulWidget {
  final String username;
  final String email;
  final String profileImage;
  final void Function(String newUsername, String newEmail, String newAvatarUrl)
  onSave;

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
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _pickedImage;
  bool isSaving = false;
  String? _previousAvatarUrl;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username;
    _emailController.text = widget.email;
    _previousAvatarUrl =
        widget.profileImage.startsWith('http') ? widget.profileImage : null;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadAvatar(String userId) async {
    if (_pickedImage == null) return _previousAvatarUrl;

    final fileExt = p.extension(_pickedImage!.path);
    final fileName =
        '${userId}_${DateTime.now().millisecondsSinceEpoch}$fileExt';
    final filePath = 'avatars/$fileName';

    // Delete old file if exists
    if (_previousAvatarUrl != null) {
      final uri = Uri.parse(_previousAvatarUrl!);
      final oldFileName = uri.pathSegments.last;
      await supabase.storage.from('avatars').remove(['avatars/$oldFileName']);
    }

    final bytes = await _pickedImage!.readAsBytes();
    final res = await supabase.storage
        .from('avatars')
        .uploadBinary(
          filePath,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
    print("Public URL: $publicUrl");

    return publicUrl;
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isSaving = true);

    try {
      final avatarUrl = await _uploadAvatar(user.uid);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'username': _usernameController.text, 'avatarUrl': avatarUrl},
      );

      widget.onSave(
        _usernameController.text,
        _emailController.text,
        avatarUrl ?? widget.profileImage,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to update profile: $e")));
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar =
        _pickedImage != null
            ? FileImage(_pickedImage!)
            : widget.profileImage.startsWith('http')
            ? NetworkImage(widget.profileImage)
            : AssetImage(widget.profileImage);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body:
          isSaving
              ? const Center(
                child: CircularProgressIndicator(color: Colors.amber),
              )
              : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: avatar as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      enabled: false,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white70),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Save Changes"),
                    ),
                  ],
                ),
              ),
    );
  }
}
