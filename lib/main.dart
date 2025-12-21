import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EatCost',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        fontFamily: "FFGoodPro",
        primaryColor: const Color(0xFF2F5630),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F5630),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7F8),
      ),
      home: const MainScreen(),
    );
  }
}
