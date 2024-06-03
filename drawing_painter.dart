import 'package:drawing_with_undo/models/draw_actions/draw_actions.dart';
import 'package:drawing_with_undo/models/drawing.dart';
import 'package:drawing_with_undo/providers/drawing_provider.dart';
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final Drawing _drawing;
  final DrawingProvider _provider;

  DrawingPainter(DrawingProvider provider) : _drawing = provider.drawing, _provider = provider;

  // Paint on canvas with the draw actions as well letting users see what
  // they're drawing live while drawing it
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.clipRect(rect); // make sure we don't scribble outside the lines.

    final erasePaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawRect(rect, erasePaint);

    for (final action in _provider.drawing.drawActions){
      _paintAction(canvas, action, size);
    }

    _paintAction(canvas, _provider.pendingAction, size);
  }

  // Handle null action, line action, clear action, stroke action, oval action
  void _paintAction(Canvas canvas, DrawAction action, Size size){
    final removeAct = Paint()..blendMode = BlendMode.clear;

    switch (action) {
        case NullAction _:
          break;
        case ClearAction _:
          canvas.drawRect(Offset.zero & size, removeAct);
          break;
        case LineAction lineAction:
          final lineColor = Paint()..color = lineAction.color
          ..strokeWidth = 2;
          canvas.drawLine(lineAction.point1, lineAction.point2, lineColor);
          break;
        case StrokeAction strokeAction:
        final strokeColor = Paint()
          ..color = strokeAction.color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        final path = Path()..addPolygon(strokeAction.points, false);
        canvas.drawPath(path, strokeColor);
        break;
        case OvalAction ovalAction:
          final ovalColor = Paint()
            ..color = ovalAction.color
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke;
          canvas.drawOval(
            Rect.fromPoints(ovalAction.point1, ovalAction.point2),
            ovalColor,
          );
          break;
        default:
          throw UnimplementedError('Action not implemented: $action'); 
      }
  }

  // Returns true if drawing in old delegate is not the same as the current delegate,
  // Tightens this subclass to the paint method
  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate._drawing != _drawing;
  }
}
