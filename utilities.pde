// utilities.pde - wrapper for utility functions & classes

// ========== USAGE MODES UTILITIES ========== 

public enum Modes {
  ELLIPSE, RECT, MOVE, RESIZE, SELECT, ROTATE, LINE
}

public enum ColourMode {
  FILL, LINE
}

public enum HSVMode {
  HUE, SATURATION, BRIGHTNESS
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

// ========== COLOUR UTILITIES ========== 
class HSVData {

  public float hue;
  public float saturation;
  public float value;
  
  
  public HSVData() {
    hue = saturation = value = 0.0f;
  }
  
  public HSVData(color newHSV) {
    hue = (red(newHSV) / 255f) * 180f;
    saturation = (green(newHSV) / 255) * 50f; 
    value = (blue(newHSV) / 255f) * 100f;
    _sanitiseData();  
  }
  
  public HSVData(HSVData hsv) {
    hue = hsv.hue;
    saturation = hsv.saturation;
    value = hsv.value;
    _sanitiseData();
  }
  
  public HSVData(float h, float s, float v) {
    hue = h;
    saturation = s;
    value = v;
    _sanitiseData();
  }
  
  
  private void _sanitiseData() {
    /**
      * make sure the HSV values are within set boundaries
      * -180.0 <= hue <= 180.0
      * -50.0 <= saturation <= 50.0 
      * -100.0 <= brightness(value) <= 100.0
      */
    
     if (hue < -180f) {
       hue = -180f;
     }
    
    if (hue > 180f) {
      hue = 180f;
    }
    
    if (saturation > 50f) {
      saturation = 50f;
    }
    
    if (saturation < -50f) {
      saturation = -50f;
    }
    
    if (value < -100f) {
      value = -100f;
    }
    
    if (value > 100f) {
      value = 100f;
    }
  }
}

HSVData RGBtoHSV(color colour) {
  return RGBtoHSV((int)red(colour), (int)green(colour), (int)blue(colour));
}

HSVData RGBtoHSV(int r, int g, int b)
{
   int minRGB = min( r, g, b );
   int maxRGB = max( r, g, b );
   
   float value = maxRGB / 255f; 
   
   int delta = maxRGB - minRGB;
   
   float saturation;

   if( maxRGB != 0 ) {
    // saturation is the difference between the smallest R,G or B value, and the biggest
     saturation = (delta / (float)maxRGB); 
   }
   else {  // its black, so we don't know the hue
     return new HSVData(-1, 0, 0);
   }
  // now work out the hue by finding out where it lies on the spectrum
   
  float hue = 0.0;
  
  if (delta == 0) {
    delta = 1;
  }

  if( b == maxRGB ) hue = 4 + ( r - g ) / delta;   // between magenta, blue, cyan
  if( g == maxRGB ) hue = 2 + ( b - r ) / delta;   // between cyan, green, yellow
  if( r == maxRGB ) hue = ( g - b ) / delta;       // between yellow, Red, magenta
  
  // the above produce a hue in the range -6...6, 
  // where 0 is magenta, 1 is red, 2 is yellow, 3 is green, 4 is cyan, 5 is blue and 6 is back to magenta 
  // Multiply the above by 60 to give degrees
  hue = hue * 60;
   
  if( hue < 0 ) hue += 360.0;
   
  return new HSVData(hue, saturation, value);
}

color HSVtoRGB(HSVData hsv) {
  return HSVtoRGB(hsv.hue, hsv.saturation, hsv.value);
}

color HSVtoRGB(float hue, float sat, float val)
{
    float v;
    float red, green, blue;
    float m;
    float sv;
    int sextant;
    float fract, vsf, mid1, mid2;

    red = val;   // default to gray
    green = val;
    blue = val;
    v = (val <= 0.5) ? (val * (1.0 + sat)) : (val + sat - val * sat);
    m = val + val - v;
    sv = (v - m) / v;
    hue /= 60.0;  //get into range 0..6
    sextant = floor(hue);  // int32 rounds up or down.
    fract = hue - sextant;
    vsf = v * sv * fract;
    mid1 = m + vsf;
    mid2 = v - vsf;

    if (v > 0)
    {
        switch (sextant)
        {
            case 0: red = v; green = mid1; blue = m; break;
            case 1: red = mid2; green = v; blue = m; break;
            case 2: red = m; green = v; blue = mid1; break;
            case 3: red = m; green = mid2; blue = v; break;
            case 4: red = mid1; green = m; blue = v; break;
            case 5: red = v; green = m; blue = mid2; break;
        }
    }
    return color(red * 255, green * 255, blue * 255);
}


// ========== SHAPE CREATION UTILITIES ========== 

// get the absolute values of a PVector's coordinates
PVector abs(PVector size) {
  return new PVector(abs(size.x), abs(size.y));
}

class ShapeFactory {

  public ShapeFactory() {
  }
  
  public void createImage(String filename, PVector startPoint, PVector size) {
    
    PImage img = loadImage(filename);
    
    Image newImage = new Image(img, filename, startPoint, size);
    
    canvas.addObject(newImage);
  }
  
  public void createLine(PVector startPoint, PVector endPoint, color lineColour, float lineWidth) {
    Line newLine = new Line(startPoint, endPoint, lineColour, lineWidth);
    canvas.addObject(newLine);
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
  
  private void _parseLine(String[] splitShapeData) {
      PVector startPoint = new PVector(Float.parseFloat(splitShapeData[1]), 
        Float.parseFloat(splitShapeData[2]));
    
      PVector endPoint = new PVector(Float.parseFloat(splitShapeData[3]), 
        Float.parseFloat(splitShapeData[4]));
      
      color lineColour = Integer.parseInt(splitShapeData[5]);
      float lineWidth = Float.parseFloat(splitShapeData[6]);
      
      createLine(startPoint, endPoint, lineColour, lineWidth);
  }
  
  private void _parseFullShape(String[] splitShapeData) {
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
  
  private void _parseImage(String[] splitShapeData) {
    String filename = splitShapeData[1];

    PVector startPoint = new PVector(Float.parseFloat(splitShapeData[2]), 
      Float.parseFloat(splitShapeData[3]));
          
    PVector size = new PVector(Float.parseFloat(splitShapeData[4]), 
      Float.parseFloat(splitShapeData[5]));
      
   
    createImage(filename, startPoint, size);
  }
  

  private void _parseShapeData(String shapeData) {
    /**
     * shape data string format (separated by whitespaces)
     * <shape name> <start point X coordinate> <start point Y coordinate> <fill colour> <border colour> <border width> <width> <height>    
     * "line" <start point X coordinate> <start point Y coordinate> <end point X coordinate> <end point Y coordinate> <border colour> <border width>
     * "image" <path to image> <start point X coordinate> <start point Y coordinate> <end point X coordinate> <end point Y coordinate>
     */
    String[] splitShapeData = shapeData.split(" ");

    if (splitShapeData.length != 8 && splitShapeData.length != 6 && splitShapeData.length != 4) {
      println("Poorly formatted shape data: " + shapeData);
      return;
    }

    try {
      if (splitShapeData.length == 8) {
       
        String shapeName = splitShapeData[0];
        
        if (shapeName != "line") {
           _parseFullShape(splitShapeData);
        }
        else {
          _parseLine(splitShapeData);
        }
      }
      else  {
         _parseImage(splitShapeData);
      }
    }
    catch (Exception e) {
      println("Poorly formatted shape data: " + shapeData);
    }
  }
}