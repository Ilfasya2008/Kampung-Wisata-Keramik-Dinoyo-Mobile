import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colors taken from the Figma "Mobile" page (screen 01 Beranda).
class AppColors {
  static const background = Color(0xFFFEFAF4);
  static const ink = Color(0xFF4A3326);
  static const muted = Color(0xFF735C4D);
  static const primary = Color(0xFFB56B4A);
  static const tan = Color(0xFFE8C7AD);
  static const sand = Color(0xFFE0CFB2);
  static const border = Color(0xFFD7C1A8);
  static const sage = Color(0xFF829470);
  static const brick = Color(0xFFB85947);
  static const whatsapp = Color(0xFF25D366);
  static const white = Colors.white;

  // Status chip colors (approximated from the design overview).
  static const okBg = Color(0xFFDDE6D3);
  static const okFg = Color(0xFF4F6340);
  static const warnBg = Color(0xFFF3E1B8);
  static const warnFg = Color(0xFF8A6417);
  static const offBg = Color(0xFFEBD3CE);
  static const offFg = Color(0xFF9A4338);
}

class AppShadows {
  static const primaryButton = [
    BoxShadow(color: Color(0x38B56B4A), blurRadius: 16, offset: Offset(0, 6)),
  ];
  static const whatsappButton = [
    BoxShadow(color: Color(0x3825D366), blurRadius: 16, offset: Offset(0, 6)),
  ];
  static const card = [
    BoxShadow(color: Color(0x1FB56B4A), blurRadius: 16, offset: Offset(0, 6)),
  ];
  static const bottomBar = [
    BoxShadow(color: Color(0x0F4A3326), blurRadius: 16, offset: Offset(0, -4)),
  ];
}

class AppText {
  static TextStyle inter({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double height = 1.5,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  static TextStyle get h1 =>
      inter(size: 30, weight: FontWeight.w700, height: 1.15);
  static TextStyle get h2 =>
      inter(size: 20, weight: FontWeight.w700, height: 1.22);
  static TextStyle get h3 =>
      inter(size: 18, weight: FontWeight.w700, height: 1.22);
  static TextStyle get cardTitle => inter(size: 15, weight: FontWeight.w700);
  static TextStyle get body14 => inter(size: 14, color: AppColors.muted);
  static TextStyle get body13 => inter(size: 13, color: AppColors.muted);
  static TextStyle get body12 => inter(size: 12, color: AppColors.muted);
  static TextStyle get label13 => inter(size: 13, weight: FontWeight.w600);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );
  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
    ),
  );
}
