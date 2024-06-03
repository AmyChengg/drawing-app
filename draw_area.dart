import 'package:drawing_with_undo/models/draw_actions/draw_actions.dart';
import 'package:drawing_with_undo/models/tools.dart';
import 'package:drawing_with_undo/providers/drawing_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drawing_painter.dart';

class DrawArea extends StatelessWidget {
  const DrawArea({super.key, required this.width, required this.height});

  final double width, height;

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, drawingProvider, unchangingChild) {
        return CustomPaint(
          size: Size(width, height),
          painter: DrawingPainter(drawingProvider),
          child: GestureDetector(
              onPanStart: (details) => _panStart(details, drawingProvider),
              onPanUpdate: (details) => _panUpdate(details, drawingProvider),
              onPanEnd: (details) => _panEnd(details, drawingProvider),
              child: Container(
                  width: width,
                  height: height,
                  color: Colors.transparent,
                  child: unchangingChild)),
        );
      },
    );
  }

  // Handle tools for none, line, stroke, oval when starting the drawing
  void _panStart(DragStartDetails details, DrawingProvider drawingProvider) {
    final currentTool = drawingProvider.toolSelected;

    switch (currentTool) {
      case Tools.none:
        drawingProvider.pendingAction = NullAction();
        break;
      case Tools.line:
        drawingProvider.pendingAction = LineAction(
          details.localPosition,
          details.localPosition,
          drawingProvider.colorSelected,
        );
        break;
      case Tools.stroke:
        drawingProvider.pendingAction = StrokeAction(
          [details.localPosition],
          drawingProvider.colorSelected,
        );
        break;
      case Tools.oval:
        drawingProvider.pendingAction = OvalAction(
          details.localPosition,
          details.localPosition,
          drawingProvider.colorSelected,
        );
        break;
      default:
        throw UnimplementedError('Tool not implemented: $currentTool');
    }
  }

  // Tools.none gives no action, Tools.line updates the last point, 
  // Tools.stroke updates points with color, Tools.oval updates last point.
  void _panUpdate(DragUpdateDetails details, DrawingProvider drawingProvider) {
    final currentTool = drawingProvider.toolSelected;

    switch (currentTool) {
      case Tools.none:
        break;
      case Tools.line:
        final pendingAction = drawingProvider.pendingAction as LineAction;
        drawingProvider.pendingAction = LineAction(
          pendingAction.point1,
          details.localPosition,
          pendingAction.color,
        );
        break;
      case Tools.stroke:
        final pendingAction = drawingProvider.pendingAction as StrokeAction;
        drawingProvider.pendingAction = StrokeAction(
          List.from(pendingAction.points)..add(details.localPosition),
          pendingAction.color,
        );
        break;
      case Tools.oval:
        final pendingAction = drawingProvider.pendingAction as OvalAction;
        drawingProvider.pendingAction = OvalAction(
          pendingAction.point1,
          details.localPosition,
          pendingAction.color,
        );
        break;
      default:
        throw UnimplementedError('Tool not implemented: $currentTool');
    }
  }

  // At the end of a pan gesture, add pending action to Drawing Provider.
  void _panEnd(DragEndDetails details, DrawingProvider drawingProvider) {
    final currentTool = drawingProvider.toolSelected;
    switch (currentTool) {
      case Tools.none:
        break;
      case Tools.line:
        drawingProvider.add(drawingProvider.pendingAction);
        drawingProvider.pendingAction = NullAction();
      case Tools.stroke:
        drawingProvider.add(drawingProvider.pendingAction);
        drawingProvider.pendingAction = NullAction();
      case Tools.oval:
        drawingProvider.add(drawingProvider.pendingAction);
        drawingProvider.pendingAction = NullAction();
        break;
      default:
        throw UnimplementedError('Tool not implemented: $currentTool');
    }

  }
}
