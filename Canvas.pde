// Canvas.pde - wrapper for the Canvas class (container for all the shapes)

import java.util.ListIterator;

// left and top padding
final static float canvasOffset = 124;
final static int canvasSize = 1024; 
   
class Canvas {
   
  ArrayList<GraphicObject> graphicObjects;
  PVector startPoint;
  PVector size;
 
  public Canvas(PVector size) {
    graphicObjects = new ArrayList<GraphicObject>();
    this.startPoint = new PVector(0, 0);
    this.size = size;
  }
  
  public void drawAll() {
    for (GraphicObject object : graphicObjects) {
      object.draw();
    }
  }
  
  public void addObject(GraphicObject object) {
    if (object != null) {
      graphicObjects.add(object);
    }
  }
  /**
    * Return the shape being hovered over at a certain moment
    * or null if there's no such shape.
    */
  public GraphicObject currentlyHovering() {
    // iterate from last to first in order to preserve the z-index
    ListIterator<GraphicObject> it = graphicObjects.listIterator(graphicObjects.size());

    while (it.hasPrevious()) {
      
      try {
        final GraphicObject obj = it.previous();
        
        if (obj._hasMouseOver()) {
          return obj;
        }
      }
      catch (Exception ignored) { }
    }
    
    return null;
  }
}
