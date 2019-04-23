abstract class GraphicObject {
  
  PVector startPoint;

  color lineColour;
  float lineWidth;
  float leftmost;
  float rightmost;
  float upmost;
  float downmost;


  GraphicObject(PVector startPoint, color lineColour, float lineWidth) {
    this.startPoint = startPoint;
    this.lineColour = lineColour;
    this.lineWidth = lineWidth;
  }

  public void handleMouseEvent(PVector mousePos, String eventType) {
    switch (eventType) {
      case "press":
        _handlePress(mousePos);
        break;
      case "drag":
        _handleDrag(mousePos);
        break;
      case "release":
        _handleRelease(mousePos);
        break;
      default:
        println("Unsupported event type " + eventType);
        break;
    }
  }

  void draw() {

    if (_hasMouseOver()) {
      lineColour = color(0, 0, 0);
    }
    try { 
      _setLimits();
      _normalise();
      stroke(lineColour);
      strokeWeight(lineWidth);
      specificShapeDraw();
    }
    catch (Exception ignored) {
      println("Couldn't draw shape");
    }
  }

  void move(float coordX, float coordY) {
    translate(coordX, coordY);
  }

  void move(PVector movingPoint) {
    translate(movingPoint.x, movingPoint.y);
  }
  
  protected void _normalise() {
    if (leftmost < canvasOffset) {
      startPoint.x += (canvasOffset - leftmost); 
    }
    
    if (rightmost > width) {
      startPoint.x -= (rightmost - width);
    }
    
    if (upmost < canvasOffset) {
      startPoint.y += (canvasOffset - upmost);
    }
    
    if (downmost > height) {
      startPoint.y -= (downmost - height);
    }
  }

  public abstract String name();
  public abstract boolean _hasMouseOver();
  
  protected abstract void _setLimits();
  protected abstract void _handlePress(PVector);
  protected abstract void _handleDrag(PVector);
  protected abstract void _handleRelease(PVector);
  
  protected abstract void specificShapeDraw();
}

class Ellipse extends GraphicObject {
  
  PVector size;
  color fillColour;

  Ellipse(PVector startPoint, color lineColour, color fillColour, float lineWidth, PVector size) {
    super(startPoint, lineColour, lineWidth);
    this.size = size;
    this.fillColour = fillColour;
  }

  Ellipse(PVector startPoint, color lineColour, color fillColour, float lineWidth) {
    super(startPoint, lineColour, lineWidth);
    this.size = new PVector(1, 1);
    this.fillColour = fillColour;
  }

  void _handlePress(PVector mousePos) {}
  void _handleDrag(PVector mousePos) {}
  void _handleRelease(PVector mousePos) {}

  public String name() {
    return "ellipse";
  }

  void specificShapeDraw() {
      fill(fillColour);
      stroke(super.lineColour);
      strokeWeight(super.lineWidth);
      ellipse(startPoint.x, startPoint.y, size.x, size.y);
  }
  
  protected void _setLimits() {
    float radiusX = this.size.x / 2;
    float radiusY = this.size.y / 2;
    
    super.leftmost = super.startPoint.x - radiusX;
    super.rightmost = super.startPoint.x + radiusY;
    super.upmost = super.startPoint.y - radiusY;
    super.downmost = super.startPoint.y + radiusY;
  }
  
  boolean _hasMouseOver() {
    if (mouseX >= (super.startPoint.x - size.x / 2) && 
        mouseX <= (super.startPoint.x + size.x / 2) &&
        mouseY >= (super.startPoint.y - size.y / 2) && 
        mouseY <= (super.startPoint.y + size.y / 2)) {
        
          return true;
      }
      
     return false;
  }
}

class Rectangle extends GraphicObject {
  PVector size;
  color fillColour;
  
  Rectangle(PVector startPoint, color lineColour, color fillColour, float lineWidth, PVector size) {
    super(startPoint, lineColour, lineWidth);
    this.size = size;
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
  
  void specificShapeDraw() {
    fill(fillColour); 
    rect(super.startPoint.x, super.startPoint.y, this.size.x, this.size.y);
  }

  protected void _handlePress(PVector mousePos) {}
  protected void _handleDrag(PVector mousePos) {}
  protected void _handleRelease(PVector mousePos) {}

  protected void _setLimits() {
    super.leftmost = super.startPoint.x;
    super.rightmost = super.startPoint.x + size.x;
    super.upmost = super.startPoint.y;
    super.downmost = super.startPoint.y + size.y;
  }
  
  public void changeLineColour(color lineColour) {
    super.lineColour = lineColour;
  }
  
  public boolean _hasMouseOver() {
    try {
      return (mouseX >= super.startPoint.x && mouseY >= super.startPoint.y &&
              mouseX <= (super.startPoint.x + this.size.x) && mouseY <= (super.startPoint.y + this.size.y));
    }
    catch (Exception ignored) {
      return false;
    }
}

  public void updateSize(PVector newSize) {
    super._normalise();
    size = newSize;
  }

  public void updateSize(float sizeX, float sizeY) {
    super._normalise();
    size = new PVector(sizeX, sizeY);
  }
}

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
  
  public boolean _hasMouseOver() {

    PVector pressedPoint = new PVector(mouseX, mouseY);
    double distanceStart = super.startPoint.dist(pressedPoint);
    double distanceEnd = endPoint.dist(pressedPoint);
  
    return doubleEqual(distanceStart + distanceEnd, lineSize);
  }
  
  protected void _setLimits() {}
  protected void _handlePress(PVector mousePos) {}
  protected void _handleDrag(PVector mousePos) {}
  protected void _handleRelease(PVector mousePos) {}
}
