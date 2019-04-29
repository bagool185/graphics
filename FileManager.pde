// FileManager.pde - wrapper for the FileManager class (handler for saving and loading .draw files)

import java.io.BufferedWriter;
import java.io.FileWriter;

class FileManager {
  
    String fileName;
    
    // ================ CONSTRUCTORS ================
  
    FileManager() {
      _generateNewFile();
    }
    
    FileManager(String fileName) {
      this.fileName = fileName;
      
      if (_isProjectFile()) {
        _loadContents();
      } else {
        _generateNewFile();
      }
    }
    
    // ================ PUBLIC METHODS ================
   
   /* save the shapes drawn in a file */
   public void save() {
      
      PrintWriter output = createWriter(fileName);
      
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
    private void _loadContents() {
      BufferedReader reader = createReader(fileName);
      String line;
      
      try {
        while ( (line = reader.readLine()) != null ) {
          shapeFactory.createShapeFromString(line);
        } 
      }
      catch(IOException e) {
        println("Couldn't load file's contents");
        e.printStackTrace();        
      }
    }
    
    private void _generateNewFile() {
      fileName = hour() + "-" + minute() + "-" + second() + ".draw";
    }
    
    private boolean _exists() { 
      File testFile = new File(dataPath(fileName));
      
      return (testFile.exists() && !testFile.isDirectory());
    }
    
    private boolean _isProjectFile() {
      
      if (!fileName.endsWith(".draw")) {
        println(fileName + " doesn't have a .draw extension and it's not supported. Opening a new file.");
        return false;
      }
      
      if ( ! _exists() )  {
         
        println("A file with the name " + fileName + " couldn't be found");
        return false;
      }
      
      BufferedReader reader = createReader(fileName);
      String line;
      
      try {
        line = reader.readLine();
        reader.close();
      } catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      
      return (line != null);
    }
}