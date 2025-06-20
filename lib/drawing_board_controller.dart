import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

class DrawingBoardController extends ChangeNotifier {
  final List<PaintContent> _contents = [];
  final List<PaintContent> _undoStack = [];

  List<PaintContent> get contents => List.unmodifiable(_contents);

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

  void drawContents(Canvas canvas, Size size) {
    for (final content in _contents) {
      content.draw(canvas);
    }
  }
}