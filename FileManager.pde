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
   
   public void loadFile() {
     selectInput("Select a .draw file to proceed:", "loadFileContents", null, this);
   }
   
   /* save the shapes drawn in a file */
   public void save() {
      
      PrintWriter output = createWriter(file);
      
      for (GraphicObject object : canvas.graphicObjects) {
        output.println(object.dataAsString());
      }
      
      output.close();
    }
    // ================ private METHODS ================
    
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