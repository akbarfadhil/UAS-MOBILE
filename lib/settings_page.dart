import 'dart:io';
import 'package:flutter/material.dart';
import 'user_service.dart';
import 'edit_profile_page.dart';
import 'settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _bottomNavIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/list');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    "Pengaturan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 1. Kartu Profil
                  _buildProfileCard(),
                  
                  const SizedBox(height: 20),
                  
                  // 2. Kartu Ukuran Teks
                  _buildTextSizeCard(),
                  
                  const SizedBox(height: 20),
                  
                  // 3. Kartu Versi Aplikasi (Sederhana & Tengah)
                  _buildVersionCard(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder<String>(
            valueListenable: UserService.userName,
            builder: (context, name, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Assalamu'alaikum", style: TextStyle(color: Colors.white70, fontSize: 16.0)),
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 28.0, fontWeight: FontWeight.bold)),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 28),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi"),
                    content: const Text("Yakin ingin keluar aplikasi?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                        },
                        child: const Text("Ya, Keluar", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return _buildSettingsCard(
      title: "Profil pengguna",
      child: Column(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: UserService.userName,
            builder: (context, name, child) {
              return Row(
                children: [
                  ValueListenableBuilder<String?>(
                    valueListenable: UserService.profileImagePath,
                    builder: (context, path, child) {
                      return CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey,
                        backgroundImage: path != null ? FileImage(File(path)) : null,
                        child: path == null ? const Icon(Icons.person, color: Colors.white) : null,
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInfoField(name)),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _buildInfoField(UserService.userEmail),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
              child: const Text("Edit profile", style: TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextSizeCard() {
    return ValueListenableBuilder<double>(
      valueListenable: SettingsService.textScaleFactor,
      builder: (context, currentScale, child) {
        return _buildSettingsCard(
          title: "Ukuran teks",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTextSizeButton("Kecil", 0.8, currentScale),
              _buildTextSizeButton("Sedang", 1.0, currentScale),
              _buildTextSizeButton("Besar", 1.2, currentScale),
            ],
          ),
        );
      },
    );
  }

  // --- BAGIAN INI YANG DISEDERHANAKAN ---
  Widget _buildVersionCard() {
    return _buildSettingsCard(
      title: "Tentang Aplikasi",
      child: Container(
        width: double.infinity, // Agar bisa di-center
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Rata Tengah
          children: [
            const Icon(Icons.info_outline, color: Colors.white54, size: 40),
            const SizedBox(height: 10),
            const Text(
              "Versi Aplikasi",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "1.0.0 (Beta)",
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
  // --------------------------------------

  Widget _buildTextSizeButton(String label, double scale, double currentScale) {
    bool isSelected = currentScale == scale;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            SettingsService.updateTextScale(scale);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blue[700] : Colors.white.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            elevation: 0,
          ),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoField(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
      ],
      currentIndex: _bottomNavIndex,
      onTap: _onItemTapped,
      backgroundColor: Colors.blue[900],
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      selectedIconTheme: const IconThemeData(size: 30),
      unselectedIconTheme: const IconThemeData(size: 24),
    );
  }
}