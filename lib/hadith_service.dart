import 'dart:convert';
import 'package:http/http.dart' as http;

class HadithService {
  // Base URL API
  static const String _baseUrl = 'https://api.hadith.gading.dev/books';

  static Future<List<Map<String, dynamic>>> getHadiths() async {
    try {
      // --- PERUBAHAN ADA DI BARIS INI ---
      print("Mencoba mengambil data dari $_baseUrl/bukhari?range=1-50");
      
      // Mengambil hadis riwayat Bukhari nomor 1 sampai 50
      final response = await http.get(Uri.parse('$_baseUrl/bukhari?range=1-50'));

      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Cek struktur data
        if (jsonResponse['data'] == null) {
          throw Exception("Data API kosong (null)");
        }

        final List<dynamic> hadithsData = jsonResponse['data']['hadiths'];

        return hadithsData.map((data) {
          return {
            "title": "Hadits No. ${data['number']}",
            "source": "HR. BUKHARI",
            "snippet": data['id'] ?? "Tidak ada terjemahan",
            "arabic": data['arab'] ?? "",
            "translation": data['id'] ?? "Tidak ada terjemahan",
          };
        }).toList();
      } else {
        throw Exception('Gagal memuat. Kode: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching hadiths: $e");
      // KITA LEMPAR ERRORNYA KE UI AGAR BISA DIBACA
      throw Exception("Detail Error: $e");
    }
  }
}
