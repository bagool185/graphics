// Canvas.pde - wrapper for the Canvas class (container for all the shapes)

import java.util.ListIterator;

// left and top padding
final static float canvasOffsetX = 176;
final static float canvasOffsetY = 155;
final static int canvasSize = 1024; 
   
class Canvas {
   
  ArrayList<GraphicObject> graphicObjects;
  PVector startPoint;
  PVector size;
  
  color crtColour;
  color crtLineColour;
  ColourMode crtColourMode;
  
  GraphicObject selectedShape;
 
  public Canvas(PVector size) {
    graphicObjects = new ArrayList<GraphicObject>();
    this.startPoint = new PVector(canvasOffsetX, canvasOffsetY);
    this.size = size;
    this.crtColour = this.crtLineColour = color(0, 0, 0);
    this.crtColourMode = ColourMode.FILL;
  }
  
  public void clear() {
    graphicObjects.clear();
  }
  
  private void _updateSelectedShapeColour() {
     
    if (crtColourMode == ColourMode.FILL) {
      switch (selectedShape.name()) {
        case "rectangle":
          ((Rectangle)selectedShape).fillColour = crtColour;
          break;
          
        case "ellipse":
          ((Ellipse)selectedShape).fillColour = crtColour;
          break;
          
        default:
          break;
      }  
    } else {
      selectedShape.lineColour = crtLineColour;
    }
  }
  
  public void updateCrtColour() {
    color newColour = color(redSlider.getValueI(), 
                      greenSlider.getValueI(), 
                      blueSlider.getValueI());
                      
    if (this.crtColourMode == ColourMode.FILL) {
      crtColour = newColour;
    } else {
      crtLineColour = newColour;
    }
    
    if (selectedMode == Modes.SELECT && selectedShape != null) {
      _updateSelectedShapeColour();
    }
  }
  
  public void drawAll() {
    try {
      for (GraphicObject object : graphicObjects) {
        object.draw();
      }
    }
    catch (java.util.ConcurrentModificationException ignored) {
      delay(100);
      drawAll();
    }
  }
  
  public void deleteSelectedShape() {
  
    if (selectedShape != null) {
      graphicObjects.remove(selectedShape);
    } else {
      println("no shape selected");
    }
  }
  
  public void resetSelected() {
    if (selectedShape != null) {
      selectedShape.selected = false;
      selectedShape = null;
    }
  }
  
  public void resetSelects() {
    selectedShape = null;
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