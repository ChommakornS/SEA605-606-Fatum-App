import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFF080C1A);
  static const surface = Color(0xFF0F1629);
  static const surfaceElevated = Color(0xFF161E35);
  static const bloodMoon = Color(0xFF8B1A1A);
  static const bloodRed = Color(0xFFCC2222);
  static const bloodRedLight = Color(0xFFE53535);
  static const gold = Color(0xFFD4AF37);
  static const goldLight = Color(0xFFEDD97A);
  static const muted = Color(0xFF4A4E6A);
  static const textPrimary = Color(0xFFE8E0D0);
  static const textSecondary = Color(0xFFA09880);
  static const textMuted = Color(0xFF6B6580);
  static const cardBack = Color(0xFF1A1040);
  static const divider = Color(0xFF2A2D4A);
  static const fog = Color(0x1AFFFFFF);
}

class AppTheme {
  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.cinzel(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 2,
      ),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 1.5,
      ),
      headlineLarge: GoogleFonts.cinzel(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.cinzel(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.cinzel(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.cinzel(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.cinzel(
        fontSize: 14,
        color: AppColors.textPrimary,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.cinzel(
        fontSize: 13,
        color: AppColors.textSecondary,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.cinzel(
        fontSize: 11,
        color: AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.cinzel(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 1.2,
      ),
    );
  }

  static ThemeData get dark {
    final textTheme = _buildTextTheme();

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.bloodRed,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        error: AppColors.bloodRedLight,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.bloodRed,
        unselectedItemColor: AppColors.muted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.cinzel(fontSize: 10),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bloodRed,
          foregroundColor: AppColors.textPrimary,
          textStyle: GoogleFonts.cinzel(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: AppColors.bloodMoon, width: 1),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.gold, width: 1),
          textStyle: GoogleFonts.cinzel(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.bloodRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.bloodRedLight, width: 1.5),
        ),
        hintStyle: GoogleFonts.cinzel(color: AppColors.textMuted, fontSize: 13),
        labelStyle: GoogleFonts.cinzel(color: AppColors.textSecondary, fontSize: 13),
        errorStyle: GoogleFonts.cinzel(color: AppColors.bloodRedLight, fontSize: 11),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceElevated,
        selectedColor: AppColors.bloodMoon,
        labelStyle: GoogleFonts.cinzel(fontSize: 11, color: AppColors.textPrimary),
        side: const BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceElevated,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.gold, width: 1),
        ),
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 18,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: GoogleFonts.cinzel(
          fontSize: 13,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: GoogleFonts.cinzel(
          color: AppColors.textPrimary,
          fontSize: 13,
        ),
      ),
    );
  }
}
