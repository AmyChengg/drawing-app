import 'package:drawing_with_undo/providers/drawing_provider.dart';
import 'package:drawing_with_undo/views/draw_area.dart';
import 'package:drawing_with_undo/views/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  const drawAreaWidth = 400.0;
  const drawAreaHeight = 400.0;
  runApp(
    ChangeNotifierProvider(
      create: (context) => DrawingProvider(width: drawAreaWidth, height: drawAreaHeight),
      child: const MainApp(width: drawAreaWidth, height: drawAreaHeight),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.width, required this.height});

  final double width;
  final double height;

  // Clear method for clear button
  _clear(BuildContext context) {
    Provider.of<DrawingProvider>(context, listen: false).clear();
  }

  // Undo method for undo button
  _undo(BuildContext context) {
    Provider.of<DrawingProvider>(context, listen: false).undo();
  }

  // Redo method for redo button
  _redo(BuildContext context) {
    Provider.of<DrawingProvider>(context, listen: false).redo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Drawing App'),
          actions: <Widget>[
            // Using semantics to show the buttons for clear drawing, undo, and redo
            Semantics(
              label: 'Clear drawing',
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _clear(context),
                tooltip: 'Clear drawing',
              ),
            ),
            Consumer<DrawingProvider>(
              builder: (context, drawingProvider, child) {
                return Semantics(
                  label: 'Undo',
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => _undo(context),
                    tooltip: 'Undo',
                  ),
                );
              },
            ),
            Consumer<DrawingProvider>(
              builder: (context, drawingProvider, child) {
                return Semantics(
                  label: 'Redo',
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _redo(context),
                    tooltip: 'Redo',
                  ),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: Palette(context),
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: DrawArea(width: width, height: height),
          ),
        ),
      ),
    );
  }
}
