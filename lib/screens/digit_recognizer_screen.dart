import 'package:digit_recognition/controller/digit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

class DigitRecognizerScreen extends StatelessWidget {
  final DigitController controller = Get.put(DigitController());

  DigitRecognizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Digit Recognizer")),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.white),
            ),
            child: Signature(controller: controller.signatureController),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.predict,
                child: Text("Predict"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: controller.clearCanvas,
                child: Text("Clear"),
              ),
            ],
          ),
          SizedBox(height: 30),
          Obx(
            () => Text(
              "Prediction: ${controller.prediction.value}",
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
