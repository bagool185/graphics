/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void btnRect_click1(GButton source, GEvent event) { //_CODE_:btnRect:989503:
  selectedMode = Modes.RECT;
} //_CODE_:btnRect:989503:

public void btnEllipse_click1(GButton source, GEvent event) { //_CODE_:btnEllipse:537615:
  selectedMode = Modes.ELLIPSE;
} //_CODE_:btnEllipse:537615:

public void btnMove_click1(GButton source, GEvent event) { //_CODE_:btnMove:260513:
  selectedMode = Modes.MOVE;
} //_CODE_:btnMove:260513:

public void btnResize_click1(GButton source, GEvent event) { //_CODE_:btnResize:784514:
  selectedMode = Modes.RESIZE;
} //_CODE_:btnResize:784514:

public void listFile_click1(GDropList source, GEvent event) { //_CODE_:listFile:318425:

  switch (listFile.getSelectedText()) {
    case "Save":
      fileManager.save();
      break;
    case "Load .draw file":
      fileManager.loadProjectFile();
      break;
      
    case "Load image":
      break;
  }
} //_CODE_:listFile:318425:

public void redSlider_change1(GCustomSlider source, GEvent event) { //_CODE_:redSlider:577591:
  canvas.updateCrtColour();
  
  if (selectedMode == Modes.SELECT) {
    
  }
} //_CODE_:redSlider:577591:

public void greenSlider_change1(GCustomSlider source, GEvent event) { //_CODE_:greenSlider:721115:
  canvas.updateCrtColour();
} //_CODE_:greenSlider:721115:

public void blueSlider_change1(GCustomSlider source, GEvent event) { //_CODE_:blueSlider:794197:
  canvas.updateCrtColour();
} //_CODE_:blueSlider:794197:

public void optFillColour_clicked1(GOption source, GEvent event) { //_CODE_:optFillColour:672283:
  canvas.updateCrtColour();
  canvas.crtColourMode = ColourMode.FILL;
} //_CODE_:optFillColour:672283:

public void optLineColour_clicked1(GOption source, GEvent event) { //_CODE_:optLineColour:690630:
  canvas.updateCrtColour();
  canvas.crtColourMode = ColourMode.LINE;
  
} //_CODE_:optLineColour:690630:

public void btnSelectMode_click1(GButton source, GEvent event) { //_CODE_:btnSelectMode:390936:
  selectedMode = Modes.SELECT;
} //_CODE_:btnSelectMode:390936:

public void btnDeleteShape_click1(GButton source, GEvent event) { //_CODE_:btnDeleteShape:956774:
  canvas.deleteSelectedShape();
} //_CODE_:btnDeleteShape:956774:

public void scaleShape_change1(GSlider source, GEvent event) { //_CODE_:scaleShape:307988:
  if (canvas.selectedShape != null) {
    canvas.selectedShape.scaleBy(source.getValueF());
  }
} //_CODE_:scaleShape:307988:

