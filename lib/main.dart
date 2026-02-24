import 'package:flutter/material.dart';
import 'package:pdf_watermarker/screens/splash_screen.dart';
import 'package:pdf_watermarker/theme/retro_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf_watermarker/services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ken\'s Banga Changa App',
      theme: RetroTheme.theme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
