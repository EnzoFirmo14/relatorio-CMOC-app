import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ─── Paleta de Cores Oficial CMOC (Tema Claro) ─────────
  static const Color primaryBlue = Color(0xFF0F4C81);   // Azul Corporativo CMOC
  static const Color accentBlue = Color(0xFF005691);    // Azul Médio CMOC
  static const Color lightBlue = Color(0xFFE8F1F8);     // Azul Claro Suave
  static const Color darkBlue = Color(0xFF0A3154);      // Azul Marinho Escuro
  
  static const Color cmocGreen = Color(0xFF00A859);     // Verde CMOC
  static const Color greenSuccess = Color(0xFF00A859);  // Verde Sucesso
  static const Color redAlert = Color(0xFFD9381E);      // Vermelho Alerta
  
  // Compatibilidade com código legado
  static const Color primaryPurple = primaryBlue;
  static const Color accentPurple = accentBlue;
  static const Color lightPurple = lightBlue;
  
  static const Color backgroundLight = Color(0xFFF4F7FA); // Fundo limpo azulado/cinza
  static const Color cardColorLight = Colors.white;       // Cards brancos
  static const Color cardColorLight2 = Color(0xFFF8FAFC);  // Fundo secundário do card
  static const Color borderLight = Color(0xFFD4E0EB);     // Bordas suaves
  
  static const Color textDark = Color(0xFF0D253A);        // Texto principal
  static const Color textMuted = Color(0xFF4A6076);       // Texto Secundário
  static const Color textFaint = Color(0xFF8CA0B4);       // Texto Faint

  // ─── Cores Modo Escuro (Identidade CMOC Enterprise - Alto Contraste) ─────────
  static const Color backgroundDark = Color(0xFF0B1120);  // Fundo Industrial Escuro
  static const Color cardColorDark = Color(0xFF111827);    // Cards cinza-azulados elevados
  static const Color cardColorDark2 = Color(0xFF1E293B);   // Fundo secundário do card
  static const Color borderDark = Color(0xFF374151);       // Borda nítida de alto contraste
  static const Color textLight = Color(0xFFF9FAFB);        // Texto branco cristalino
  static const Color textMutedDark = Color(0xFFCBD5E1);    // Texto secundário claro e legível
  static const Color textFaintDark = Color(0xFF94A3B8);    // Texto faint legível
  
  static const Color primaryBlueDark = Color(0xFF38BDF8);  // Azul Vivo Cyan (Alto contraste no escuro)
  static const Color accentBlueDark = Color(0xFF818CF8);   // Roxo/Azul Destaque Vivo
  static const Color cmocGreenDark = Color(0xFF4ADE80);    // Verde Vivo Sucesso

  // ─── Helpers Dinâmicos para Adaptação de Tema ─────────
  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static Color primary(BuildContext context) => isDark(context) ? primaryBlueDark : primaryBlue;
  static Color accent(BuildContext context) => isDark(context) ? accentBlueDark : accentBlue;
  static Color green(BuildContext context) => isDark(context) ? cmocGreenDark : cmocGreen;
  static Color textPrimary(BuildContext context) => isDark(context) ? textLight : textDark;
  static Color textMutedColor(BuildContext context) => isDark(context) ? textMutedDark : textMuted;
  static Color textFaintColor(BuildContext context) => isDark(context) ? textFaintDark : textFaint;
  static Color cardBg(BuildContext context) => isDark(context) ? cardColorDark : cardColorLight;
  static Color subCardBg(BuildContext context) => isDark(context) ? cardColorDark2 : cardColorLight2;
  static Color border(BuildContext context) => isDark(context) ? borderDark : borderLight;

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
        surface: cardColorLight,
        error: redAlert,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
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
        shadowColor: primaryBlue.withValues(alpha: 0.08),
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: borderLight, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: primaryBlue.withValues(alpha: 0.03),
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

  // Tema Escuro Oficial CMOC (Alto Contraste Enterprise)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlueDark,
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardColorDark,
      dialogTheme: const DialogThemeData(
        backgroundColor: cardColorDark,
        surfaceTintColor: Colors.transparent,
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(cardColorDark),
        ),
      ),
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
          color: textFaintDark,
          letterSpacing: 1.0,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryBlueDark,
        secondary: cmocGreenDark,
        tertiary: accentBlueDark,
        surface: cardColorDark,
        error: redAlert,
        onPrimary: Color(0xFF0F172A),
        onSecondary: Color(0xFF0F172A),
        onSurface: textLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cardColorDark,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: primaryBlueDark),
        actionsIconTheme: const IconThemeData(color: primaryBlueDark),
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
        shadowColor: Colors.black.withValues(alpha: 0.5),
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: borderDark, width: 1.2),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColorDark2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: borderDark, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: primaryBlueDark, width: 1.5),
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
          color: textFaintDark,
          fontSize: 14.0,
        ),
        labelStyle: const TextStyle(
          color: primaryBlueDark,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryBlueDark,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlueDark,
          foregroundColor: const Color(0xFF0F172A),
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
          foregroundColor: primaryBlueDark,
          side: const BorderSide(color: borderDark, width: 1.2),
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
