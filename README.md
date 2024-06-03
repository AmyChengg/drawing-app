# Drawing App
Created from Dart to draw shapes and strokes on a canvas. Features include clear, undo, and redo actions. 

### Resources Used
I used the flutter link for AppBar. I refreshed my memory of icon buttons by looking back to the Flutter documentation. I also looked at the Flutter documentations for semantics, tools, and InkWell widgets.

### New Learnings
I learned how to use Semantics to label the clear, undo, and redo buttons. I also learned how to use indices and lists to keep track of the user's past and current drawing actions. I can use the new knowledge to make an advanced drawing app.

To explain what the covariant keyword means, why this @override is legal, and what the logic behind this implementation of shouldRepaint is: The covariant keyword allows us to disable the type-check so it does not violate the other contract in place. The override is legal because covariant allows us to use the method instead of the other method since the shouldRepaint method is higher up in the hierarchy. The logic behind this implementation is to returns whether the drawing in old delegate is the same as the current delegate or not.

### Challenges
One thing that was hard about doing this assignment is coding the drawing tool and color to be selected. The interface was done for the tool and color options, but I couldn't select them. I worked through this challenge by looking at the starter code for hints on implementation. This is a strategy that I can do if I'm ever stuck on an implementation problem.

### Acknowledgements
This app is created for an assignment in a University of Washington course.
