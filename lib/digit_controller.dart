import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

class DrawingBoardController extends ChangeNotifier {
  final List<PaintContent> _contents = [];
  final List<PaintContent> _undoStack = [];

  List<PaintContent> getAllContents() => List.from(_contents);

  Future<Uint8List> exportDrawing() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final bgPaint = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, 280, 280), bgPaint);
    drawingController.drawContents(canvas, const Size(280, 280));
    final picture = recorder.endRecording();
    final image = await picture.toImage(280, 280);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> predictDrawing() async {
    try {
      final imageBytes = await exportDrawing();
    } catch (e) {
      debugPrint('Error predicting drawing: $e');
    }
  }

  void addContent(PaintContent content) {
    _contents.add(content);
    _undoStack.clear();
    notifyListeners();
  }

  void clear() {
    _contents.clear();
    _undoStack.clear();
    notifyListeners();
  }

  void undo() {
    if (_contents.isNotEmpty) {
      _undoStack.add(_contents.removeLast());
      notifyListeners();
    }
  }

  void redo() {
    if (_undoStack.isNotEmpty) {
      _contents.add(_undoStack.removeLast());
      notifyListeners();
    }
  }

  bool get canUndo => _contents.isNotEmpty;
  bool get canRedo => _undoStack.isNotEmpty;

  get drawingController => null;

  void drawContents(Canvas canvas, Size size) {
    for (final content in _contents) {
      content.draw(canvas);
    }
  }
}
