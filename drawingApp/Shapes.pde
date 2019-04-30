// Shapes.pde - wrapper for shapes classes (Rect, Ellipse)

// border colour for hovered shapes
color selectedObjLineColour = color(25, 25, 25);

abstract class GraphicObject {
  
  PVector startPoint;
  PVector size;

  color lineColour;
  
  float lineWidth;
  float leftmost;
  float rightmost;
  float upmost;
  float downmost;

  boolean selected; 

  GraphicObject(PVector startPoint, color lineColour, float lineWidth, PVector size) {
    this.startPoint = startPoint;
    this.lineColour = lineColour;
    this.lineWidth = lineWidth;
    this.size = abs(size);
    this.selected = false;
  }
  
  GraphicObject(PVector startPoint, color lineColour, float lineWidth) {
    this.startPoint = startPoint;
    this.lineColour = lineColour;
    this.lineWidth = lineWidth;
    this.size = new PVector(1, 1);
    this.selected = false;
  }

  void draw() {

    try { 
      _setLimits();
      _normalisePosition();
      
      if ( !isDrawingMode() && this.selected) {
        stroke(selectedObjLineColour);
      }
      else {
        stroke(lineColour);
      }
      
      strokeWeight(lineWidth);
      specificShapeDraw();
    }
    catch (Exception ignored) {
      println("Couldn't draw shape");
    }
  }
  
  public void updateSize(PVector newSize) {
    size = newSize;
    _setLimits();
    _normalisePosition();
  }

  public void updateSize(float sizeX, float sizeY) {
    size = new PVector(sizeX, sizeY);
    _setLimits();
    _normalisePosition();
  }
  
  public boolean _hasMouseOver() {
      return (mouseX <= abs(rightmost) && mouseY >= abs(upmost) &&
             mouseX >= abs(leftmost) && mouseY <= abs(downmost));
  }
  
  // normalise a shape's position so it doesn't escape the canvas
  private void _normalisePosition() {
    if (leftmost < canvasOffsetX) {
      startPoint.x += (canvasOffsetX - leftmost); 
    }
    
    if (rightmost > width) {
      startPoint.x -= (rightmost - width);
    }
    
    if (upmost < canvasOffsetY) {
      startPoint.y += (canvasOffsetY - upmost);
    }
    
    if (downmost > height) {
      startPoint.y -= (downmost - height);
    }
  }

  public abstract String name();
  // falicitator for shape saving and loading
  public abstract String dataAsString();
  
  // set a shape's upmost, downmost, leftmost and rightmost points
  protected abstract void _setLimits();
  protected abstract void specificShapeDraw();
}

class Ellipse extends GraphicObject {
  
  color fillColour;

  Ellipse(PVector startPoint, color lineColour, color fillColour, float lineWidth, PVector size) {
    super(startPoint, lineColour, lineWidth, size);
    this.fillColour = fillColour;
  }

  Ellipse(PVector startPoint, color lineColour, color fillColour, float lineWidth) {
    super(startPoint, lineColour, lineWidth);
    this.size = new PVector(1, 1);
    this.fillColour = fillColour;
  }

  public String name() {
    return "ellipse";
  }
  
  public String dataAsString() {
    String data = "ellipse " + startPoint.x + " " + startPoint.y + " " + lineColour + " " + fillColour + 
      " " + lineWidth + " " + size.x + " " + size.y;
      
     return data;
  }

  void specificShapeDraw() {
      fill(fillColour);
      ellipse(startPoint.x, startPoint.y, size.x, size.y);
  }
  
  protected void _setLimits() {
    
    PVector normalisedSize = abs(super.size);
    
    float radiusX = normalisedSize.x / 2;
    float radiusY = normalisedSize.y / 2;
    
    super.leftmost = super.startPoint.x - radiusX - super.lineWidth / 2;
    super.rightmost = super.startPoint.x + radiusY + super.lineWidth / 2;
    super.upmost = super.startPoint.y - radiusY - super.lineWidth / 2;
    super.downmost = super.startPoint.y + radiusY + super.lineWidth / 2;
  }
}

class Rectangle extends GraphicObject {
  
  color fillColour;
  
  Rectangle(PVector startPoint, color lineColour, color fillColour, float lineWidth, PVector size) {
    super(startPoint, lineColour, lineWidth, size);
    this.fillColour = fillColour;
  }

  Rectangle(PVector startPoint, color lineColour, color fillColour, float lineWidth) {
    super(startPoint, lineColour, lineWidth);
    this.fillColour = fillColour;
    this.size = new PVector(1, 1);
  }

  public String name() {
    return "rectangle";
  }
  
  public String dataAsString() {
    String data = "rectangle " + startPoint.x + " " + startPoint.y + " " + lineColour + " " + fillColour + 
      " " + lineWidth + " " + size.x + " " + size.y;
      
    return data;
  }
  
  void specificShapeDraw() {
    fill(fillColour); 
    rect(super.startPoint.x, super.startPoint.y, this.size.x, this.size.y);
  }

  protected void _setLimits() {

    if (super.size.x > 0.0) {
      super.leftmost = super.startPoint.x - super.lineWidth / 2;
      super.rightmost = super.startPoint.x + super.size.x + super.lineWidth / 2;
    }
    else {
      super.rightmost = super.startPoint.x - super.lineWidth / 2;
      super.leftmost = super.startPoint.x + super.size.x + super.lineWidth / 2;
    }
    
    if (super.size.y > 0.0) {
      super.upmost = super.startPoint.y - super.lineWidth / 2;
      super.downmost = super.startPoint.y + super.size.y + super.lineWidth / 2; 
    }
    else {
      super.downmost = super.startPoint.y - super.lineWidth / 2;
      super.upmost = super.startPoint.y + super.size.y + super.lineWidth / 2;
    }
  }
}
/*
class Line extends GraphicObject {
  PVector endPoint;
  double lineSize;
  
  Line(PVector a, PVector b, color lineColour, float lineWidth) {
    super(a, lineColour, lineWidth);
    
    endPoint = b;
  }

  public String name() {
    return "line";
  }
  
  public void specificShapeDraw() {
    line(super.startPoint.x, super.startPoint.y, endPoint.x, endPoint.y); 
    lineSize = super.startPoint.dist(this.endPoint);
  }
  
  
  public void updateSize(PVector newSize) {
  }

  public void updateSize(float sizeX, float sizeY) {

  }
  
  protected void _setLimits() {}
}*/