import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RetroTheme {
  static const Color background = Color(0xFF111111);
  static const Color primary = Color(0xFF39FF14); // Neon Green
  static const Color secondary = Color(0xFF00FFFF); // Cyan
  static const Color accent = Color(0xFFFF00FF); // Magenta
  static const Color textLight = Colors.white;
  static const Color border = Colors.white;

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      textTheme: GoogleFonts.pressStart2pTextTheme().apply(
        bodyColor: textLight,
        displayColor: textLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 4),
          shape: const ContinuousRectangleBorder(),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          textStyle: GoogleFonts.pressStart2p(fontSize: 14),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed))
                return primary.withOpacity(0.2);
              return null;
            },
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        centerTitle: true,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: primary, width: 4)),
        titleTextStyle: GoogleFonts.pressStart2p(color: primary, fontSize: 18),
        iconTheme: const IconThemeData(color: primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.black,
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: textLight, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: secondary, width: 4),
        ),
        labelStyle: GoogleFonts.pressStart2p(color: textLight, fontSize: 12),
        hintStyle: GoogleFonts.pressStart2p(color: Colors.grey, fontSize: 10),
      ),
    );
  }
}
