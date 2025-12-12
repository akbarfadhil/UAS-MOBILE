# 🌟 Hadist Digital (UAS Projek)

Aplikasi mobile berbasis Flutter untuk memudahkan akses hadits harian, dilengkapi fitur autentikasi (Login/Register) menggunakan Firebase Authentication, manajemen profil, pengaturan ukuran teks, dan daftar favorit yang tersimpan secara lokal.

## 🚀 Fitur Utama Aplikasi

* **Autentikasi Aman**: Login dan Registrasi menggunakan Firebase Auth (Email & Password).
* **Manajemen Profil**: Mengubah nama tampilan dan memperbarui foto profil.
* **Daftar Hadits**: Menampilkan daftar hadits yang diambil dari API eksternal (Saat ini mengambil Hadits Bukhari range 1-50).
* **Detail Hadits**: Melihat teks Arab lengkap dan terjemahan dari hadits tertentu.
* **Fitur Favorit (List)**: Menyimpan hadits yang disukai ke daftar favorit lokal.
* **Pengaturan Aksesibilitas**: Mengubah skala ukuran teks secara keseluruhan di aplikasi.
* **Persistensi Data**: Menggunakan `SharedPreferences` untuk menyimpan data profil dan preferensi pengguna.
* **Splash Screen**: Memeriksa status login pengguna saat aplikasi dimulai untuk navigasi otomatis ke Home atau Login.

## 🛠️ Persyaratan Instalasi

Pastikan Anda telah menginstal hal-hal berikut sebelum menjalankan proyek:

1.  **Flutter SDK**: Versi stabil terbaru.
2.  **Dart SDK**.
3.  **Lingkungan Pengembangan (IDE)**: Visual Studio Code atau Android Studio.
4.  **Device atau Emulator**: Untuk menjalankan aplikasi.
5.  **Firebase Project**: Proyek Firebase yang sudah disiapkan dengan layanan **Authentication** diaktifkan (metode Email/Password).

## 🔑 Endpoint API yang Digunakan

Aplikasi ini menggunakan API Hadits Gading Dev untuk mengambil data hadits.

| Deskripsi | Endpoint | Catatan |
| :--- | :--- | :--- |
| Ambil Hadits Bukhari | `https://api.hadith.gading.dev/books/bukhari?range=1-50` | Digunakan oleh `HadithService`. |

## ⚙️ Cara Instalasi dan Menjalankan Proyek

Ikuti langkah-langkah di bawah ini untuk menyiapkan dan menjalankan proyek Hadist Digital:

### 1. Klon Repositori

git clone <https://github.com/akbarfadhil/UAS-MOBILE>
cd hadist_digital

### 2. Instal Dependencies dan Menyiapkan Proyek
Langkah-langkah berikut harus dilakukan setelah mengklon repositori:

| Aksi | Perintah/Instruksi | Tujuan |
| :--- | :--- | :--- |
|Instal Paket|flutter pub get|Mengunduh semua paket yang diperlukan (firebase_auth, http, shared_preferences, dll.).|
|Konfigurasi Firebase|Tambahkan google-services.json (Android) / GoogleService-Info.plist (iOS).|Memastikan layanan Firebase (Auth) terhubung dengan benar.|
|Siapkan Asset|Pastikan file assets/logo_hadist.png tersedia.|Dibutuhkan untuk tampilan Login dan Splash Screen.|
|Jalankan Aplikasi|flutter run|Menjalankan aplikasi pada perangkat atau emulator Anda.|
