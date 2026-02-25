import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_chef_ai_assistant/src/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.light,
        surface: AppColors.lightBg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
        titleTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.lightCard,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        clipBehavior: Clip.antiAlias,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.darkGreen,
        unselectedItemColor: Color.fromARGB(255, 114, 102, 102),
        backgroundColor: AppColors.white,
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: AppColors.primaryGreen.withAlpha(50),
      ),
      textTheme: GoogleFonts.latoTextTheme(),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.dark,
        surface: AppColors.darkBg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkCard,
        foregroundColor: AppColors.lightGreen,
        titleTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightGreen,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.darkCard,
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        clipBehavior: Clip.antiAlias,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.lightGreen,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColors.darkCard,
      ),
      bottomAppBarTheme: BottomAppBarThemeData(
        color: AppColors.primaryGreen.withAlpha(30),
      ),
      textTheme: GoogleFonts.latoTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
    );
  }
}
