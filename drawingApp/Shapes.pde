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
  
  float rotationAngle;

  GraphicObject(PVector startPoint, color lineColour, float lineWidth, PVector size) {
    this.startPoint = startPoint;
    this.lineColour = lineColour;
    this.lineWidth = lineWidth;
    this.size = abs(size);
    this.selected = false;
    this.rotationAngle = 0.0;
  }
  
  GraphicObject(PVector startPoint, color lineColour, float lineWidth) {
    this.startPoint = startPoint;
    this.lineColour = lineColour;
    this.lineWidth = lineWidth;
    this.size = new PVector(50, 50);
    this.selected = false;
    this.rotationAngle = 0.0;
  }
  
  GraphicObject(PVector startPoint, PVector size) {
     this.startPoint = startPoint;
     this.size = abs(size);
     this.selected = false;
     this.rotationAngle = 0.0;
  }

  void draw() {

    try { 
      _applyRotation();
      _setLimits();
      _normalisePosition();
      pushMatrix();
      
      if (name() != "image") {   
        if ( this.selected ) {
          stroke(selectedObjLineColour);
        }
        else {
          stroke(lineColour);
        }
        strokeWeight(lineWidth);
      }
      
      _specificShapeDraw();
      popMatrix();
      resetMatrix();
    }
    catch (Exception ignored) {
      println("Couldn't draw shape");
    }
  }
  
  private void _applyRotation() {
    
    if (selectedMode == Modes.ROTATE && selected) {
      rotationAngle = knobRotate.getValueF();
    }

    if (rotationAngle != 0.0) {
      PVector center = _getCenter();
      translate(center.x, center.y);
      
      rotate(radians(rotationAngle));
    }
  }
  
  public void scaleBy(float scaleFactor) {
    this.size.mult(scaleFactor);
    this.size.x = this.size.x % width;
    this.size.y = this.size.y % height;
    _setLimits();
    _normalisePosition();
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
  protected abstract PVector _getCenter();
  protected abstract void _specificShapeDraw();
}

class Image extends GraphicObject {
  
  PImage img;
  String filename;
  
  Image(PImage img, String filename, PVector startPoint, PVector size) {
    super(startPoint, size);
    this.img = img;
    this.filename = filename;
  }
  
  Image(PImage img, String filename, PVector startPoint) {
    super(startPoint, new PVector(img.width, img.height));
    this.filename = filename;
    this.img = img;
  }
  
  public String name() {
    return "image";
  }
  
  protected PVector _getCenter() {
    PVector center = new PVector(super.startPoint.x + this.size.x / 2, super.startPoint.y + this.size.y / 2);
    
    return center;
  }
  
  protected void _specificShapeDraw() {
    image(img, super.startPoint.x, super.startPoint.y, super.size.x, super.size.y);
  }
  
  public String dataAsString() {
     String data = "image " + startPoint.x + " " + filename + " " + startPoint.y + " " + size.x + " " + size.y;
       
     return data;
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

class Ellipse extends GraphicObject {
  
  color fillColour;

  Ellipse(PVector startPoint, color lineColour, color fillColour, float lineWidth, PVector size) {
    super(startPoint, lineColour, lineWidth, size);
    this.fillColour = fillColour;
  }

  Ellipse(PVector startPoint, color lineColour, color fillColour, float lineWidth) {
    super(startPoint, lineColour, lineWidth);
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

  protected void _specificShapeDraw() {
      fill(fillColour);
      
      if (rotationAngle != 0.0) {
        ellipse(0, 0, size.x, size.y);
      }
      else {
         ellipse(startPoint.x, startPoint.y, size.x, size.y);
      }
  }
  
  protected PVector _getCenter() {
    return super.startPoint;
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
  }

  public String name() {
    return "rectangle";
  }
  
  public String dataAsString() {
    String data = "rectangle " + startPoint.x + " " + startPoint.y + " " + lineColour + " " + fillColour + 
      " " + lineWidth + " " + size.x + " " + size.y;
      
    return data;
  }
  
  protected PVector _getCenter() {
    PVector center = new PVector(super.startPoint.x + this.size.x / 2, super.startPoint.y + this.size.y / 2);
    
    return center;
  }
  
  protected void _specificShapeDraw() {
  
    fill(fillColour);
    
    if (rotationAngle != 0.0) {
      rect(0, 0, this.size.x, this.size.y);
    }
    else {
      rect(super.startPoint.x, super.startPoint.y, this.size.x, this.size.y);
    }
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