import 'package:flutter/material.dart';

import '../models/draw_actions/draw_actions.dart';
import '../models/drawing.dart';
import '../models/tools.dart';

class DrawingProvider extends ChangeNotifier {
  Drawing? _drawing; // used to create a cached drawing via replay of past actions
  DrawAction _pendingAction = NullAction();
  Tools _toolSelected = Tools.none;
  Color _colorSelected = Colors.blue;

  final List<DrawAction> _pastActions;
  final List<DrawAction> _futureActions;

  final double width;
  final double height;

  DrawingProvider({required this.width, required this.height})
      : _pastActions = [],
        _futureActions = [];

  Drawing get drawing {
    if (_drawing == null) {
      _createCachedDrawing();
    }
    return _drawing!;
  }

  // Sends a notice about a drawing action
  set pendingAction(DrawAction action) {
    _pendingAction = action;
    _invalidateAndNotify();
  }

  DrawAction get pendingAction => _pendingAction;

  // Sends a notice about what tool is selected for drawing
  set toolSelected(Tools aTool) {
    _toolSelected = aTool;
    _invalidateAndNotify();
  }

  Tools get toolSelected => _toolSelected;

  // To know what color is selected for drawing
  set colorSelected(Color color) {
    _colorSelected = color;
    _invalidateAndNotify();
  }
  Color get colorSelected => _colorSelected;

  //   Your implementation should make _drawing be a 
  //   new Drawing using either all the pastActions or the pastActions 
  //   since the last ClearAction.
  _createCachedDrawing() {
    // Get the index to start drawing
    int create = _pastActions.lastIndexWhere((action) => action is ClearAction) != -1 
        ? _pastActions.lastIndexWhere((action) => action is ClearAction) + 1 : 0;

    _drawing = Drawing(
      _pastActions.sublist(create), 
      width: width,  
      height: height
    );

  }

  // Notify drawing changes and invalidates the current drawing
  _invalidateAndNotify() {
    _drawing = null;
    notifyListeners();
  }

  // Add the new action to the past actions list, then clear future actions list
  add(DrawAction action) {
    _pastActions.add(action);
    _futureActions.clear(); 
    _invalidateAndNotify();

  }

  // Past action gets added to redo future actions list
  undo() {
    if (_pastActions.isNotEmpty) {
      _futureActions.insert(0, _pastActions.removeLast());
      _invalidateAndNotify();
    }

  }

  // The action gets added back to undo past actions list
  redo() {
    if (_futureActions.isNotEmpty) {
      _pastActions.add(_futureActions.removeAt(0));
      _invalidateAndNotify();
    }
  }

  // Clears past actions list by moving them to future actions list
  clear() {
    _futureActions.addAll(_pastActions);
    _pastActions.clear();
    _invalidateAndNotify();
  }
}
