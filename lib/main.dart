import 'package:flutter/material.dart';
import 'screens/digit_recognizer_screen.dart';

void main() {
  runApp(const DigitRecognizerApp());
}

class DigitRecognizerApp extends StatelessWidget {
  const DigitRecognizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digit Recognizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DigitRecognizerScreen(),
    );
  }
}