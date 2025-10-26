import 'package:cargadatos/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WaterMeasurementApp());
}

class WaterMeasurementApp extends StatelessWidget {
  const WaterMeasurementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mediciones de Agua',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF0D47A1),
        scaffoldBackgroundColor: const Color(0xFFE3F2FD),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}