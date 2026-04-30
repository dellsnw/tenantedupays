import 'package:flutter/material.dart';
import 'splash_page.dart';

void main() {
  runApp(EdupaysApp());
}

class EdupaysApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// THEME BIAR KELIATAN RAPI
      theme: ThemeData(
        primaryColor: const Color(0xFF00BCC9),
        scaffoldBackgroundColor: Colors.white,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BCC9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      /// START DARI SPLASH
      home: SplashPage(),
    );
  }
}