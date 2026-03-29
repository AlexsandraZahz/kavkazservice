import 'package:flutter/material.dart';
import 'package:kavkazway/app/theme/app_theme.dart';
import 'package:kavkazway/features/main_screen/main_screen.dart';

class KavkazWayApp extends StatelessWidget {
  const KavkazWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KavkazWay',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
