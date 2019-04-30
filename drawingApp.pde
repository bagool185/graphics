// drawingApp.pde - main project file wrapping up all the logic

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

final static float coordX = 500;
final static float coordY = 50;

//  ============== INIT =================
void setup() {
  size(1100, 1100);
  canvas = new Canvas(new PVector(canvasSize, canvasSize));
  shapeFactory = new ShapeFactory();
  fileManager = new FileManager();
  createGUI();
}

// ============== DRAWING FUNCTIONS =================

void drawCrtColourSquare() {
  strokeWeight(0);
  fill( (canvas.crtColourMode == ColourMode.FILL) ? canvas.crtColour : canvas.crtLineColour);
  rect(720, 30, 50, 50);
}

void updateView() {
  PGraphics canvasGraphics = canvasView.getGraphics();
  canvasGraphics.beginDraw();
 
  clear();
 
  background(bgColour);
  
  drawCrtColourSquare();
  
  canvas.drawAll();
  canvasGraphics.endDraw();
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
      lockedObj = new Rectangle(lockedPoint, color(canvas.crtLineColour), color(canvas.crtColour), lineWidth);
      break;
     
    case ELLIPSE:
      lockedObj = new Ellipse(lockedPoint,  color(canvas.crtLineColour), color(canvas.crtColour), lineWidth);
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
        
      case SELECT:
        canvas.resetSelects();
        lockedObj.selected = true;
        canvas.selectedShape = lockedObj;
        break;
        
      default:
        return;
    }
  }
}

void mousePressed() {
  
  if (isInsideCanvas(mouseX, mouseY)) {
    
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
  } else {
    btnMove.setEnabled(true);
  }
}

void mouseDragged() {

  if (locked == true && lockedObj != null) {
    // make sure the user cannot draw outside the canvas
    if (mouseX < canvasOffsetX || 
        mouseY < canvasOffsetY || 
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
        
      case SELECT:
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
      //selectedMode = Modes.MOVE;
      btnMove.setEnabled(true);
      break;     
     // e
    case 69:
      //selectedMode = Modes.ELLIPSE;
      btnEllipse.setEnabled(true);
      break;
     // r
    case 82:
      //selectedMode = Modes.RECT;
      btnRect.setEnabled(true);
      break;
      
    case DOWN:
      selectedMode = Modes.RESIZE;
      break;
      
    default: 
      break;
  }
}