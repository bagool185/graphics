// FileManager.pde - wrapper for the FileManager class (handler for saving and loading .draw files)

import java.io.BufferedWriter;
import java.io.FileWriter;

public class FileManager {
  
    File file;
    
    // ================ CONSTRUCTORS ================
  
    FileManager() {
      _generateNewFile();
    }

    // ================ PUBLIC METHODS ================
   
   public void loadFile(String type) {
     switch (type) {
       case "project":
         selectInput("Select a .draw file to proceed:", "loadFileContents", null, this);
         break;
         
       case "image":
         selectInput("Select a (.jpg|.png) file to proceed:", "loadImageFile", null, this);
         break;
     }
   }
   
   private boolean _isSupportedImageFile(String filename) {
     
     String[] validExtensions = {".png", ".jpg", ".jpeg"};
     
     for (String extension : validExtensions) {
       if (filename.endsWith(extension)) {
         return true;
       }
     }
    
     println(filename + " is not a supported image type. Please choose from: (*.png|*.jpg|*.jpeg)");
    
     return false;
   }
   
   public void loadImageFile(File image) {
     
     if (image != null && _isSupportedImageFile(image.getName()) ) {
       
       String imageName = image.getName();       
       PImage img = loadImage(imageName);
       
       if (img != null && img.width > 0 && img.height > 0) {
         Image newImg = new Image( img, imageName, new PVector(500, 500) );
         
         canvas.addObject(newImg);
       }
     }
   }
   
   /* save the shapes drawn in a file */
   public void save() {
      
      PrintWriter output = createWriter(file.getName());
      
      for (GraphicObject object : canvas.graphicObjects) {
        output.println(object.dataAsString());
      }
      
      output.close();
    }
   
   
    // ================ UTILITY PRIVATE METHODS ================
    
    /**
      * create new shapes based on the given file's contents and 
      * add them to the canvas 
      */
    public void loadFileContents(File loadedFile) {
      
      if (loadedFile != null) {
        
         if (_isProjectFile()) {  
           this.file = loadedFile;
           BufferedReader reader = createReader(loadedFile);
           String line;
          
           try {
             canvas.clear();
             while ( (line = reader.readLine()) != null ) {
               shapeFactory.createShapeFromString(line);
             } 
           }
           catch(IOException e) {
             println("Couldn't load file's contents");
             e.printStackTrace();        
           }
         }
       }     
    }
    
    private void _generateNewFile() {
      this.file = new File(hour() + "-" + minute() + "-" + second() + ".draw");
    }
    
    private boolean _isProjectFile() {
      
      if (!this.file.getName().endsWith(".draw")) {
        println(this.file.getName() + " doesn't have a .draw extension and it's not supported. Opening a new file.");
        return false;
      }
      
      return true;
    }
}