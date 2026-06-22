import 'package:flutter/material.dart';

class AppTheme {
  // Colores de marca personalizados
  static const Color primaryColor = Color(0xFF0D9488);
  static const Color backgroundColor = Color(
    0xFFF8F9FA,
  ); // Gris muy claro de fondo
  static const Color textPrimary = Color(0xFF1A1A1A); // Casi negro para títulos
  static const Color textSecondary = Color(0xFF757575); // Gris para subtítulos

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(
          0xFF0D9488,
        ), // Tu Teal de marca (Filtros, Análisis, etc.)
        secondary: Color(0xFF2B5CB3), // Azul oscuro para el badge "RANKED #1"
        surface: Colors.white, // Fondo de las tarjetas del ranking
        onSurface: Color(0xFF111827), // Texto principal (Casi negro)
        onSurfaceVariant: Color(
          0xFF6B7280,
        ), // Texto secundario (Gris descriptivo)
      ),

      scaffoldBackgroundColor: backgroundColor,

      // Configuración global para los textos
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        // Find the best y textos importantes ahora serán oscuros por defecto
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        // Usamos bodyMedium para subtítulos o descripciones largas
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
        titleMedium: TextStyle(
          fontSize: 16, // Subido ligeramente de 14 a 16 para jerarquía visual
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),

      // Configuración global para los Chips de sugerencias
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        labelStyle: const TextStyle(color: textPrimary, fontSize: 14),
        side: BorderSide(color: Colors.grey.shade200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // <--- Cambiado a ElevatedButton.styleFrom
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
