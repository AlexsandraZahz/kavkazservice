import 'package:flutter/material.dart';

class AppColors {
  // Основная палитра
  static const Color primaryYellow = Color(0xFFFFD700);
  static const Color vibrantYellow = Color(0xFFFFC107);
  static const Color goldYellow = Color(0xFFFFB300);
  static const Color darkYellow = Color(0xFFFFA000);

  // Черный цвет
  static const Color primaryBlack = Color(0xFF121212); // Добавляем!
  static const Color jetBlack = Color(0xFF121212);

  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFF666666);

  static const Gradient yellowGradient = LinearGradient(
    colors: [primaryYellow, darkYellow],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
