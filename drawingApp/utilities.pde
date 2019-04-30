// utilities.pde - wrapper for utility functions & classes

// ========== USAGE MODES UTILITIES ========== 

public enum Modes {
  ELLIPSE, RECT, MOVE, RESIZE, SELECT
}

public enum ColourMode {
  FILL, LINE
}

void loadFileCallback() {

}

boolean isDrawingMode() {
  return (selectedMode == Modes.ELLIPSE || selectedMode == Modes.RECT);
}

public boolean isInsideCanvas(PVector coords) {
  return (coords.x >= canvasOffsetX && coords.x <= width && coords.y >= canvasOffsetY && coords.y <= height);
}

public boolean isInsideCanvas(float coordX, float coordY) {
  return (coordX >= canvasOffsetX && coordX <= width && coordY >= canvasOffsetY && coordY <= height);
}

// ========== SHAPE CREATION UTILITIES ========== 

// get the absolute values of a PVector's coordinates
PVector abs(PVector size) {
  return new PVector(abs(size.x), abs(size.y));
}

class ShapeFactory {

  public ShapeFactory() {
  }


  public void createShape(String shapeName, PVector startPoint, color fillColour, color lineColour, float lineWidth, PVector size) {

    GraphicObject newObject = null;

    switch (shapeName) {
    case "rectangle":
      newObject = new Rectangle(startPoint, fillColour, lineColour, lineWidth, size);
      break;

    case "ellipse":
      newObject = new Ellipse(startPoint, fillColour, lineColour, lineWidth, size);
      break;

    default:
      println("Poorly formatted shape data (unsupported shape name): " + shapeName);
      break;
    }
    canvas.addObject(newObject);
  }

  public void createShapeFromString(String shapeData) {
    _parseShapeData(shapeData);
  }

  private void _parseShapeData(String shapeData) {
    /**
     * shape data string format (separated by whitespaces)
     * <shape name> <start point X coordinate> <start point Y coordinate> <fill colour> <border colour> <border width> size x     */
    String[] splitShapeData = shapeData.split(" ");

    if (splitShapeData.length != 8) {
      println("Poorly formatted shape data (not sufficient arguments, should be 8): " + shapeData);
      return;
    }

    try {
      String shapeName = splitShapeData[0];

      PVector startPoint = new PVector(Float.parseFloat(splitShapeData[1]), 
        Float.parseFloat(splitShapeData[2]));



      color fillColour = Integer.parseInt(splitShapeData[3]);
      color lineColour = Integer.parseInt(splitShapeData[4]);

      float lineWidth = Float.parseFloat(splitShapeData[5]);

      PVector size = new PVector(Float.parseFloat(splitShapeData[6]), 
        Float.parseFloat(splitShapeData[7]));

      createShape(shapeName, startPoint, fillColour, lineColour, lineWidth, size);
    }
    catch (Exception e) {
      println("Poorly formatted shape data: " + shapeData);
    }
  }
}