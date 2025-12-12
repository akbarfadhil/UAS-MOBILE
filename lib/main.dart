import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_page.dart';
import 'list_page.dart';
import 'settings_page.dart';
import 'edit_profile_page.dart';
import 'settings_service.dart';
import 'user_service.dart';
import 'splash_screen.dart'; // <--- 1. JANGAN LUPA IMPORT INI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserService.loadProfile();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: SettingsService.textScaleFactor,
      builder: (context, scale, child) {
        return MaterialApp(
          title: 'Hadist Digital',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Roboto',
          ),
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
              child: child!,
            );
          },
          // 2. GANTI INITIAL ROUTE JADI '/splash'
          initialRoute: '/splash', 
          
          routes: {
            // 3. DAFTARKAN ROUTE SPLASH DI SINI
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomePage(),
            '/list': (context) => const ListPage(),
            '/settings': (context) => const SettingsPage(),
            '/edit_profile': (context) => const EditProfilePage(),
          },
        );
      },
    );
  }
}