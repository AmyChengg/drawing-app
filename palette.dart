import 'package:drawing_with_undo/models/tools.dart';
import 'package:drawing_with_undo/providers/drawing_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Palette extends StatelessWidget {
  const Palette(BuildContext context, {super.key});

  // Shows a list of clickable elements for line, stroke, and oval drawing tools. 
  // Also shows buttons to choose different colors with the drawing tool.
  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, drawingProvider, unchangingChild) => ListView(
        scrollDirection: Axis.vertical,
        children: [
          const DrawerHeader(
            child: Text('Tools and Colors'),
          ),
          _buildToolButton(name: 'Line', icon: Icons.timeline_sharp, tool: Tools.line, provider: drawingProvider),
          _buildToolButton(name: 'Stroke', icon: Icons.brush, tool: Tools.stroke, provider: drawingProvider),
          // Add missing tools here: oval
          _buildToolButton(name: 'Oval', icon: Icons.circle, tool: Tools.oval, provider: drawingProvider),
          const Divider(),
          _buildColorButton('Red', Colors.red, drawingProvider),
          _buildColorButton('Green', Colors.green, drawingProvider),
          // Add more colors here
          _buildColorButton('Blue', Colors.blue, drawingProvider),
          _buildColorButton('Yellow', Colors.yellow, drawingProvider),
          _buildColorButton('White', Colors.white, drawingProvider),
          _buildColorButton('Purple', Colors.purple, drawingProvider),
          _buildColorButton('Orange', Colors.orange, drawingProvider),
          _buildColorButton('Black', Colors.black, drawingProvider),
        ],
      ),
    );
  }

  // Method for tapping the drawing tool, and visibly sets the tool to that chosen drawing tool with Semantics.
  Widget _buildToolButton({required String name, required IconData icon, required Tools tool, required DrawingProvider provider}) {
    bool toolSelect = provider.toolSelected == tool;
    return Semantics(
      label: name,
      button: true,
      selected: toolSelect,
      child: InkWell(
        onTap: () {
          // If drawing tool is already selected, set tool to Tools.none
          provider.toolSelected = toolSelect ? Tools.none : tool;
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: toolSelect ? Colors.grey : Colors.transparent,
          child: Row(
            children: [
              Icon(icon, color: toolSelect ? Colors.black : Colors.grey),
              const SizedBox(width: 6.0),
              Text(name, style: TextStyle(color: toolSelect ? Colors.black : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // Method for tapping a color option and visibly sets the color to that chosen color.
  Widget _buildColorButton(String name, Color color,  DrawingProvider provider) {
    bool tapSelect = provider.colorSelected == color;
    return Semantics(
      label: name,
      button: true,
      selected: tapSelect,
      child: InkWell(
        onTap: () {
          provider.colorSelected = color;
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          color: tapSelect ? color.withOpacity(0.1) : Colors.transparent,
          child: Row(
            children: [
              Icon(Icons.circle, color: color),
              const SizedBox(width: 6.0),
              Text(name, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
