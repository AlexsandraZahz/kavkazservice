import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: AppColors.primaryYellow,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryYellow,
        secondary: AppColors.primaryBlack,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryBlack),
        titleTextStyle: TextStyle(
          color: AppColors.primaryBlack,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryYellow,
        unselectedItemColor: AppColors.textGray,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      fontFamily: 'Roboto',
    );
  }
}
