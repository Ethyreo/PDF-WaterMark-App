import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_watermarker/screens/home_screen.dart';
import 'package:pdf_watermarker/theme/retro_theme.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ken's Banga Changa",
              textAlign: TextAlign.center,
              style: GoogleFonts.bungeeHairline(
                fontSize: 40,
                color: RetroTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "PDF Watermark Super App",
              textAlign: TextAlign.center,
              style: GoogleFonts.pressStart2p(
                fontSize: 12,
                color: RetroTheme.secondary,
                height: 2,
              ),
            ),
            const SizedBox(height: 60),
            Text(
              "Built by Ken for Lovish",
              textAlign: TextAlign.center,
              style: GoogleFonts.permanentMarker(
                fontSize: 24,
                color: RetroTheme.accent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "To make Watermarking easy",
              textAlign: TextAlign.center,
              style: GoogleFonts.vt323(
                fontSize: 24,
                color: RetroTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
