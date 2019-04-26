// drawingApp.psd - main project file wrapping up all the logic

import g4p_controls.*;

GView view2D;
Canvas canvas;
FileManager fileManager;
ShapeFactory shapeFactory;

// ============== DEFAULTS =================

color selectedLineColour = color(255, 0, 0);
color selectedBgColour = color(0, 0, 0);

color bgColour = color(255, 255, 255);

final static float lineWidth = 10;

Modes selectedMode = Modes.RECT;

//  ============== INIT =================
void setup() {
  size(1100, 1100);
  view2D = new GView(this, canvasOffset, canvasOffset, canvasSize, canvasSize, JAVA2D);
  canvas = new Canvas(new PVector(canvasSize, canvasSize));
  shapeFactory = new ShapeFactory();
  fileManager = new FileManager("test.draw");
}

// ============== DRAWING FUNCTIONS =================

void updateView() {
  PGraphics v = view2D.getGraphics();
  v.beginDraw();
  
  clear();
  
  background(bgColour);
  canvas.drawAll();
  v.endDraw();
}

void draw() {
  updateView();
}

void drawShape() {
  
  // lock the object until the mouse's released
  locked = true;
  lockedPoint = new PVector(mouseX, mouseY);

  switch (selectedMode) {
    case RECT:
      lockedObj = new Rectangle(lockedPoint, color(selectedLineColour), color(selectedBgColour), lineWidth);
      break;
     
    case ELLIPSE:
      lockedObj = new Ellipse(lockedPoint, color(selectedLineColour), color(selectedBgColour), lineWidth);
      break;
      
    default:
      return;
  }
  
  canvas.addObject(lockedObj);
}

//  ============== EVENT HANDLING =================

boolean locked = false;

GraphicObject lockedObj;

PVector modifier;
PVector lockedPoint;

/* Handle resize & move actions */
void manipulateShape() {
  
  if (lockedObj != null) {
    locked = true;
    
    switch (selectedMode) {
      case RESIZE:
        lockedPoint = lockedObj.startPoint;
        break;
       
      case MOVE:
        modifier = new PVector(mouseX, mouseY);
        modifier.sub(lockedObj.startPoint);
        break;
        
      default:
        return;
    }
  }
}

void mousePressed() {
 
  if (isDrawingMode()) {
    drawShape();
  }
  else {
    lockedObj = canvas.currentlyHovering();
    // make sure a shape's been locked
    if (lockedObj != null) {
      manipulateShape();
    } 
  }
}

void mouseDragged() {

  if (locked == true && lockedObj != null) {
    // make sure the user cannot draw outside the canvas
    if (mouseX < canvasOffset || 
        mouseY < canvasOffset || 
        mouseX > width || 
        mouseY > height) {
      return;
    }

    PVector mousePos = new PVector(mouseX, mouseY);

    switch (selectedMode) {
      case MOVE:
        mousePos.sub(modifier);
        lockedObj.startPoint = mousePos;
        break;

      default:
        lockedObj.updateSize(mousePos.sub(lockedObj.startPoint));
        break;
    }
  }
}

void mouseReleased() {
  if (locked == true) {
    if (!isDrawingMode()) {
      canvas.addObject(lockedObj);
    }
    // once the mouse's released, reset the locked values
    lockedObj = null;
    locked = false;
  }
}

//  ============== HOTKEYS =================

void keyPressed() {
  
  switch (keyCode) {
    case UP:
      selectedMode = Modes.MOVE;
      break;     
     // e
    case 69:
      selectedMode = Modes.ELLIPSE;
      break;
     // r
    case 82:
      selectedMode = Modes.RECT;
      break;
      
    case DOWN:
      selectedMode = Modes.RESIZE;
      break;
      
    default: 
      fileManager.save();
      break;
  }
}
