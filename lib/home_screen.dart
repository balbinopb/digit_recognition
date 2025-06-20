import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:get/get.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

 @override
  Widget build(BuildContext context) {
    final controller = Get.put(DigitController());

    return Scaffold(
      appBar: AppBar(title: const Text('Digit Recognizer')),
      body: Column(
        children: [
          DrawingBoard(
            controller: controller.drawingController,
            background: Container(width: 400, height: 400, color: Colors.white),
            showDefaultActions: true,
            showDefaultTools: true,
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                controller.result.value,
                style: const TextStyle(fontSize: 20),
              )),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: controller.clear, child: const Text("Clear")),
              ElevatedButton(onPressed: controller.predictDigit, child: const Text("Predict")),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
