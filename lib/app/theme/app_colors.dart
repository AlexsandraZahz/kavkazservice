import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета
  static const Color primaryYellow = Color(0xFFF9C40D);
  static const Color primaryDark = Color(0xFF1A1A1A);
  static const Color primaryLight = Color(0xFFFFF3E0);

  // Статусы
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF007AFF);

  // Дополнительные
  static const Color online = Color(0xFF34C759);
  static const Color offline = Color(0xFF8E8E93);
  static const Color background = Color(0xFFF2F2F7);
  static const Color cardBackground = Colors.white;

  // Градиенты
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF9C40D), Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF2C2C2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
