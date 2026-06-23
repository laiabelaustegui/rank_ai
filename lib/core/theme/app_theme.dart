import 'package:flutter/material.dart';

class AppTheme {
  // Colores de marca personalizados
  static const Color primaryColor = Color(0xFF0C8A77);
  static const Color secondaryColor = Color(0xFF8040AC);
  static const Color tertiaryColor = Color(0xFFF59E0B);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(
    0xFF111827,
  ); // Slate-900 (más moderno que el negro puro)
  static const Color textSecondary = Color(
    0xFF4B5563,
  ); // Slate-600 para mejor legibilidad

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        onSecondary: Colors.white,
        onTertiary: Colors.white,

        surface: Colors.white,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,

        surfaceContainer: Colors.white,
        surfaceContainerHighest: Color(0xFFF3F4F6),
        outlineVariant: Color(0xFFE5E7EB),
      ),

      scaffoldBackgroundColor: backgroundColor,

      // Configuración global para los textos
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary, height: 1.4),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),

      // Configuración global para los Chips de sugerencias
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        labelStyle: const TextStyle(
          color: textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Configuración global para los botones reflejando tu color de Stitch
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              secondaryColor, // 👈 Cambiado a tu azul cobalto secundario
          foregroundColor: Colors.white, // 👈 Fuerza el texto e icono a blanco
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
