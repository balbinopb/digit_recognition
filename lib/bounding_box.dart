class BoundingBox {
  final int top, left, right, bottom;
  BoundingBox(this.left, this.top, this.right, this.bottom);

  int get width => right - left + 1;
  int get height => bottom - top + 1;
}
 