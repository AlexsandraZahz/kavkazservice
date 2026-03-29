import 'package:flutter/material.dart';
import 'package:kavkazway/features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KavkazWay - Исламское такси',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: 'SF Pro Display',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
