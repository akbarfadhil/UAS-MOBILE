import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import paket penyimpanan

class UserService {
  // Data user (Reaktif, UI akan berubah otomatis kalau ini berubah)
  static ValueNotifier<String> userName = ValueNotifier("Akbar");
  static String userEmail = "Loading..."; // Nanti diisi otomatis dari Firebase/Prefs
  static ValueNotifier<String?> profileImagePath = ValueNotifier(null);

  // Fungsi untuk memuat data dari memori HP saat aplikasi dibuka
  static Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Ambil Nama (kalau gak ada, pakai default 'Akbar')
    String? savedName = prefs.getString('saved_name');
    if (savedName != null) {
      userName.value = savedName;
    }

    // 2. Ambil Foto (kalau gak ada, null)
    String? savedImage = prefs.getString('saved_image');
    if (savedImage != null) {
      profileImagePath.value = savedImage;
    }
  }

  // Fungsi update Nama (Simpan ke Memori)
  static Future<void> updateName(String newName) async {
    userName.value = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_name', newName); // Simpan permanen
  }
  
  // Fungsi update Foto (Simpan ke Memori)
  static Future<void> updateProfileImage(String path) async {
    profileImagePath.value = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_image', path); // Simpan permanen
  }

  // Fungsi Reset (Opsional: misal pas Logout)
  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_image'); 
    // Nama jangan dihapus biar pas login lagi namanya masih ingat
  }
}