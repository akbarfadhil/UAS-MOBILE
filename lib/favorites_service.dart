import 'package:flutter/material.dart';

class HadithFavorite {
  final String title;
  final String source;
  final String arabicText;
  final String translation;

  HadithFavorite({
    required this.title,
    required this.source,
    required this.arabicText,
    required this.translation,
  });
}

class FavoritesService {
  // Menggunakan ValueNotifier agar List Page tahu kalau ada update
  static final ValueNotifier<List<HadithFavorite>> favoritesNotifier = ValueNotifier([]);

  static void add(HadithFavorite hadith) {
    // Cek apakah data sudah ada (mencegah duplikat)
    final isExist = favoritesNotifier.value.any((item) => item.title == hadith.title);
    
    if (!isExist) {
      // Buat list baru agar UI ter-update
      final newList = List<HadithFavorite>.from(favoritesNotifier.value);
      newList.add(hadith);
      favoritesNotifier.value = newList;
    }
  }

  static void remove(HadithFavorite hadith) {
    final newList = List<HadithFavorite>.from(favoritesNotifier.value);
    newList.removeWhere((item) => item.title == hadith.title);
    favoritesNotifier.value = newList;
  }
}