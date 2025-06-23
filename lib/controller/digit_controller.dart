import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:signature/signature.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DigitController extends GetxController {
  final signatureController = SignatureController(
    penStrokeWidth: 10,
    penColor: Colors.black,
    // backgroundColor: Colors.white,
  );

  var prediction = ''.obs;
  late Interpreter interpreter;

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/digit_model.tflite');
    print('Model loaded. Input: ${interpreter.getInputTensor(0).shape}');
  }

  void clearCanvas() {
    signatureController.clear();
    prediction.value = '';
  }

  Future<void> predict() async {
    if (signatureController.isEmpty) return;

    final pngBytes = await signatureController.toPngBytes();
    if (pngBytes == null) return;

    img.Image? image = img.decodeImage(pngBytes);
    if (image == null) return;

    // Resize and grayscale
    img.Image resized = img.copyResize(image, width: 28, height: 28);
    img.Image grayscale = img.grayscale(resized);

    // Optional: invert if model expects black on white
    // grayscale = img.invert(grayscale);

    // Convert to Float32List
    Float32List input = Float32List(28 * 28);
    final bytes = grayscale.getBytes();
    for (int i = 0; i < 28 * 28; i++) {
      input[i] = bytes[i] / 255.0;
    }

    // Reshape to [1, 28, 28, 1]
    final inputTensor = input.reshape([1, 28, 28, 1]);

    // Output buffer
    final outputTensor = List.filled(10, 0.0).reshape([1, 10]);

    interpreter.run(inputTensor, outputTensor);
    print("Raw output: ${outputTensor[0]}");

    // Get prediction
    double maxVal = -1;
    int predictedIndex = -1;
    for (int i = 0; i < 10; i++) {
      if (outputTensor[0][i] > maxVal) {
        maxVal = outputTensor[0][i];
        predictedIndex = i;
      }
    }

    prediction.value = predictedIndex.toString();
  }
}
