import 'package:flutter/material.dart';

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

  // Tema Claro Oficial CMOC
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardColorLight,
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
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryBlue),
        actionsIconTheme: IconThemeData(color: primaryBlue),
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
          color: textDark,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColorLight,
        elevation: 2,
        shadowColor: primaryBlue.withOpacity(0.08),
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: borderLight, width: 1.0),
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: primaryBlue.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: borderLight, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: redAlert, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
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
          textStyle: const TextStyle(
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
            borderRadius: BorderRadius.circular(10.0),
          ),
          textStyle: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16.0,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14.0,
          color: textMuted,
        ),
        labelSmall: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11.0,
          color: textFaint,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
