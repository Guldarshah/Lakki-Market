import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const LakkiMarketApp());
}

class LakkiMarketApp extends StatelessWidget {
  const LakkiMarketApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لکی مارکیٹ (Lakki Market)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
        fontFamily: 'Roboto', // آپ چاہیں تو اردو فونٹ بھی سیٹ کر سکتے ہیں
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
