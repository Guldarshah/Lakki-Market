import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const LakkiMarketApp());
}

class LakkiMarketApp extends StatelessWidget {
  const LakkiMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lakki Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}
