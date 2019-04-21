
import g4p_controls.*;

GView view2D;

Canvas canvas;

PVector point1;
PVector point2;

color selectedLineColour = color(255, 0, 0);
color selectedBgColour = color(0, 0, 0);

final static float lineWidth = 10;

String selectedMode = "rect";
String drawMode = "rect";
  
Line line;
Rectangle rect;

void setup() {
  size(1100, 1100);
  colorMode(RGB, 100);
  
  view2D = new GView(this, canvasOffset, canvasOffset, canvasSize, canvasSize, JAVA2D);
  canvas = new Canvas(new PVector(canvasSize, canvasSize));

  canvas.save();
}

void updateView() {
  PGraphics v = view2D.getGraphics();
  v.beginDraw();
  clear();
  background(255, 255, 255);
  canvas.drawAll();
  v.endDraw();
}

void draw() {
  updateView();
}

boolean locked = false;

GraphicObject lockedObj;

PVector modifier;
PVector lockedPoint;

void mousePressedRect() {
  switch (selectedMode) {
    case "rect":
      locked = true;
      lockedPoint = new PVector(mouseX, mouseY);

      lockedObj = new Rectangle(lockedPoint, color(selectedLineColour), color(selectedBgColour), lineWidth);
    
      canvas.addObject(lockedObj);

      break;

    case "resize":
      if (lockedObj != null) {
        locked = true;
        lockedPoint = lockedObj.startPoint;
      }
      break;

    case "move":
      if (lockedObj != null) {
        locked = true;
        modifier = new PVector(mouseX, mouseY);
        modifier.sub(lockedObj.startPoint);
      }
      break;
  }
}

void mousePressedEllipse() {

}

void mousePressed() {
  lockedObj = canvas.currentlyHovering();

  if (lockedObj != null) {
    switch (lockedObj.name()) {
      case "rectangle":
        mousePressedRect();
        println("rect");
        break;
      case "ellipse":
        mousePressedEllipse();
        println("ellipse");
        break;
    }  
  } 
  else {
    mousePressedRect();
  }


}

void keyPressed() {
  if (keyCode == UP) {
    selectedMode = "move";
  } else if (keyCode == DOWN) {
    selectedMode = "rect";
  } else {
    selectedMode = "resize";
  }
}

void mouseDragged() {

  if (locked == true) {

    if (mouseX < canvasOffset || mouseY < canvasOffset) {
      return;
    }

    PVector mousePos = new PVector(mouseX, mouseY);

    switch (selectedMode) {
      case "rect":
      case "resize":

        ((Rectangle)lockedObj).updateSize(mousePos.sub(lockedObj.startPoint));
        break;

      case "move":
        mousePos.sub(modifier);
        lockedObj.startPoint = mousePos;
        break;
    }
  }
}

void mouseReleased() {
  if (locked == true) {

    locked = false;
  }
}