public void knobRotate_turn1(GKnob source, GEvent event) { //_CODE_:knobRotate:249962:
  selectedMode = Modes.ROTATE;
} //_CODE_:knobRotate:249962:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  btnRect = new GButton(this, 21, 63, 80, 30);
  btnRect.setText("Rect");
  btnRect.setTextBold();
  btnRect.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  btnRect.addEventHandler(this, "btnRect_click1");
  btnEllipse = new GButton(this, 22, 130, 80, 30);
  btnEllipse.setText("Ellipse");
  btnEllipse.setTextBold();
  btnEllipse.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  btnEllipse.addEventHandler(this, "btnEllipse_click1");
  btnMove = new GButton(this, 23, 197, 80, 30);
  btnMove.setText("Move mode");
  btnMove.setTextBold();
  btnMove.addEventHandler(this, "btnMove_click1");
  btnResize = new GButton(this, 22, 261, 80, 30);
  btnResize.setText("Resize mode");
  btnResize.setTextBold();
  btnResize.addEventHandler(this, "btnResize_click1");
  listFile = new GDropList(this, 200, 21, 90, 80, 3, 10);
  listFile.setItems(loadStrings("list_318425"), 0);
  listFile.addEventHandler(this, "listFile_click1");
  canvasView = new GView(this, 174, 152, 958, 913, JAVA2D);
  redSlider = new GCustomSlider(this, 354, 25, 100, 50, "grey_blue");
  redSlider.setShowValue(true);
  redSlider.setShowLimits(true);
  redSlider.setLimits(0, 0, 255);
  redSlider.setNbrTicks(255);
  redSlider.setShowTicks(true);
  redSlider.setNumberFormat(G4P.INTEGER, 0);
  redSlider.setLocalColorScheme(GCScheme.RED_SCHEME);
  redSlider.setOpaque(false);
  redSlider.addEventHandler(this, "redSlider_change1");
  greenSlider = new GCustomSlider(this, 471, 25, 100, 50, "grey_blue");
  greenSlider.setShowValue(true);
  greenSlider.setShowLimits(true);
  greenSlider.setLimits(0, 0, 255);
  greenSlider.setNbrTicks(255);
  greenSlider.setShowTicks(true);
  greenSlider.setNumberFormat(G4P.INTEGER, 0);
  greenSlider.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  greenSlider.setOpaque(false);
  greenSlider.addEventHandler(this, "greenSlider_change1");
  blueSlider = new GCustomSlider(this, 582, 25, 100, 50, "grey_blue");
  blueSlider.setShowValue(true);
  blueSlider.setShowLimits(true);
  blueSlider.setLimits(0, 0, 255);
  blueSlider.setNbrTicks(255);
  blueSlider.setShowTicks(true);
  blueSlider.setNumberFormat(G4P.INTEGER, 0);
  blueSlider.setOpaque(false);
  blueSlider.addEventHandler(this, "blueSlider_change1");
  togGroup1 = new GToggleGroup();
  optFillColour = new GOption(this, 350, 104, 120, 20);
  optFillColour.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  optFillColour.setText("Fill Colour");
  optFillColour.setOpaque(false);
  optFillColour.addEventHandler(this, "optFillColour_clicked1");
  optLineColour = new GOption(this, 504, 105, 120, 20);
  optLineColour.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  optLineColour.setText("Line Colour");
  optLineColour.setOpaque(false);
  optLineColour.addEventHandler(this, "optLineColour_clicked1");
  togGroup1.addControl(optFillColour);
  optFillColour.setSelected(true);
  togGroup1.addControl(optLineColour);
  btnSelectMode = new GButton(this, 22, 326, 80, 30);
  btnSelectMode.setText("Select shape mode");
  btnSelectMode.setTextBold();
  btnSelectMode.addEventHandler(this, "btnSelectMode_click1");
  btnDeleteShape = new GButton(this, 21, 384, 80, 48);
  btnDeleteShape.setText("Delete selected shape");
  btnDeleteShape.setTextBold();
  btnDeleteShape.setLocalColorScheme(GCScheme.RED_SCHEME);
  btnDeleteShape.addEventHandler(this, "btnDeleteShape_click1");
  scaleShape = new GSlider(this, 17, 497, 100, 40, 10.0);
  scaleShape.setShowValue(true);
  scaleShape.setShowLimits(true);
  scaleShape.setLimits(1.0, 0.0, 3.0);
  scaleShape.setNumberFormat(G4P.DECIMAL, 2);
  scaleShape.setOpaque(false);
  scaleShape.addEventHandler(this, "scaleShape_change1");
  lblScale = new GLabel(this, 19, 446, 80, 41);
  lblScale.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblScale.setText("Scale selected shape");
  lblScale.setTextBold();
  lblScale.setOpaque(false);
  knobRotate = new GKnob(this, 31, 619, 60, 60, 0.8);
  knobRotate.setTurnRange(90, 90);
  knobRotate.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knobRotate.setSensitivity(1);
  knobRotate.setShowArcOnly(false);
  knobRotate.setOverArcOnly(true);
  knobRotate.setIncludeOverBezel(true);
  knobRotate.setShowTrack(true);
  knobRotate.setLimits(0.0, 0.0, 360.0);
  knobRotate.setShowTicks(true);
  knobRotate.setOpaque(false);
  knobRotate.addEventHandler(this, "knobRotate_turn1");
  lblRotateShape = new GLabel(this, 23, 563, 77, 48);
  lblRotateShape.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  lblRotateShape.setText("Rotate selected shape");
  lblRotateShape.setTextBold();
  lblRotateShape.setOpaque(false);
}

// Variable declarations 
// autogenerated do not edit
GButton btnRect; 
GButton btnEllipse; 
GButton btnMove; 
GButton btnResize; 
GDropList listFile; 
GView canvasView; 
GCustomSlider redSlider; 
GCustomSlider greenSlider; 
GCustomSlider blueSlider; 
GToggleGroup togGroup1; 
GOption optFillColour; 
GOption optLineColour; 
GButton btnSelectMode; 
GButton btnDeleteShape; 
GSlider scaleShape; 
GLabel lblScale; 
GKnob knobRotate; 
GLabel lblRotateShape; 