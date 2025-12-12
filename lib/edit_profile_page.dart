import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Tambah Import ini
import 'user_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false; // Tambah loading biar kelihatan prosesnya

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: UserService.userName.value);
    _emailController.text = UserService.userEmail; // Email dari User Service
    _passwordController.text = "••••••••••";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await UserService.updateProfileImage(image.path);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto profil berhasil dipilih!")),
      );
    }
  }

  // --- FUNGSI SIMPAN YANG BARU ---
  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String newName = _nameController.text.trim();

      // 1. Simpan ke Memori HP (SharedPrefs)
      await UserService.updateName(newName);

      // 2. Simpan ke Firebase Auth (Server Google)
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        await user.reload(); // Refresh data user
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil berhasil diperbarui!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.check),
            onPressed: _isLoading ? null : _saveProfile,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Stack(
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: UserService.profileImagePath,
                  builder: (context, path, child) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage: path != null ? FileImage(File(path)) : null,
                      child: path == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue[700],
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: _buildInputDecoration(label: "Nama Lengkap"),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _emailController,
            readOnly: true, // Email dikunci
            style: const TextStyle(color: Colors.grey),
            decoration: _buildInputDecoration(label: "Email"),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Untuk keamanan, Email & Password tidak dapat diubah di sini.",
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _passwordController,
            readOnly: true, // Password dikunci
            obscureText: true,
            style: const TextStyle(color: Colors.grey),
            decoration: _buildInputDecoration(label: "Password"),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
    );
  }
}