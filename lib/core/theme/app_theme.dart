import 'package:flutter/material.dart';

class AppTheme {
  // Colores de marca personalizados
  static const Color primaryColor = Color(0xFF0D9488); // Teal pulcro
  static const Color backgroundColor = Color(
    0xFFF8F9FA,
  ); // Gris premium muy claro
  static const Color textPrimary = Color(
    0xFF111827,
  ); // Corregido a Slate-900 (más moderno que el negro puro)
  static const Color textSecondary = Color(
    0xFF4B5563,
  ); // Corregido a Slate-600 para mejor legibilidad

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: Color(
          0xFF6366F1,
        ), // Azul cobalto un pelín más vibrante para los puestos del ranking
        surface: Colors.white,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,

        // 🚀 NUEVOS COLORES CLAVE PARA DARLE "WOW EFFECT" AL LISTADO:
        surfaceContainer: Colors.white, // Fondo de tus Cards principales
        surfaceContainerHighest: Color(
          0xFFF3F4F6,
        ), // Fondo sutil para las píldoras/chips de tus tags
        outlineVariant: Color(
          0xFFE5E7EB,
        ), // Gris neutro perfecto para los bordes finos de las tarjetas (Adiós gris por defecto)
        tertiary: Color(
          0xFFF59E0B,
        ), // Color Ámbar corporativo para la estrella de Rating
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
          fontSize: 16,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ), // Un pelín menos redondeados para aire más pro
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
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
