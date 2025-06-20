import 'package:flutter/material.dart';

abstract class PaintContent {
  void draw(Canvas canvas);
  PaintContent copy();
}

class SimpleLine extends PaintContent {
  Offset startPoint;
  Offset endPoint;
  Paint paint;

  SimpleLine({
    required this.startPoint,
    required this.paint,
    Offset? endPoint,
  }) : endPoint = endPoint ?? startPoint;

  @override
  void draw(Canvas canvas) {
    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  SimpleLine copy() => SimpleLine(
        startPoint: startPoint,
        endPoint: endPoint,
        paint: Paint()..color = paint.color,
      );
}