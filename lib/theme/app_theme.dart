import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFFF8FAFC);
  static const foreground = Color(0xFF0F172A);
  static const accent = Color(0xFF6366F1);
  static const accentSecondary = Color(0xFF8B5CF6);
  static const indigo600 = Color(0xFF4F46E5);
  static const violet600 = Color(0xFF7C3AED);
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate900 = Color(0xFF0F172A);
  static const slate950 = Color(0xFF020617);
  static const rose500 = Color(0xFFF43F5E);
  static const rose600 = Color(0xFFE11D48);
  static const emerald500 = Color(0xFF10B981);
  static const amber400 = Color(0xFFFBBF24);
  static const amber500 = Color(0xFFF59E0B);
}

class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        surface: AppColors.background,
      ),
      textTheme: textTheme.apply(
        bodyColor: AppColors.foreground,
        displayColor: AppColors.foreground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }

  static BoxDecoration get primaryButtonDecoration => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.indigo600, AppColors.violet600],
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x594F46E5),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get gradientTextDecoration => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.indigo600, AppColors.violet600, Color(0xFFA855F7)],
        ),
      );

  static BoxDecoration glassPanel({double opacity = 0.72}) => BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        border: Border(bottom: BorderSide(color: AppColors.slate200.withValues(alpha: 0.6))),
      );
}

String formatPrice(int price) {
  return '${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
}
