import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ─── Paleta de Cores Oficial CMOC (Azul, Branco e Detalhes Verdes) ─────────
  static const Color primaryBlue = Color(0xFF0F4C81);   // Azul Corporativo CMOC
  static const Color accentBlue = Color(0xFF005691);    // Azul Médio CMOC
  static const Color lightBlue = Color(0xFFE8F1F8);     // Azul Claro Suave
  static const Color darkBlue = Color(0xFF0A3154);      // Azul Marinho Escuro
  
  static const Color cmocGreen = Color(0xFF00A859);     // Verde CMOC (Detalhes e Confirmação)
  static const Color greenSuccess = Color(0xFF00A859);  // Verde Sucesso
  static const Color redAlert = Color(0xFFD9381E);      // Vermelho Alerta
  
  // Compatibilidade com variáveis antigas apontando para a nova paleta CMOC
  static const Color primaryPurple = primaryBlue;
  static const Color accentPurple = accentBlue;
  static const Color lightPurple = lightBlue;
  
  static const Color backgroundLight = Color(0xFFF4F7FA); // Fundo limpo azulado/cinza
  static const Color cardColorLight = Colors.white;       // Cards brancos cristalinos
  static const Color cardColorLight2 = Color(0xFFF8FAFC);  // Fundo secundário do card
  static const Color borderLight = Color(0xFFD4E0EB);     // Cor de bordas suaves
  
  static const Color textDark = Color(0xFF0D253A);        // Texto principal Azul-Escuro
  static const Color textMuted = Color(0xFF4A6076);       // Texto Muted
  static const Color textFaint = Color(0xFF8CA0B4);       // Texto Faint

  // ─── Cores Modo Escuro ─────────
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardColorDark = Color(0xFF1E1E1E);
  static const Color borderDark = Color(0xFF2C2C2C);
  static const Color textLight = Color(0xFFF4F7FA);
  static const Color textMutedDark = Color(0xFFA0B4C8);

  // Tema Claro Oficial CMOC
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardColorLight,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        headlineMedium: GoogleFonts.outfit(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16.0,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14.0,
          color: textMuted,
        ),
        labelSmall: GoogleFonts.firaCode(
          fontSize: 11.0,
          color: textFaint,
          letterSpacing: 1.0,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: cmocGreen,
        tertiary: accentBlue,
        background: backgroundLight,
        surface: cardColorLight,
        error: redAlert,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: textDark,
        onSurface: textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: primaryBlue),
        actionsIconTheme: const IconThemeData(color: primaryBlue),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
          color: textDark,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColorLight,
        elevation: 4,
        shadowColor: primaryBlue.withOpacity(0.08),
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: borderLight, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: primaryBlue.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: borderLight, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: redAlert, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: redAlert, width: 2.0),
        ),
        hintStyle: const TextStyle(
          color: textFaint,
          fontSize: 14.0,
        ),
        labelStyle: const TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryBlue,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: borderLight, width: 1.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // Tema Escuro Oficial CMOC
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardColorDark,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        headlineMedium: GoogleFonts.outfit(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
          color: textLight,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16.0,
          color: textLight,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14.0,
          color: textMutedDark,
        ),
        labelSmall: GoogleFonts.firaCode(
          fontSize: 11.0,
          color: textFaint,
          letterSpacing: 1.0,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: cmocGreen,
        tertiary: accentBlue,
        background: backgroundDark,
        surface: cardColorDark,
        error: redAlert,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: textLight,
        onSurface: textLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cardColorDark,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: lightBlue),
        actionsIconTheme: const IconThemeData(color: lightBlue),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
          color: textLight,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColorDark,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: borderDark, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: borderDark, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: lightBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: redAlert, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: redAlert, width: 2.0),
        ),
        hintStyle: const TextStyle(
          color: textFaint,
          fontSize: 14.0,
        ),
        labelStyle: const TextStyle(
          color: lightBlue,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryBlue,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightBlue,
          side: const BorderSide(color: borderDark, width: 1.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
