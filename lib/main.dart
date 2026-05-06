import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_page.dart';

void main() {
  runApp(const EdupaysApp());
}

class EdupaysApp extends StatelessWidget {
  const EdupaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// THEME BIAR KELIATAN RAPI
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        fontFamily: GoogleFonts.poppins().fontFamily,
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
      home: const SplashPage(),
    );
  }
}
