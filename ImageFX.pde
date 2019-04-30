// ImageFX.pde - Wrapper for Image objects and ImageFX, an effects manager

class Image extends GraphicObject {
  
  PImage img;
  String filename;
  // ================================= CONSTRUCTORS =================================
  Image(PImage img, String filename, PVector startPoint, PVector size) {
    super(startPoint, size);
    this.filename = filename;
    this.img = img;
  }
  
  Image(PImage img, String filename, PVector size) {
    super(size);
    this.filename = filename;
    this.img = img;
  } 
  
  // ================================= PUBLIC METHODS =================================
 
  public String name() {
    return "image";
  }
  
  public void updateHSV(HSVMode hsvMode) {
    
    for (int x = 0; x < img.width; ++x) {
      for (int y = 0; y < img.height; ++y) {
        color pixel = img.get(x, y);
        
        HSVData hsvPixel = RGBtoHSV(pixel);
        
        switch (hsvMode) {
          case HUE:
            hsvPixel.hue = canvas.hsv.hue;
            break;
          case SATURATION:
            hsvPixel.saturation = canvas.hsv.saturation;
            break;
          case BRIGHTNESS:
            hsvPixel.value = canvas.hsv.value;
            break;
        }
               
        color newPixel = HSVtoRGB(new HSVData(hsvPixel));
        
        img.set(x, y, newPixel);
      }
    }
  }
  
  public String dataAsString() {
     String data = "image " + filename + startPoint.x + " " + startPoint.y + " " + size.x + " " + size.y + " ";
    
     return data;
  }
  
  // ================================= UTILITY PRIVATE METHODS =================================
  
  protected PVector _getCenter() {
    PVector center = new PVector(super.startPoint.x + this.size.x / 2, super.startPoint.y + this.size.y / 2);
    
    return center;
  }
  
  protected void _specificShapeDraw() {
     image(img, super.startPoint.x, super.startPoint.y, super.size.x, super.size.y);
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

class FXManager {
  
  public void imageToBlackWhite(PImage image) {
    
    color black = color(0, 0, 0);
    color white = color(255, 255, 255);
    
    for (int x = 0; x < image.width; ++x) {
      for (int y = 0; y < image.height; ++y) {
        color pixel = image.get(x, y);
        
        if (red(pixel) < 127 && 
            green(pixel) < 127 && 
            blue(pixel) < 127) {
              
             image.set(x, y, black);
        }
        else {
          image.set(x, y, white);
        }
      }
    }
  }
  
  public void imageToGrayscale(PImage image) {
  
    for (int x = 0; x < image.width; ++x) {
      for (int y = 0; y < image.height; ++y) {
        
        color pixel = image.get(x, y);
              
        image.set(x, y, _averageColour(pixel));
      }
    }
  }
  
  void scaleUpBilinear(PImage sourceImage, PVector destinationImageSize) {
      
    PImage destinationImage = createImage((int)destinationImageSize.x, (int)destinationImageSize.y, RGB);
    
    for (int y = 0; y < destinationImageSize.y; y++) {
        for (int x = 0; x < destinationImageSize.x; x++){
          
          // generate a "parametric coordinate" in the range 0...1 in both
          // x and y.
          float parametricX = (x/(float)destinationImageSize.x);
          float parametricY = (y/(float)destinationImageSize.y); 
            
          color thisPix = _getPixelBilinear(parametricX,parametricY, sourceImage);
         
          destinationImage.set(x,y, thisPix);
        }
      }
      
     sourceImage = destinationImage;
  }
  
  private color _averageColour(color colour) {
    int red = (int)red(colour);
    int green = (int)green(colour);
    int blue = (int)blue(colour);
    
    float average = (red + green + blue) / 3;
    
    return color(average, average, average);
  }  
 
  private float _mantissa(float num) {
    return (num - (int)num);
  }

  private color _getPixelBilinear(float x, float y, PImage img) {
    
    // scale up the paramteric coordinates to match this image's pixel coordinates
    // but keep it floating point
    float scaledX = img.width * x;
    float scaledY = img.height * y;
    
    int xLow = (int)scaledX;
    int yLow = (int)scaledY;
    
    int xLowH = xLow + 1;
    int yLowH = yLow + 1;
    
    // work out the foating point bit of the pixel location
    
    float mantissaX = _mantissa(scaledX);
    float mantissaY = _mantissa(scaledY);
    
    color pixelA = img.get(xLow, yLow);
    color pixelB = img.get(xLowH, yLow);
    color pixelC = img.get(xLow, yLowH);
    color pixelD = img.get(xLowH, yLowH);
    
    float areaA = (1.0 - mantissaX) * (1.0 - mantissaY);
    float areaB = mantissaX * (1 - mantissaY);
    float areaC = (1.0 - mantissaX) * mantissaY;
    float areaD = (mantissaX * mantissaY);
    
    float totalArea = areaA + areaB + areaC + areaD;
    
    float epsilon = 0.0001;
    
    if (  totalArea < 0.0 || totalArea - 1.0 > epsilon ) {
       println("Error: area isn't 1, but " + totalArea + "\n");
    }
  
    float avgRed = areaA * red(pixelA) + 
                   areaB * red(pixelB) + 
                   areaC * red(pixelC) + 
                   areaD * red(pixelD);
                   
    float avgGreen = areaA * green(pixelA) + 
                     areaB * green(pixelB) + 
                     areaC * green(pixelC) + 
                     areaD * green(pixelD);
  
    
    float avgBlue = areaA * blue(pixelA) + 
                    areaB * blue(pixelB) + 
                    areaC * blue(pixelC) + 
                    areaD * blue(pixelD);
  
    return color(avgBlue, avgRed, avgGreen);
  }
}