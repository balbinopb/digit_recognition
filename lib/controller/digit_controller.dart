import 'dart:typed_data';
import 'package:digit_recognition/bounding_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:signature/signature.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DigitController extends GetxController {
  late Interpreter interpreter;
  final prediction = ''.obs;
  final processedImageBytes = Rx<Uint8List?>(null);

  final signatureController = SignatureController(
    penStrokeWidth: 8,
    penColor: Colors.white,
    exportBackgroundColor: Colors.black,
  );

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/digit_model.tflite');
      if (kDebugMode) {
        print('Model loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('failed to load model: $e');
      }
    }
  }

  void clearCanvas() {
    signatureController.clear();
    prediction.value = '';
    processedImageBytes.value = null;
  }

  Future<void> predict() async {
    if (signatureController.isEmpty) return;

    final pngBytes = await signatureController.toPngBytes();
    if (pngBytes == null || pngBytes.isEmpty) {
      print('png bytes empty');
      return;
    }

    img.Image? image = img.decodeImage(pngBytes);
    if (image == null) return;

    img.Image resized = img.copyResize(image, width: 28, height: 28);
    img.Image grayscale = img.grayscale(resized);

    grayscale = centerAndResize(grayscale);

    // Preview processed input
    processedImageBytes.value = Uint8List.fromList(img.encodePng(grayscale));

    Float32List input = Float32List(28 * 28);
    for (int y = 0; y < 28; y++) {
      for (int x = 0; x < 28; x++) {
        final pixel = grayscale.getPixel(x, y);
        final luminance = img.getLuminance(pixel);
        input[y * 28 + x] = luminance / 255.0;
      }
    }

    print("non zero pixels: ${input.where((v) => v > 0.01).length}");

    final inputTensor = input.reshape([1, 28, 28, 1]);
    final outputTensor = List.filled(10, 0.0).reshape([1, 10]);

    interpreter.run(inputTensor, outputTensor);

    double maxVal = -1;
    int predictedIndex = -1;
    for (int i = 0; i < 10; i++) {
      if (outputTensor[0][i] > maxVal) {
        maxVal = outputTensor[0][i];
        predictedIndex = i;
      }
    }

    prediction.value = predictedIndex.toString();

    // print("Raw output: ${outputTensor[0]}");
    // print("Predicted: $predictedIndex");
  }

  img.Image centerAndResize(img.Image input) {
    final bounds = findBoundingBox(input, threshold: 10);
    if (bounds == null) return input;

    final cropped = img.copyCrop(
      input,
      x: bounds.left,
      y: bounds.top,
      width: bounds.width,
      height: bounds.height,
    );

    final resizedDigit = img.copyResize(
      cropped,
      width: 20,
      height: 20,
      interpolation: img.Interpolation.average,
    );

    final canvas = img.Image(width: 28, height: 28);
    img.fillRect(
      canvas,
      x1: 0,
      y1: 0,
      x2: 27,
      y2: 27,
      color: img.ColorRgb8(0, 0, 0),
    );

    for (int y = 0; y < resizedDigit.height; y++) {
      for (int x = 0; x < resizedDigit.width; x++) {
        final pixel = resizedDigit.getPixel(x, y);
        canvas.setPixel(x + 4, y + 4, pixel);
      }
    }

    return canvas;
  }

  BoundingBox? findBoundingBox(img.Image image, {int threshold = 10}) {
    int? top, bottom, left, right;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final luminance = img.getLuminance(pixel);
        if (luminance > threshold) {
          top ??= y;
          bottom = y;
          if (left == null || x < left) left = x;
          if (right == null || x > right) right = x;
        }
      }
    }

    if (top == null || bottom == null || left == null || right == null) {
      return null;
    }

    return BoundingBox(left, top, right, bottom);
  }
}


