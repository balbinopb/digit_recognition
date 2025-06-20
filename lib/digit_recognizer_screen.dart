import 'package:digit_recognition/digit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class DigitRecognizerScreen extends StatelessWidget {
  const DigitRecognizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digit Recognizer')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DrawingBoard(
                controller: DrawingBoardController(),
                background: Container(color: Colors.black),
                strokeWidth: 20.0,
                strokeColor: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Predict')),
                ElevatedButton(onPressed: () {}, child: const Text('Clear')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
