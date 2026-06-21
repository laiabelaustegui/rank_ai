import 'package:flutter/material.dart';

class AppTheme {
  // Colores de marca personalizados
  static const Color primaryColor = Color(0xFF0D9488);
  static const Color backgroundColor = Color(
    0xFFF8F9FA,
  ); // Gris muy claro de fondo
  static const Color textPrimary = Color(0xFF1A1A1A); // Casi negro para títulos
  static const Color textSecondary = Colors.grey; // Gris para subtítulos

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),

      scaffoldBackgroundColor: backgroundColor,

      // Configuración global para los textos
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textSecondary),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // Configuración global para los Chips de sugerencias
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey.shade200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
